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
    LoginErrorMissingInput,
    ParseBackendError,
    PasswordError,
    SpaceNewlineError
};

+ (void)loginAlert:(errorType)error ErrorString:(nullable NSString *) errorString ViewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
