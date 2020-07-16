//
//  Deal.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/15/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface Deal : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *sellerPlatform;
@property (nonatomic, strong) NSURL *platformItemURL;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) Item *item;

@end

NS_ASSUME_NONNULL_END
