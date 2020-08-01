//
//  SettingsViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "SettingsViewController.h"
#import "DatabaseManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (IBAction)onLogoutTap:(id)sender {
    [DatabaseManager logoutUser:self];
}

- (IBAction)onDeleteTap:(id)sender {
}

@end
