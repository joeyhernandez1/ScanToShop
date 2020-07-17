//
//  LoginViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "LoginViewController.h"
#import "AlertManager.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordField.secureTextEntry = YES;
}

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
        [AlertManager loginAlert:@"" ViewController:self];
        return;
    }
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [AlertManager loginAlert:error.localizedDescription ViewController:self];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

-(BOOL) areUserInputFieldsEmpty {
    return [self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""];
}



@end
