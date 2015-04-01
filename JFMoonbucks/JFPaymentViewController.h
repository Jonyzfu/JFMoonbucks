//
//  JFPaymentViewController.h
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class JFPaymentViewController;
//
//
//@protocol JFPaymentViewControllerDelegate<NSObject>
//
//
//- (void)paymentViewController:(JFPaymentViewController *)controller didFinish:(NSError *)error;
//
//@end

@interface JFPaymentViewController : UITableViewController

@property (nonatomic) NSDecimalNumber *totalAmount;
// @property (weak, nonatomic) id<JFPaymentViewControllerDelegate> delegate;

@end
