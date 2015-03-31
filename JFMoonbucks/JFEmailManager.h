//
//  JFEmailManager.h
//  JFMoonbucks
//
//  Created by Jonyzfu on 3/30/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFEmailManager : NSObject

- (id)initWithRecipient:(NSString *)name recipientEmail:(NSString *)email;
- (void)sendConfirmationEmail;
- (void)sendConfirmationEmailWithSuccessBlock:(void(^)(void))successBlock
                               failureBlock:(void(^)(void))failureBlock;

@end
