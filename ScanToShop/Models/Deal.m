//
//  Deal.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/15/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "Deal.h"

@implementation Deal

@dynamic sellerPlatform;
@dynamic platformItemURL;
@dynamic price;
@dynamic item;

+ (nonnull NSString *)parseClassName {
    return @"Deal";
}

@end
