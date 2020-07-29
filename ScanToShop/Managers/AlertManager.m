//
//  AlertManager.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/17/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager

+ (void)loginAlert:(errorType)error errorString:(nullable NSString *) errorString viewController:(UIViewController *)vc {
    UIAlertController *alert;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel action performed");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK action performed.");
    }];
    
    switch (error) {
        case LoginErrorMissingInput:
            alert = [UIAlertController alertControllerWithTitle:@"Missing Fields"
                                                        message:@"Username or/and password field empty, try again."
                                                 preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:cancelAction];
            break;
            
        case ServerError:
            alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                        message:errorString
                                                 preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:okAction];
            break;
            
        case PasswordError:
            alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                        message:@"Password must contain 8 characters, one uppercase letter, one lower case letter, and a number."
                                                 preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:okAction];
            break;
            
        case InputValidationError:
            alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                    message:@"Check for spaces and new lines."
                                             preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:okAction];
            break;
    }
    
    [vc presentViewController:alert animated:YES completion:^{
        NSLog(@"Finished presenting alert");
    }];
}

+ (void)videoPermissionAlert:(UIViewController *)vc {
    UIAlertController *alert =  [UIAlertController alertControllerWithTitle:@"Unable to Continue"
                                                                    message:@"ScanToShop needs a camera to scan items. In order to continue, allow Camera access in Settings."
                                                             preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *openSettingsAction = [UIAlertAction actionWithTitle:@"Open Settings"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
            [UIApplication.sharedApplication openURL:settingsURL options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened settings action performed successfully.");
                }
                else {
                    NSLog(@"Could not open settings.");
                }
            }];
        }
    }];
    
    [alert addAction:openSettingsAction];
    [vc presentViewController:alert animated:YES completion:^{
        NSLog(@"Finished presenting alert");
    }];
}

@end
