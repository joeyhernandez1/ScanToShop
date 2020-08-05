//
//  User.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/21/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSData *profileImageData;
@property (nonatomic, strong) NSMutableArray *dealsSaved;

+ (NSString *)getfullname:(User *)user;

@end

NS_ASSUME_NONNULL_END
