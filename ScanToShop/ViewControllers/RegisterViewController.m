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
#import "User.h"

@interface RegisterViewController () <UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

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
    [self pickImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self updateProfileImage: originalImage ?: editedImage];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateProfileImage:(UIImage *)image {
    CGSize size = CGSizeMake(400, 400);
    self.profileImage.image = [self resizeImage:image withSize:size];
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = self.profileImage.layer.bounds.size.width / 2;
}

- (void) pickImage {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

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
    
    User *user = [[User alloc] init];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    user.firstName = self.firstNameField.text;
    user.lastName = self.lastNameField.text;
    user.profileImageData = UIImagePNGRepresentation(self.profileImage.image);
    
    [DatabaseManager saveUser:user withCompletion:^(NSError *error) {
        if (error) {
            [AlertManager loginAlert:ServerError errorString:error.localizedDescription viewController:self];
        }
        else {
            [self performSegueWithIdentifier:@"registerSegue" sender:nil];
            [self setFieldsToDefault];
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
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0 - (keyboardSize.height/1.5), self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

@end
