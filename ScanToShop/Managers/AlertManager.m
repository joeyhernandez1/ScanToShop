//
//  AlertManager.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/17/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "AlertManager.h"

@interface AlertManager ()

@end

@implementation AlertManager

+ (void)loginAlert:(NSString *)errorString ViewController:(UIViewController *)vc {
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
    
    if ([errorString isEqual:@""]) {
        alert = [UIAlertController alertControllerWithTitle:@"Missing Fields"
                                                    message:@"Username or/and password field empty, try again."
                                             preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:cancelAction];
    }
    else {
        alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                    message:errorString
                                             preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:okAction];
    }
    
    [vc presentViewController:alert animated:YES completion:^{
        NSLog(@"Finished presenting alert");
    }];
}

@end
