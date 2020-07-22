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

+(void)saveUser:(User *)user withCompletion:(void(^)(BOOL success, NSError *error))completion {
    PFUser *newUser = [PFUser new];
    newUser.username = user.username;
    newUser.password = user.password;
    newUser.email = user.email;
    newUser[@"first_name"] = user.firstName;
    newUser[@"last_name"] = user.lastName;
    newUser[@"image"] = [DatabaseManager getPFFileFromImageData:user.profileImageData];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"User registered successfully");
        }
        completion(succeeded, error);
    }];
}

+(void)loginUser:(NSString *)username password:(NSString *)password withCompletion:(void(^)(BOOL success, NSError *error))completion {
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            completion(NO, error);
        }
        else {
            NSLog(@"User logged in successfully");
            completion(YES, nil);
        }
    }];
}

+(PFFileObject *) getPFFileFromImageData: (NSData *)imageData {
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
