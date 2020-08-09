//
//  ItemCollectionCell.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 8/7/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (strong, nonatomic) AppItem *item;

@end

NS_ASSUME_NONNULL_END
