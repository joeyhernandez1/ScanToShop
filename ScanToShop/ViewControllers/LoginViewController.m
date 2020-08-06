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
#import <JGProgressHUD/JGProgressHUD.h>
#import "HUDManager.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
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
        [AlertManager loginAlert:LoginErrorMissingInput errorString:nil viewController:self];
        return;
    }
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    progressHUD.textLabel.text = @"Login In...";
    [progressHUD showInView:self.view];
    [HUDManager setViewLoadingState:YES viewController:self];
    [DatabaseManager loginUser:username password:password withCompletion:^(NSError *error) {
        if (error) {
            [progressHUD dismissAnimated:YES];
            [AlertManager loginAlert:ServerError errorString: error.localizedDescription viewController:self];
        }
        else {
            [progressHUD dismissAnimated:YES];
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
        [HUDManager setViewLoadingState:NO viewController:self];
    }];
}

- (BOOL)areUserInputFieldsEmpty {
    return [self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect btFrame = [self.view convertRect:self.signInButton.frame fromView:self.buttonsView];
    CGFloat buttonButtom = btFrame.origin.y + btFrame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        if (self.view.frame.size.height - keyboardSize.height < buttonButtom) {
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0 - (buttonButtom - (self.view.frame.size.height - keyboardSize.height)), self.view.frame.size.width, self.view.frame.size.height);
        }
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

@end
