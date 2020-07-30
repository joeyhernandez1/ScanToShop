//
//  AppDeal.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/29/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDeal : NSObject

@property (nonatomic, strong) NSString *sellerPlatform;
@property (nonatomic, strong) NSURL *platformItemURL;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) AppItem *item;

@end

NS_ASSUME_NONNULL_END
