//
//  UserCell.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/31/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "UserCell.h"
#import "DatabaseManager.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfileImage:)];
    [self.profileImageView addGestureRecognizer:tapRecognizer];
    [self.profileImageView setUserInteractionEnabled:YES];
}

- (void)setUser:(User *)user {
    _user = user;
    self.nameLabel.text = [User getfullname:_user];
    self.usernameLabel.text = _user.username;
    self.dealsCounterLabel.text = [NSString stringWithFormat:@"%@",  @(_user.dealsSaved.count)];
    self.profileImageView.image = [UIImage imageWithData:_user.profileImageData];
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.layer.bounds.size.width / 2;
}

#pragma mark - Delegate

- (void)didTapProfileImage:(UITapGestureRecognizer *)sender {
    [self.delegate userCell:self didTapProfileImage:self.profileImageView.image];
}

@end
