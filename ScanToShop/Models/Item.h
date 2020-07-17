//
//  Item.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/16/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Item : PFObject<PFSubclassing>

@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *information;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *barcode;

@end

NS_ASSUME_NONNULL_END
