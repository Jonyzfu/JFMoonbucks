//
//  JFMenuViewController.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFMenuViewController.h"
#import "JFBeverages.h"
#import "JFBeverage.h"
#import "JFMenuTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "JFBeverageViewController.h"
#import "JFBeverages.h"

@interface JFMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JFMenuViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [JFBeverages sharedInstance].allBeverages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFBeverage *beverage = [JFBeverages sharedInstance].allBeverages[indexPath.row];
    
    JFMenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    [cell.beverImageView setImageWithURL:[NSURL URLWithString:beverage.photoURL]];
    cell.beverName.text = beverage.name;
    cell.beverPrice.text = [NSString stringWithFormat:@"$%@", beverage.price];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toBeverageViewController" sender:nil];
}

#pragma mark - UIStroyboard methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    JFBeverageViewController *viewController = (JFBeverageViewController *) segue.destinationViewController;
    viewController.beverage = [JFBeverages sharedInstance].allBeverages[self.selectedIndex];
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
