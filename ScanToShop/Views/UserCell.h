//
//  UserCell.h
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/31/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UserCellDelegate;

@interface UserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealsCounterLabel;
@property (weak, nonatomic) id<UserCellDelegate> delegate;
@property (strong, nonatomic) User *user;

@end

@protocol UserCellDelegate

- (void)userCell:(UserCell *)userCell didTapProfileImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
