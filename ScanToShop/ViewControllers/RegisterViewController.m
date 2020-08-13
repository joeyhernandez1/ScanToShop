//
//  RegisterViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "RegisterViewController.h"
#import "AlertManager.h"
#import "DatabaseManager.h"
#import "HUDManager.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "User.h"

@interface RegisterViewController () <UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIStackView *textFieldsView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
}

- (IBAction)onViewTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onRegisterTap:(id)sender {
    [self registerUser];
}

- (IBAction)onImageTap:(id)sender {
    [self cameraSourceAlert];
}

- (void)cameraSourceAlert {
    UIAlertController *alert;
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Library"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    alert = [UIAlertController alertControllerWithTitle:@"Source"
                                                message:@"Choose Library to select from your photo library or camera to take a picture."
                                         preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addAction:cameraAction];
    [alert addAction:libraryAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self updateProfileImage:editedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateProfileImage:(UIImage *)image {
    CGSize size = CGSizeMake(400, 400);
    self.profileImage.image = [self resizeImage:image withSize:size];
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = self.profileImage.layer.bounds.size.width / 2;
}

- (void) pickImage:(UIImagePickerControllerSourceType)source {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = source;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)registerUser {
    
    if ([self areUserInputFieldsEmpty]) {
        [AlertManager loginAlert:LoginErrorMissingInput errorString:nil viewController:self];
        return;
    }
    
    if ([self fieldsContainSpacesOrNewlines]) {
        [AlertManager loginAlert:InputValidationError errorString:nil viewController:self];
        return;
    }
    
    if (![self containsValidPassword]) {
        [AlertManager loginAlert:PasswordError errorString:nil viewController:self];
        return;
    }
    
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    progressHUD.textLabel.text = @"Registering user...";
    [progressHUD showInView:self.view];
    [HUDManager setViewLoadingState:YES viewController:self];
    User *user = [[User alloc] init];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    user.firstName = self.firstNameField.text;
    user.lastName = self.lastNameField.text;
    user.profileImageData = UIImagePNGRepresentation(self.profileImage.image);
    
    [DatabaseManager saveUser:user withCompletion:^(NSError *error) {
        if (error) {
            [progressHUD dismissAnimated:YES];
            [HUDManager setViewLoadingState:NO viewController:self];
            [AlertManager loginAlert:ServerError errorString:error.localizedDescription viewController:self];
        }
        else {
            [self performSegueWithIdentifier:@"registerSegue" sender:nil];
            [self setFieldsToDefault];
            [progressHUD dismissAnimated:YES];
            [HUDManager setViewLoadingState:NO viewController:self];
        }
    }];
}

- (void)setFieldsToDefault {
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.emailField.text = @"";
    self.firstNameField.text = @"";
    self.lastNameField.text = @"";
    self.profileImage.image = [UIImage imageNamed:@"person.circle.fill"];
}

- (BOOL)areUserInputFieldsEmpty {
    return [self.usernameField.text isEqual:@""]  ||
           [self.passwordField.text isEqual:@""]  ||
           [self.firstNameField.text isEqual:@""] ||
           [self.lastNameField.text isEqual:@""] ||
           [self.emailField.text isEqual:@""];
}

- (BOOL)fieldsContainSpacesOrNewlines {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet *newLineSet = [NSCharacterSet newlineCharacterSet];
    
    return [[self.usernameField.text stringByTrimmingCharactersInSet:set] length] < [self.usernameField.text length]   ||
           [[self.passwordField.text stringByTrimmingCharactersInSet:set] length] < [self.passwordField.text length]   ||
           [[self.firstNameField.text stringByTrimmingCharactersInSet:set] length] < [self.firstNameField.text length] ||
           [[self.emailField.text stringByTrimmingCharactersInSet:set] length] < [self.emailField.text length]         ||
           [[self.lastNameField.text stringByTrimmingCharactersInSet:newLineSet] length] < [self.lastNameField.text length];
}

- (BOOL)containsValidPassword {
     NSString* const pattern = @"^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).*$";
     NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSRange range = NSMakeRange(0, [self.passwordField.text length]);
     
    return [regex numberOfMatchesInString:self.passwordField.text options:0 range:range] > 0;
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
    CGFloat fieldButtom = [self getCurrentTextFieldBottomFrame];
    [UIView animateWithDuration:0.2 animations:^{
        if (self.view.frame.size.height - keyboardSize.height < fieldButtom) {
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0 - (fieldButtom - (self.view.frame.size.height - keyboardSize.height - 2)), self.view.frame.size.width, self.view.frame.size.height);
        }
    }];
}

- (CGFloat)getCurrentTextFieldBottomFrame {
    if ([self.firstNameField isEditing]) {
        CGRect fieldFrame = [self.view convertRect:self.firstNameField.frame fromView:self.textFieldsView];
        return fieldFrame.origin.y + fieldFrame.size.height;
    }
    else if ([self.lastNameField isEditing]) {
        CGRect fieldFrame = [self.view convertRect:self.lastNameField.frame fromView:self.textFieldsView];
        return fieldFrame.origin.y + fieldFrame.size.height;
    }
    else if ([self.emailField isEditing]) {
        CGRect fieldFrame = [self.view convertRect:self.emailField.frame fromView:self.textFieldsView];
        return fieldFrame.origin.y + fieldFrame.size.height;
    }
    else if ([self.usernameField isEditing]) {
        CGRect fieldFrame = [self.view convertRect:self.usernameField.frame fromView:self.textFieldsView];
        return fieldFrame.origin.y + fieldFrame.size.height;
    }
    else if ([self.passwordField isEditing]) {
        CGRect fieldFrame = [self.view convertRect:self.passwordField.frame fromView:self.textFieldsView];
        return fieldFrame.origin.y + fieldFrame.size.height;
    }
    return 0;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

@end
