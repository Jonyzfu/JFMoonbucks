//
//  JFBeverages.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/29/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFBeverages.h"
#import "JFBeverage.h"

@implementation JFBeverages

+ (JFBeverages *)sharedInstance {
    static JFBeverages *_sharedBeverages;
    
     static dispatch_once_t once;
     dispatch_once(&once, ^{
        _sharedBeverages = [[JFBeverages alloc] init];
         
     });
    return _sharedBeverages;
}

- (id)init {
    if (self == [super init]) {
        _allBeverages = [self loadBeveragesFromJSON];
    }
    return self;
}

- (NSArray *)loadBeveragesFromJSON {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"beverages" ofType:@"json"];
    
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&error];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *beverArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
    
    for (NSDictionary *beverDictionary in jsonArray) {
        JFBeverage *beverage = [[JFBeverage alloc] init];
        beverage.beverID = beverDictionary[@"beverID"];
        beverage.name = beverDictionary[@"name"];
        beverage.category = beverDictionary[@"category"];
        beverage.photoURL = beverDictionary[@"photoURL"];
        beverage.rating = beverDictionary[@"rating"];
        beverage.price = beverDictionary[@"price"];
        [beverArray addObject:beverage];
    }
    
    return beverArray;
}

@end
