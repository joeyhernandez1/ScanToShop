//
//  DatabaseManager.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/17/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

+ (void)saveUser:(User *)user withCompletion:(void(^)(NSError *error))completion;
+ (void)loginUser:(NSString *)username password:(NSString *)password withCompletion:(void(^)(NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
