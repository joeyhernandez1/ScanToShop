//
//  DealCell.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/14/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDeal.h"

NS_ASSUME_NONNULL_BEGIN

@interface DealCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sellerPlatformLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) AppDeal *deal;

@end

NS_ASSUME_NONNULL_END
