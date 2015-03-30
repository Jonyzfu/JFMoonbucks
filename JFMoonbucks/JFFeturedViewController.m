//
//  JFFeturedViewController.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/29/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFFeturedViewController.h"
#import "JFBeverage.h"
#import "JFBeverages.h"
#import "AFNetworking.h"



@interface JFFeturedViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *beverImageView;
@property (strong, nonatomic) IBOutlet UILabel *beverNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *beverCategoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *beverPriceLabel;
@property (strong, nonatomic) IBOutlet UITextView *beverDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;

- (IBAction)addToCartButtonTapped:(id)sender;

@end

@implementation JFFeturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.beverage = [JFBeverages sharedInstance].allBeverages[0];
    [self populateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data

- (void)populateData {
    NSURL *imageURL = [NSURL URLWithString:self.beverage.photoURL];
    [self.beverImageView setImageWithURL: imageURL placeholderImage:nil];
    
}

- (IBAction)addToCartButtonTapped:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addToCartButtonTapped:(id)sender {
}
@end
