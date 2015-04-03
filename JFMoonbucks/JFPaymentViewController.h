//
//  JFPaymentViewController.h
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/Stripe.h>

@class JFPaymentViewController;

@protocol JFBackendChargingDelegate<NSObject>

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion;
- (void)paymentViewController:(JFPaymentViewController *)controller didFinish:(NSError *)error;

@end

@interface JFPaymentViewController : UITableViewController<JFBackendChargingDelegate>

@property (nonatomic) NSDecimalNumber *totalAmount;

@end
