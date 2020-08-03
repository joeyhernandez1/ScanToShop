//
//  AppItem.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/29/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppItem : NSObject

@property (nonatomic, strong) NSData *image;
@property (nonatomic, strong) NSString *information;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *barcode;
@property (nonatomic, strong) NSString *identifier;

@end

NS_ASSUME_NONNULL_END
