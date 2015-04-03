//
//  JFCheckoutViewController.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFCheckoutViewController.h"
#import "JFCheckoutCart.h"
#import "JFBeverage.h"
#import "JFCheckoutBeverageCell.h"
#import "JFTotalCheckoutCell.h"


@interface JFCheckoutViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *continueButtonView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) JFCheckoutCart *checkoutCart;

@end

@implementation JFCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkoutCart = [JFCheckoutCart sharedInstance];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (section == 0) ? self.checkoutCart.beveragesInCart.count : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Beverages" : @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JFBeverage *beverage = self.checkoutCart.beveragesInCart[indexPath.row];
        JFCheckoutBeverageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutCell"];
        cell.beverNameLabel.text = beverage.name;
        cell.beverPriceLabel.text = [NSString stringWithFormat:@"$%@", beverage.price];
        return cell;
    } else {
        JFTotalCheckoutCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalCell"];
        cell.beverTotalLabel.text = [NSString stringWithFormat:@"$%@", [self.checkoutCart total]];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JFBeverage *beverage = self.checkoutCart.beveragesInCart[indexPath.row];
        [self.checkoutCart removeBeverage:beverage];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
