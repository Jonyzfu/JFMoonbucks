//
//  JFPaymentViewController.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFPaymentViewController.h"
#import "JFCheckoutCart.h"
#import "JFEmailManager.h"

#import "JFPaymentCardCell.h"
#import "JFPaymentDateCell.h"

#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD.h"

#define BackendChargeURLString @"https://moonbucks.herokuapp.com"

@interface JFPaymentViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, JFBackendChargingDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIButton *completeButton;

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *expirationDateTextField;
@property (strong, nonatomic) UITextField *cardNumber;
@property (strong, nonatomic) UITextField *CVCNumber;

@property (strong, nonatomic) NSArray *monthArray;
@property (strong, nonatomic) NSNumber *selectedMonth;
@property (strong, nonatomic) NSNumber *selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;

@property (strong, nonatomic) AFJSONRequestSerializer *httpSerializer;

@property (strong, nonatomic) STPCard *stripeCard;
- (IBAction)completeButtonTapped:(id)sender;

@end

@implementation JFPaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
                        @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
                        @"10 - October", @"11 - November", @"12 - December"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stripe

- (IBAction)completeButtonTapped:(id)sender {
    // allocate and initialize an instance of STPCard and populate its properties.
    if (![Stripe defaultPublishableKey]) {
        NSError *error = [NSError errorWithDomain:StripeDomain
                                             code:STPInvalidRequestError
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey : @"Please specify a Stripe Publishable Key"
                                                    }];
        [self paymentViewController:self didFinish:error];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.stripeCard = [[STPCard alloc] init];
    self.stripeCard.name = self.nameTextField.text;
    self.stripeCard.number = self.cardNumber.text;
    self.stripeCard.cvc = self.CVCNumber.text;
    self.stripeCard.expMonth = [self.selectedMonth integerValue];
    self.stripeCard.expYear = [self.selectedYear integerValue];
    
    // perform some validation on the device
    if ([self validateCustomerInfo]) {
        [[STPAPIClient sharedClient] createTokenWithCard:self.stripeCard
                                              completion:^(STPToken *token, NSError *error) {
                                                  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                  if (error) {
                                                      [self paymentViewController:self didFinish:error];
                                                  } else {
                                                      [self createBackendChargeWithToken:token
                                                                              completion:^(STPBackendChargeResult status, NSError *error) {
                                                                                  if(error) {
                                                                                      [self paymentViewController:self didFinish:error];
                                                                                  } else {
                                                                                      [self paymentViewController:self didFinish:nil];
                                                                                  }
                                                                              }];
                                                  }
                                              }];
    }
}

- (BOOL)validateCustomerInfo {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                    message:@"Please enter all required information"
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                          otherButtonTitles:nil];
    
    // Validate name & email
    if (self.nameTextField.text.length == 0 || self.emailTextField.text.length == 0) {
        [alert show];
        return NO;
    }
    
    // Validate card number, CVC, expMonth, expYear
    NSError *error = nil;
    [self.stripeCard validateCardReturningError:&error];
    
    // Localize error messages
    if (error) {
        alert.message = [error localizedDescription];
        [alert show];
        return NO;
    }
    return YES;
}


#pragma mark - JFBackendChargingDelegate

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    JFCheckoutCart *checkoutCart = [JFCheckoutCart sharedInstance];
    NSInteger totalAmount = [[checkoutCart total] doubleValue] * 100;
    
    NSDictionary *chargeParams = @{ @"stripeToken" : token.tokenId,
                                    @"amount" : [NSString stringWithFormat:@"%li", totalAmount]
                                   };
    if (!BackendChargeURLString) {
        NSError *error = [NSError errorWithDomain:StripeDomain
                                             code:STPInvalidRequestError
                                         userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Your token is %@\n", token.tokenId]
                                                    }];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[BackendChargeURLString stringByAppendingString:@"/charge"]
       parameters:chargeParams
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(STPBackendChargeResultSuccess, nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(STPBackendChargeResultFailure, error);
          }];
}

- (void)presentError:(NSError *) error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [alert show];
}

- (void)paymentSucceeded {
    [[[UIAlertView alloc] initWithTitle:@"Success"
                                message:@"Payment successfully created."
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

- (void)paymentViewController:(JFPaymentViewController *)controller didFinish:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error) {
        [self presentError:error];
    } else {
        [self paymentSucceeded];
        JFCheckoutCart *checkoutCart = [JFCheckoutCart sharedInstance];
        [checkoutCart clearCart];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // 1, user details; 2, credit card details.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Customer Info" : @"Credit Card Details";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 2 : 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        JFPaymentCardCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentCardCell"];
        cell.nameLabel.text = @"Name";
        cell.textField.placeholder = @"Required";
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        self.nameTextField = cell.textField;
        return cell;
    } else if (section == 0 && row == 1) {
        JFPaymentCardCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentCardCell"];
        cell.nameLabel.text = @"E-mail";
        cell.textField.placeholder = @"Required";
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        self.emailTextField = cell.textField;
        return cell;
    } else if (section == 1 && row == 0) {
        JFPaymentCardCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentCardCell"];
        cell.nameLabel.text = @"Card Number";
        cell.textField.placeholder = @"Required";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.cardNumber = cell.textField;
        return cell;
    } else if (section == 1 && row == 1) {
        JFPaymentCardCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentCardCell"];
        cell.nameLabel.text = @"Exp. Date";
        cell.textField.placeholder = @"Required";
        cell.textField.textColor = [UIColor lightGrayColor];
        self.expirationDateTextField = cell.textField;
        return cell;
    } else if (section == 1 && row == 2) {
        JFPaymentCardCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentCardCell"];
        cell.nameLabel.text = @"CVC Number";
        cell.textField.placeholder = @"Required";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.CVCNumber = cell.textField;
        [self configurePickerView];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0) ? 12 : 10;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.monthArray[row];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return [NSString stringWithFormat:@"%li", currentYear + row];
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedMonth = @(row + 1);
    } else {
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:row forComponent:1];
        self.selectedYear = @([yearString integerValue]);
    }
    
    if (!self.selectedMonth) {
        [self.expirationDatePicker selectRow:0 inComponent:0 animated:YES];
        self.selectedMonth = @(1); // Default to January
    }
    
    if (!self.selectedYear) {
        [self.expirationDatePicker selectRow:0 inComponent:0 animated:YES];
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:0 forComponent:1];
        self.selectedYear = @([yearString integerValue]); // Default to current year
    }
    
    self.expirationDateTextField.text = [NSString stringWithFormat:@"%li%li / %@", [self.selectedMonth integerValue]/10, [self.selectedMonth integerValue]%10, self.selectedYear];
    self.expirationDateTextField.textColor = [UIColor blackColor];
}


#pragma mark - UIPicker configuration

- (void)configurePickerView {
    self.expirationDatePicker = [[UIPickerView alloc] init];
    self.expirationDatePicker.delegate = self;
    self.expirationDatePicker.dataSource = self;
    self.expirationDatePicker.showsSelectionIndicator = YES;
    
    // Create and configure toolbar that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    self.expirationDateTextField.inputView = self.expirationDatePicker;
    self.expirationDateTextField.inputAccessoryView = pickerToolbar;
    self.nameTextField.inputAccessoryView = pickerToolbar;
    self.emailTextField.inputAccessoryView = pickerToolbar;
    self.cardNumber.inputAccessoryView = pickerToolbar;
    self.CVCNumber.inputAccessoryView = pickerToolbar;
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
