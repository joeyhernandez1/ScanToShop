//
//  TabBarViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 8/6/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "TabBarViewController.h"
#import "BarcodeScanViewController.h"
#import "DetailsViewController.h"
#import "SettingsViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (BOOL)shouldAutorotate {
    UINavigationController *currentVC = (UINavigationController *) self.selectedViewController;
    
    if ([currentVC.topViewController isKindOfClass:[BarcodeScanViewController class]]) {
        return NO;
    }
    else if ([currentVC.topViewController isKindOfClass:[DetailsViewController class]]) {
        return NO;
    }
    else if ([currentVC.topViewController isKindOfClass:[SettingsViewController class]]) {
        return NO;
    }
    return YES;
}

@end
