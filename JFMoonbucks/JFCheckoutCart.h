//
//  JFCheckoutCart.h
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/29/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFBeverage.h"

@interface JFCheckoutCart : NSObject

+ (JFCheckoutCart *)sharedInstance;
- (NSArray *)beveragesInCart;
- (BOOL)containsBeverage:(JFBeverage *)beverage;
- (void)addBeverage:(JFBeverage *)beverage;
- (void)removeBeverage:(JFBeverage *)beverage;
- (void)clearCart;
- (NSNumber *)total;

@end
