//
//  JFBeverageViewController.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFBeverageViewController.h"
#import "JFCheckoutCart.h"
#import "UIImageView+AFNetworking.h"

@interface JFBeverageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *beverImageView;
@property (strong, nonatomic) IBOutlet UILabel *beverNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *beverCategoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *beverPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *addToCartButton;

- (IBAction)addToCartButtonTapped:(id)sender;

@end

@implementation JFBeverageViewController

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
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    JFCheckoutCart *checkoutCart = [JFCheckoutCart sharedInstance];
    self.addToCartButton.selected = [checkoutCart containsBeverage:self.beverage] ? YES : NO;
}

#pragma mark - Data

- (void)loadData {
    NSURL *imageURL = [NSURL URLWithString:self.beverage.photoURL];
    [self.beverImageView setImageWithURL:imageURL placeholderImage:nil];
    self.beverNameLabel.text = self.beverage.name;
    self.beverCategoryLabel.text = self.beverage.category;
    self.beverPriceLabel.text = [NSString stringWithFormat:@"Price: $%@", self.beverage.price];
    
}

- (IBAction)addToCartButtonTapped:(id)sender {
    JFCheckoutCart *checkoutCart = [JFCheckoutCart sharedInstance];
    if (!self.addToCartButton.selected) {
        [checkoutCart addBeverage:self.beverage];
        self.addToCartButton.selected = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [checkoutCart removeBeverage:self.beverage];
        self.addToCartButton.selected = NO;
    }
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
