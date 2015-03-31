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

#define STRIPE_TEST_PUBLIC_KEY
#define STRIPE_TEST_POST_URL

@interface JFPaymentViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

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
    //Implement
}

- (void)validateCustomerInfo {
    //Implement
}

- (void)performStripeOperation {
    //Implement
}

- (void)postStripeToken:(NSString* )token {
    //Implement
}

- (void)handleStripeError:(NSError *) error {
    //Implement
}

- (void)chargeDidSucceed {
    //Implement
}

- (void)chargeDidNotSuceed {
    //Implement
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
    
    self.expirationDateTextField.text = [NSString stringWithFormat:@"%@/%@", self.selectedMonth, self.selectedYear];
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
