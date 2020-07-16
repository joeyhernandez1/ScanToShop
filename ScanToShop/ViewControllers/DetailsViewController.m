//
//  DetailsViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerPlatformLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onBuyTap:(id)sender {
}

- (IBAction)onSaveTap:(id)sender {
}
@end
