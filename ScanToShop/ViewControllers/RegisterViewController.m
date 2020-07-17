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
#import <Parse/Parse.h>

@interface RegisterViewController () <UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordField.secureTextEntry = YES;
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
    
    if (originalImage) {
        [self updateProfileImage:originalImage];
    }
    else if (editedImage) {
        [self updateProfileImage:editedImage];
    }

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
    PFUser *newUser = [PFUser user];
    
    if ([self areUserInputFieldsEmpty]) {
        [AlertManager loginAlert:@"" ViewController:self];
        return;
    }
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.email = self.emailField.text;
    newUser[@"name"] = self.nameField.text;
    newUser[@"image"] = [DatabaseManager getPFFileFromImage:self.profileImage.image];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            [AlertManager loginAlert:error.localizedDescription ViewController:self];
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"registerSegue" sender:nil];
            self.usernameField.text = @"";
            self.passwordField.text = @"";
            self.emailField.text = @"";
            self.nameField.text = @"";
            self.profileImage.image = [UIImage imageNamed:@"person.circle.fill"];
        }
    }];
}

-(BOOL) areUserInputFieldsEmpty {
    return [self.usernameField.text isEqual:@""] ||
           [self.passwordField.text isEqual:@""] ||
           [self.nameField.text isEqual:@""]     ||
           [self.emailField.text isEqual:@""];
}



@end
