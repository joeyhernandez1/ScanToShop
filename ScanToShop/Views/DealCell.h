//
//  DealCell.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/14/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DealCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerPlatformLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

NS_ASSUME_NONNULL_END
