//
//  DealCell.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/14/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "DealCell.h"

@implementation DealCell

- (void)setDeal:(AppDeal *)deal {
    _deal = deal;
    self.itemImageView.image = [UIImage imageWithData:_deal.item.image];
    self.itemNameLabel.text = _deal.item.name;
    self.sellerPlatformLabel.text = _deal.sellerPlatform;
    self.priceLabel.text = [DealCell formattedPrice:_deal.price];
}

+ (NSString *)formattedPrice:(NSNumber *)price {
    return [NSNumberFormatter localizedStringFromNumber:price numberStyle:NSNumberFormatterCurrencyStyle];
}

@end
