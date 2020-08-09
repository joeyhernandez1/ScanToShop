//
//  DetailsViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "DetailsViewController.h"
#import "AlertManager.h"
#import "DatabaseManager.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "HUDManager.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerPlatformLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property BOOL isDealSavedByUser;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.itemImageView.image = [UIImage imageWithData:self.deal.item.image];
    self.itemNameLabel.text = self.deal.item.name;
    self.sellerPlatformLabel.text = self.deal.sellerPlatform;
    self.priceLabel.text = [NSNumberFormatter localizedStringFromNumber:self.deal.price numberStyle:NSNumberFormatterCurrencyStyle];
    self.descriptionLabel.text = self.deal.item.information;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    progressHUD.textLabel.text = @"Loading Deal...";
    [progressHUD showInView:self.view];
    [HUDManager setViewLoadingState:YES viewController:self];
    [DatabaseManager isCurrentDealSaved:self.deal.identifier withCompletion:^(bool hasDeal, NSError * _Nonnull error) {
        if (error) {
            progressHUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        }
        else if (hasDeal) {
            self.isDealSavedByUser = YES;
            [self setSaveButtonOnDealStatus];
        }
        else {
            self.isDealSavedByUser = NO;
            [self setSaveButtonOnDealStatus];
        }
        [progressHUD dismissAfterDelay:0.1 animated:YES];
        [HUDManager setViewLoadingState:NO viewController:self];
    }];
}

- (IBAction)onImageTap:(id)sender {
    UIImageView *fullScreenImageView = [[UIImageView alloc] initWithImage:self.itemImageView.image];
    fullScreenImageView.frame = [[UIScreen mainScreen] bounds];
    fullScreenImageView.backgroundColor = [UIColor blackColor];
    fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
    fullScreenImageView.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissFullScreenImage:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [fullScreenImageView addGestureRecognizer:swipeRecognizer];
    fullScreenImageView.alpha = 0;
    [UIView animateWithDuration:0.625 animations:^{
        [self.view addSubview:fullScreenImageView];
        [self.navigationController setNavigationBarHidden:YES];
        [self.tabBarController.tabBar setHidden:YES];
        fullScreenImageView.alpha = 1;
    }];
}

- (void)setSaveButtonOnDealStatus {
    if (self.isDealSavedByUser) {
        [self.saveButton setTitle:@"UNSAVE" forState:UIControlStateNormal];
        [self.saveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else {
        [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
        [self.saveButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    }
}

- (IBAction)onBuyTap:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:self.deal.platformItemURL]) {
         [UIApplication.sharedApplication openURL:self.deal.platformItemURL options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
             if (success) {
                 NSLog(@"Opened settings action performed successfully.");
             }
             else {
                 [AlertManager linkCannotOpenError:self];
             }
         }];
     }
    else {
        [AlertManager linkCannotOpenError:self];
    }
}

- (IBAction)onSaveTap:(id)sender {
    if (!self.isDealSavedByUser) {
        [DatabaseManager saveDeal:self.deal withCompletion:^(NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                [AlertManager dealNotSavedAlert:self];
            }
            else {
                self.isDealSavedByUser = YES;
                [self setSaveButtonOnDealStatus];
            }
        }];
    }
    else {
        [DatabaseManager unsaveDeal:self.deal withCompletion:^(NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                [AlertManager dealNotSavedAlert:self];
            }
            else {
                self.isDealSavedByUser = NO;
                [self setSaveButtonOnDealStatus];
            }
        }];
    }
}

- (void)dismissFullScreenImage:(UISwipeGestureRecognizer *)sender {
    self.view.alpha = 0;
    [UIView animateWithDuration:0.65 animations:^{
        [self.navigationController setNavigationBarHidden:NO];
        [self.tabBarController.tabBar setHidden:NO];
        [sender.view removeFromSuperview];
        self.view.alpha = 1;
    }];
}

@end
