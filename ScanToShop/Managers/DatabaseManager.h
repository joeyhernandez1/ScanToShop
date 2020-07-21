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

+(BOOL) registerUserInParse:(UIViewController *)vc User:(User *)user;
+(BOOL) loginWithParse:(UIViewController *)vc Username:(NSString *)username Password:(NSString *)password;
+ (PFFileObject *)getPFFileFromImageData: (NSData *)imageData;

@end

NS_ASSUME_NONNULL_END
