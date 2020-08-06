//
//  HUDManager.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 8/4/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUDManager : NSObject

+ (void)setViewLoadingState:(BOOL)isLoading viewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
