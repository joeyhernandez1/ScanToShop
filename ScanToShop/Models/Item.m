//
//  Item.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/16/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "Item.h"

@implementation Item

@dynamic barcode;
@dynamic name;
@dynamic image;
@dynamic information;

+ (nonnull NSString *)parseClassName {
    return @"Item";
}

@end
