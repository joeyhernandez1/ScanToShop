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
@dynamic itemName;
@dynamic itemImage;
@dynamic itemDescription;

+ (nonnull NSString *)parseClassName {
    return @"Item";
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
