//
//  DatabaseManager.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/17/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "AppDeal.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseManager : NSObject

+ (void)saveUser:(User *)user withCompletion:(void(^)(NSError *error))completion;
+ (void)loginUser:(NSString *)username password:(NSString *)password withCompletion:(void(^)(NSError *error))completion;
+ (void)fetchItem:(NSString *)barcode viewController:(UIViewController *)vc withCompletion:(void(^)(NSArray *deals,NSError *error))completion;
+ (void)fetchRecentItems:(void(^)(NSArray *items,NSError *error))completion;
+ (void)updateRecentItems:(PFObject *)item withCompletion:(void(^)(NSError *error))completion;
+ (void)saveDeal:(AppDeal *)appDeal withCompletion:(void(^)(NSError *error))completion;
+ (void)isCurrentDealSaved:(NSString *)identifier withCompletion:(void(^)(_Bool hasDeal, NSError *error))completion;
+ (void)unsaveDeal:(AppDeal *)appDeal withCompletion:(void(^)(NSError *error))completion;
+ (void)fetchSavedDeals:(void(^)(NSArray *deals, NSError *error))completion;
+ (void)fetchAllDeals:(void(^)(NSArray *deals ,NSError *error))completion;
+ (void)getCurrentUser:(void(^)(User *user))completion;
+ (void)logoutUser:(UIViewController *)vc;
+ (void)updateUser:(User *)user;
+ (void)deleteUser:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
