//
//  LoginViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "LoginViewController.h"
#import "AlertManager.h"
#import "DatabaseManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (IBAction)onViewTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onSignInTap:(id)sender {
    [self loginUser];
}

- (IBAction)onRegisterTap:(id)sender {
    self.usernameField.text = @"";
    self.passwordField.text = @"";
}

- (void)loginUser {
    if ([self areUserInputFieldsEmpty]) {
        [AlertManager loginAlert:LoginErrorMissingInput errorString:nil viewController:self];
        return;
    }
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [DatabaseManager loginUser:username password:password withCompletion:^(NSError *error) {
        if (error) {
            [AlertManager loginAlert:ServerError errorString: error.localizedDescription viewController:self];
        }
        else {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (BOOL)areUserInputFieldsEmpty {
    return [self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""];
}

@end
