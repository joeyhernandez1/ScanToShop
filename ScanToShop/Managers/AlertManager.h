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

typedef NS_ENUM(NSInteger, loginErrorType) {
    InputValidationError,
    LoginErrorMissingInput,
    PasswordError,
    ServerError
};

typedef NS_ENUM(NSInteger, dealErrorType) {
    NoDealFoundError,
    NoItemFoundError
};

+ (void)loginAlert:(loginErrorType)error errorString:(nullable NSString *) errorString viewController:(UIViewController *)vc;
+ (void)videoPermissionAlert:(UIViewController *)vc;
+ (void)dealNotFoundAlert:(UIViewController *)vc errorType:(dealErrorType)error;
+ (void)linkCannotOpenError:(UIViewController *)vc;
+ (void)dealNotSavedAlert:(UIViewController *)vc;
+ (void)logoutAlert:(UIViewController *)vc;
+ (void)deleteAccountAlert:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
