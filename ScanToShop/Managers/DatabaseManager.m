//
//  DatabaseManager.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/17/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "DatabaseManager.h"
#import "AlertManager.h"

@implementation DatabaseManager

+(BOOL) registerUserInParse:(UIViewController *)vc User:(User *)user {
    PFUser *newUser = [PFUser new];
    newUser.username = user.username;
    newUser.password = user.password;
    newUser.email = user.email;
    newUser[@"first_name"] = user.firstName;
    newUser[@"last_name"] = user.lastName;
    newUser[@"image"] = [DatabaseManager getPFFileFromImageData:user.profileImageData];
    
    __block BOOL success;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            [AlertManager loginAlert:ParseBackendError ErrorString:error.localizedDescription ViewController:vc];
        }
        else {
            NSLog(@"User registered successfully");
            [vc performSegueWithIdentifier:@"registerSegue" sender:nil];
        }
        success = succeeded;
    }];
    return success;
}

+(BOOL) loginWithParse:(UIViewController *)vc Username:(NSString *)username Password:(NSString *)password {
    __block BOOL success = NO;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [AlertManager loginAlert:ParseBackendError ErrorString: error.localizedDescription ViewController:vc];
        } else {
            NSLog(@"User logged in successfully");
            [vc performSegueWithIdentifier:@"loginSegue" sender:nil];
            success = YES;
        }
    }];
    return success;
}

+(PFFileObject *) getPFFileFromImageData: (NSData *)imageData {
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
