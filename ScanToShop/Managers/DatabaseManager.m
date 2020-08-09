//
//  DatabaseManager.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/17/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "DatabaseManager.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "AlertManager.h"
#import "AppDeal.h"
#import "AppItem.h"
#import "Deal.h"
#import "Item.h"

@implementation DatabaseManager

+ (void)updateUser:(User *)user {
    PFUser *currentUser = [PFUser currentUser];
    currentUser.username = user.username;
    currentUser.email = user.email;
    currentUser[@"first_name"] = user.firstName;
    currentUser[@"last_name"] = user.lastName;
    currentUser[@"image"] = [DatabaseManager getPFFileFromImageData:user.profileImageData];
    [currentUser saveInBackground];
}

+ (void)saveUser:(User *)user withCompletion:(void(^)(NSError *error))completion {
    PFUser *newUser = [PFUser new];
    newUser.username = user.username;
    newUser.password = user.password;
    newUser.email = user.email;
    newUser[@"first_name"] = user.firstName;
    newUser[@"last_name"] = user.lastName;
    newUser[@"image"] = [DatabaseManager getPFFileFromImageData:user.profileImageData];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"User registered successfully");
        }
        completion(error);
    }];
}

+ (void)deleteUser:(UIViewController *)vc {
    if ([PFUser currentUser] != nil) {
        [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded)
            {
                [DatabaseManager logoutUser:vc];
            }
        }];
    }
}

+ (void)loginUser:(NSString *)username password:(NSString *)password withCompletion:(void(^)(NSError *error))completion {
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        }
        else {
            NSLog(@"User logged in successfully");
        }
        completion(error);
    }];
}

+ (void)logoutUser:(UIViewController *)vc {
    SceneDelegate *sceneDelegate = (SceneDelegate *) vc.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *initialNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"InitialNavigationController"];
    sceneDelegate.window.rootViewController = initialNavigationController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Logout successful!");
        }
    }];
}

+ (void)getCurrentUser:(void(^)(User *user))completion {
    PFUser *user = [PFUser currentUser];
    User *currentUser = [User new];
    currentUser.firstName = user[@"first_name"];
    currentUser.lastName = user[@"last_name"];
    currentUser.email = user[@"email"];
    currentUser.username = user[@"username"];
    PFFileObject *profileImage = user[@"image"];
    [profileImage getDataInBackgroundWithBlock:^(NSData * _Nullable ImageData, NSError * _Nullable error) {
        if (!error) {
            currentUser.profileImageData = ImageData;
            
        }
    }];
    [DatabaseManager fetchSavedDeals:^(NSArray * _Nonnull deals, NSError * _Nonnull error) {
        if (!error) {
            currentUser.dealsSaved = (NSMutableArray *)deals;
            completion(currentUser);
        }
    }];
}

+ (void)fetchRecentItems:(void(^)(NSArray *items,NSError *error))completion {
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"recentItems"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            [DatabaseManager createItemsFromFetchWithBlock:objects withCompletion:^(NSArray *appItems) {
                if (appItems.count > 0) {
                    completion(appItems, nil);
                }
                else {
                    completion(appItems, error);
                }
            }];
        }
        else {
            completion(nil, error);
        }
    }];
}

+ (void)createItemsFromFetchWithBlock:(NSArray *)serverItems withCompletion:(void(^)(NSArray *appItems))completion {
    NSMutableArray *result = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (PFObject *obj in serverItems) {
        Item *serverItem = [DatabaseManager createServerItemFromPFObject:obj];
        if (serverItem != nil) {
            dispatch_group_enter(group);
            [DatabaseManager createItemWithBlock:serverItem withCompletion:^(AppItem *appItem, NSError *error) {
                [result addObject:appItem];
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(result);
    });
}

+ (void)updateRecentItems:(PFObject *)item withCompletion:(void(^)(NSError *error))completion {
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"recentItems"];
    if (item != nil) {
        [relation addObject:item];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                completion(nil);
            }
            else {
                completion(error);
            }
        }];
    }
}

+ (void)fetchItem:(NSString *)barcode viewController:(UIViewController *)vc withCompletion:(void(^)(NSArray *deals,NSError *error))completion {
    PFQuery *itemQuery = [Item query];
    [itemQuery whereKey:@"barcode" equalTo:barcode];
    [itemQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object != nil) {
            [DatabaseManager fetchDeals:object withCompletion:^(NSArray * _Nonnull deals, NSError * _Nonnull error) {
                if (deals.count > 0) {
                    [DatabaseManager createDealsFromFetchWithBlock:deals withCompletion:^(NSArray *appDeals) {
                        completion(appDeals, nil);
                    }];
                }
                else {
                    [AlertManager dealNotFoundAlert:vc errorType:NoDealFoundError];
                }
            }];
            [DatabaseManager updateRecentItems:object withCompletion:^(NSError * _Nonnull error) {
                if (error) {
                    [AlertManager dealNotFoundAlert:vc errorType:NoDealFoundError];
                }
            }];
        }
        else {
            completion(nil, error);
            [AlertManager dealNotFoundAlert:vc errorType:NoItemFoundError];
        }
    }];
}

+ (void)fetchDeals:(PFObject *)item withCompletion:(void(^)(NSArray *deals ,NSError *error))completion {
    PFQuery *dealsQuery = [Deal query];
    [dealsQuery includeKey:@"item"];
    [dealsQuery whereKey:@"item" equalTo:item];
    [dealsQuery orderByAscending:@"price"];
    
    [dealsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            completion(objects, nil);
        }
        else {
            completion(nil, error);
        }
    }];
}

+ (void)fetchSavedDeals:(void(^)(NSArray *deals, NSError *error))completion {
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"dealsSaved"];
    PFQuery *query = [relation query];
    [query includeKey:@"dealsSaved.item"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
           [DatabaseManager createSavedDealsFromFetchWithBlock:objects withCompletion:^(NSArray *appDeals) {
               completion(appDeals, nil);
           }];
        }
        else {
            completion(nil, error);
        }
    }];
}

+ (void)createDealsFromFetchWithBlock:(NSArray *)serverDeals withCompletion:(void(^)(NSArray *appDeals))completion{
    NSMutableArray *result = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (PFObject *obj in serverDeals) {
        Deal *serverDeal = [DatabaseManager createDealFromObject:obj];
        if (serverDeal != nil) {
            dispatch_group_enter(group);
            [DatabaseManager createDealFromServerDealWithBlock:serverDeal withCompletion:^(AppDeal *appDeal, NSError *error) {
                [result addObject:appDeal];
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(result);
    });
}

+ (void)createSavedDealsFromFetchWithBlock:(NSArray *)serverDeals withCompletion:(void(^)(NSArray *appDeals))completion{
    NSMutableArray *result = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (PFObject *obj in serverDeals) {
        dispatch_group_enter(group);
        [DatabaseManager createDealFromObjectWithBlock:obj withCompletion:^(Deal *deal) {
            if (deal != nil) {
                [DatabaseManager createDealFromServerDealWithBlock:deal withCompletion:^(AppDeal *appDeal, NSError *error) {
                    [result addObject:appDeal];
                    dispatch_group_leave(group);
                }];
            }
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(result);
    });
}

+ (Deal *)createDealFromObject:(PFObject *)object {
    Deal *deal = [Deal new];
    if (object[@"sellerPlatform"] != nil && [object[@"sellerPlatform"] isKindOfClass:[NSString class]]) {
        deal.sellerPlatform = object[@"sellerPlatform"];
    }
    else {
        return nil;
    }
    if (object[@"price"] != nil && [object[@"price"] isKindOfClass:[NSNumber class]]) {
        deal.price = object[@"price"];
    }
    else {
        return nil;
    }
    if (object[@"item"] != nil && [object[@"item"] isKindOfClass:[PFObject class]]) {
        deal.item = [DatabaseManager createServerItemFromPFObject:object[@"item"]];
    }
    else {
        return nil;
    }
    if (object[@"link"] != nil && [object[@"link"] isKindOfClass:[NSString class]]) {
        deal.platformItemURL = object[@"link"];
    }
    else {
        return nil;
    }
    deal.objectId = object.objectId;
    return deal;
}

+ (void)createDealFromObjectWithBlock:(PFObject *)object withCompletion:(void(^)(Deal *deal))completion {
    Deal *deal = [Deal new];
    if (object[@"sellerPlatform"] != nil && [object[@"sellerPlatform"] isKindOfClass:[NSString class]]) {
        deal.sellerPlatform = object[@"sellerPlatform"];
    }
    else {
        completion(nil);
    }
    if (object[@"price"] != nil && [object[@"price"] isKindOfClass:[NSNumber class]]) {
        deal.price = object[@"price"];
    }
    else {
        completion(nil);
    }
    if (object[@"link"] != nil && [object[@"link"] isKindOfClass:[NSString class]]) {
        deal.platformItemURL = object[@"link"];
    }
    else {
        completion(nil);
    }
    if (object[@"item"] != nil && [object[@"item"] isKindOfClass:[PFObject class]]) {
        [DatabaseManager createServerItemFromPFObjectWithBlock:object[@"item"] withCompletion:^(Item *item) {
            if (item != nil) {
                deal.item = item;
                deal.objectId = object.objectId;
                completion(deal);
            }
            else {
                completion(nil);
            }
        }];
    }
    else {
        completion(nil);
    }
}

+ (void)createDealFromServerDealWithBlock:(Deal *)serverDeal withCompletion:(void(^)(AppDeal *appDeal ,NSError *error))completion {
    AppDeal *deal = [AppDeal new];
    deal.platformItemURL = [NSURL URLWithString:serverDeal.platformItemURL];
    deal.price = serverDeal.price;
    deal.sellerPlatform = serverDeal.sellerPlatform;
    deal.identifier = serverDeal.objectId;
    [DatabaseManager createItemWithBlock:serverDeal.item withCompletion:^(AppItem *appItem, NSError *error) {
        if (error) {
            NSLog(@"Error at createDealFromServerDealWithBlock");
        }
        else {
            deal.item = appItem;
            completion(deal, nil);
        }
    }];
}

+ (Item *)createServerItemFromPFObject:(PFObject *)object {
    Item *serverItem = [Item new];
    
    if (object[@"name"] != nil && [object[@"name"] isKindOfClass:[NSString class]]) {
        serverItem.name = object[@"name"];
    }
    if (object[@"info"] != nil && [object[@"info"] isKindOfClass:[NSString class]]) {
        serverItem.information = object[@"info"];
    }
    if (object[@"barcode"] != nil && [object[@"barcode"] isKindOfClass:[NSString class]]) {
        serverItem.barcode = object[@"barcode"];
    }
    if (object[@"image"] != nil) {
        serverItem.image = object[@"image"];
    }
    serverItem.objectId = object.objectId;
    return serverItem;
}

+ (void)createServerItemFromPFObjectWithBlock:(PFObject *)serverObject withCompletion:(void(^)(Item *item))completion {
    Item *serverItem = [Item new];
    PFQuery *itemQuery = [Item query];
    [itemQuery getObjectInBackgroundWithId:serverObject.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object[@"name"] != nil && [object[@"name"] isKindOfClass:[NSString class]]) {
            serverItem.name = object[@"name"];
            NSLog(@"%@",serverItem.name);
        }
        if (object[@"info"] != nil && [object[@"info"] isKindOfClass:[NSString class]]) {
            serverItem.information = object[@"info"];
            NSLog(@"%@",serverItem.information);
        }
        if (object[@"barcode"] != nil && [object[@"barcode"] isKindOfClass:[NSString class]]) {
            serverItem.barcode = object[@"barcode"];
            NSLog(@"%@",serverItem.barcode);
        }
        if (object[@"image"] != nil) {
            serverItem.image = object[@"image"];
        }
        serverItem.objectId = object.objectId;
        completion(serverItem);
    }];
}

+ (void)createItemWithBlock:(Item *)serverItem withCompletion:(void(^)(AppItem *appItem ,NSError *error))completion {
    AppItem *item = [AppItem new];
    item.barcode = serverItem.barcode;
    item.name = serverItem.name;
    item.information = serverItem.information;
    item.identifier = serverItem.objectId;
    [serverItem.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            completion(nil,error);
        }
        else {
            item.image = data;
            completion(item, nil);
        }
    }];
}

+ (void)saveDeal:(AppDeal *)appDeal withCompletion:(void(^)(NSError *error))completion {
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"dealsSaved"];
    [DatabaseManager getPFObjectFromAppDeal:appDeal withCompletion:^(PFObject *object) {
        if (object != nil) {
            [relation addObject:object];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    completion(nil);
                }
                else {
                    completion(error);
                }
            }];
        }
    }];
}

+ (void)unsaveDeal:(AppDeal *)appDeal withCompletion:(void(^)(NSError *error))completion {
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"dealsSaved"];
    [DatabaseManager getPFObjectFromAppDeal:appDeal withCompletion:^(PFObject *object) {
        if (object != nil) {
            [relation removeObject:object];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    completion(nil);
                }
                else {
                    completion(error);
                }
            }];
        }
    }];
    
}

+ (void)isCurrentDealSaved:(NSString *)identifier withCompletion:(void(^)(_Bool hasDeal, NSError *error))completion {
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"dealsSaved"];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            for (PFObject *obj in objects) {
                if ([obj.objectId isEqualToString:identifier]) {
                    completion(YES, nil);
                    return;
                }
            }
            completion(NO, nil);
        }
        else {
            completion(NO, error);
        }
    }];
}

+ (void)getPFObjectFromAppDeal:(AppDeal *)appDeal withCompletion:(void(^)(PFObject *object))completion {
    PFQuery *dealQuery = [Deal query];
    [dealQuery getObjectInBackgroundWithId:appDeal.identifier block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            completion(object);
        }
        else {
            completion(nil);
        }
    }];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (PFFileObject *)getPFFileFromImageData: (NSData *)imageData {
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (void)populateServer {
    Item *item1 = [Item new];
    item1[@"name"] = @"Call of Duty: Black Ops 4";
    item1[@"info"] = @"Fourth game of the Call of Duty Black Ops saga";
    item1[@"barcode"] = @"047875882348";
    item1[@"image"] = [DatabaseManager getPFFileFromImage:[UIImage imageNamed: @"codbo4"]];
    [item1 saveInBackground];
    
    Item *item2 = [Item new];
    item2[@"name"] = @"Reprogramming the American Dream";
    item2[@"info"] = @"Book written by Microsoft CTO Kevin Scott about AI.";
    item2[@"barcode"] = @"9780062879875";
    item2[@"image"] = [DatabaseManager getPFFileFromImage:[UIImage imageNamed: @"codbo4"]];
    [item2 saveInBackground];
    
    Item *item3 = [Item new];
    item3[@"name"] = @"NBA 2K15";
    item3[@"info"] = @"NBA 2K game for the 2015-2016 season.";
    item3[@"barcode"] = @"710425494147";
    item3[@"image"] = [DatabaseManager getPFFileFromImage:[UIImage imageNamed: @"codbo4"]];
    [item3 saveInBackground];
    
    Item *item4 = [Item new];
    item4[@"name"] = @"FIFA 15";
    item4[@"info"] = @"FIFA game for the 2014-2015 cycle.";
    item4[@"barcode"] = @"01463336779";
    item4[@"image"] = [DatabaseManager getPFFileFromImage:[UIImage imageNamed: @"codbo4"]];
    [item4 saveInBackground];
    
    Item *item5 = [Item new];
    item5[@"name"] = @"Cracking the Coding Interview";
    item5[@"info"] = @"Book about coding interviews.";
    item5[@"barcode"] = @"9780984782857";
    item5[@"image"] = [DatabaseManager getPFFileFromImage:[UIImage imageNamed: @"codbo4"]];
    [item5 saveInBackground];
    
    Deal *deal1 = [Deal new];
    deal1[@"item"] = item1;
    deal1[@"sellerPlatform"] = @"Amazon";
    deal1[@"price"] = @20.02;
    deal1[@"link"] = @"https://www.amazon.com/Call-Duty-Black-Ops-Xbox-Standard/dp/B071JRHDFQ";
    [deal1 saveInBackground];
    
    Deal *deal2 = [Deal new];
    deal2[@"item"] = item1;
    deal2[@"sellerPlatform"] = @"Ebay";
    deal2[@"price"] = @19.65;
    deal2[@"link"] = @"https://www.ebay.com/p/245256094";
    [deal2 saveInBackground];
    
    Deal *deal3 = [Deal new];
    deal3[@"item"] = item1;
    deal3[@"sellerPlatform"] = @"Ebay";
    deal3[@"price"] = @34.97;
    deal3[@"link"] = @"https://www.gamestop.com/video-games/xbox-one/games/products/call-of-duty-black-ops-4/10159649.html?rt=productDetailsRedesign&utm_expid=.h77-PyHtRYaskNpc14UbmA.1&utm_referrer=https%3A%2F%2Fwww.gamestop.com%2Fvideo-games%2Fplaystation-4%2Fgames%2Fproducts%2Fcall-of-duty-black-ops-4%2F10159650.html%3Frt%3DproductDetailsRedesign";
    [deal3 saveInBackground];
}

@end
