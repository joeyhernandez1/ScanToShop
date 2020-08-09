//
//  ItemCollectionCell.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 8/7/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "ItemCollectionCell.h"

@implementation ItemCollectionCell

- (void)setItem:(AppItem *)item {
    _item = item;
    self.posterView.image = [UIImage imageWithData:item.image];
}

@end
