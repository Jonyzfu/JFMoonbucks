//
//  JFBeverages.h
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/29/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFBeverages : NSObject

@property (nonatomic, strong, readonly) NSArray *allBeverages;

+ (JFBeverages *)sharedInstance;

@end
