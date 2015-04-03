//
//  JFCheckoutCart.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/29/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFCheckoutCart.h"

@interface JFCheckoutCart()

@property (nonatomic, strong) NSMutableArray *beveragesArray;

@end

@implementation JFCheckoutCart

- (id)init {
    self = [super init];
    if (self) {
        self.beveragesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (JFCheckoutCart *)sharedInstance {
    static JFCheckoutCart* _sharedCart;
     static dispatch_once_t once;
     dispatch_once(&once, ^{
        _sharedCart = [[JFCheckoutCart alloc] init];
     });
    return _sharedCart;
}

- (NSArray *)beveragesInCart {
    return self.beveragesArray;
}

- (BOOL)containsBeverage:(JFBeverage *)beverage {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"beverID=%@", beverage.beverID];
    NSArray *duplicateBeverages = [self.beveragesArray filteredArrayUsingPredicate:predicate];
    return (duplicateBeverages.count > 0) ? YES : NO;
}

- (void)addBeverage:(JFBeverage *)beverage {
    if (![self containsBeverage:beverage]) {
        [self.beveragesArray addObject:beverage];
    }
}

- (void)removeBeverage:(JFBeverage *)beverage {
    [self.beveragesArray removeObject:beverage];
}

- (void)clearCart {
    self.beveragesArray = [[NSMutableArray alloc] init];
}

- (NSNumber *)total {
    double total = 0.0;
    for (JFBeverage *beverage in self.beveragesInCart) {
        total += [beverage.price doubleValue];
    }
    return [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f", total] doubleValue]];
}

@end
