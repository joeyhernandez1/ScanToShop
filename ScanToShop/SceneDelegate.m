//
//  SceneDelegate.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "SceneDelegate.h"
#import <Parse/Parse.h>

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
      if (PFUser.currentUser) {
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             
             self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticatedViewController"];
      }
}

@end
