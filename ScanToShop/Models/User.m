//
//  User.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/21/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSString *)getfullname:(User *)user {
    return [[user.firstName stringByAppendingString:@" "] stringByAppendingString:user.lastName];
}

@end
