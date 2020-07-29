//
//  AlertManager.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/17/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject

typedef NS_ENUM(NSInteger, errorType) {
    InputValidationError,
    LoginErrorMissingInput,
    PasswordError,
    ServerError
};

+ (void)loginAlert:(errorType)error errorString:(nullable NSString *) errorString viewController:(UIViewController *)vc;
+ (void)videoPermissionAlert:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
