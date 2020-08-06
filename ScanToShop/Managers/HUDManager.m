//
//  HUDManager.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 8/4/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "HUDManager.h"

@implementation HUDManager

+ (void)setViewLoadingState:(BOOL)isLoading viewController:(UIViewController *)vc {
    if (isLoading) {
        vc.view.userInteractionEnabled = NO;
        vc.view.alpha = 0.3f;
        [vc.navigationController setNavigationBarHidden:YES];
        [vc.tabBarController.tabBar setHidden:YES];
    }
    else {
        vc.view.userInteractionEnabled = YES;
        [vc.navigationController setNavigationBarHidden:NO];
        [vc.tabBarController.tabBar setHidden:NO];
        vc.view.alpha = 1;
    }
}

@end
