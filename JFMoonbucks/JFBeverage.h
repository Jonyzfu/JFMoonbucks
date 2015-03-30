//
//  JFBeverage.h
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/29/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFBeverage : NSObject

@property (nonatomic, strong) NSNumber *beverID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *photoURL;

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *rating;    // out of 5

@end
