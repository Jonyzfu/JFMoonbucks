//
//  JFEmailManager.m
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import "JFEmailManager.h"
#import "JFCheckoutCart.h"
#import "AFNetworking.h"

@interface JFEmailManager ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) AFJSONRequestSerializer *httpSerializer;

@end

@implementation JFEmailManager

- (id)initWithRecipient:(NSString *)name recipientEmail:(NSString *)email {
    self = [super init];
    if (self) {
        self.name = name;
        self.email = email;
    }
    return self;
}

- (void)sendConfirmationEmail {
    // Implement
}

- (void)sendConfirmationEmailWithSuccessBlock:(void (^)(void))successBlock failureBlock:(void (^)(void))failureBlock {
    // Implement
}

@end
