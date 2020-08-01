//
//  ProfileViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "ProfileViewController.h"
#import "DetailsViewController.h"
#import "DatabaseManager.h"
#import "DealCell.h"
#import "UserCell.h"
#import "User.h"

@interface ProfileViewController () <UITableViewDelegate,
                                     UITableViewDataSource,
                                     UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) User *user;

@end

@implementation ProfileViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil]  forCellReuseIdentifier:@"UserCell"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [DatabaseManager getCurrentUser:^(User * _Nonnull user) {
         if (user) {
             [self setUser:user];
             [self.tableView reloadData];
         }
     }];
}

- (void)setUser:(User *)user {
    _user = user;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        cell.nameLabel.text = [User getfullname:_user];
        cell.usernameLabel.text = _user.username;
        cell.dealsCounterLabel.text = [NSString stringWithFormat:@"%@",  @(_user.dealsSaved.count)];
        cell.profileImageView.image = [UIImage imageWithData:_user.profileImageData];
        cell.profileImageView.layer.masksToBounds = YES;
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.layer.bounds.size.width / 2;
        return cell;
    }
    else {
        DealCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DealCell"];
        AppDeal *deal = _user.dealsSaved[indexPath.row-1];
        [cell setDeal:deal];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _user.dealsSaved.count + 1;
}

- (void) pickImage {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"savedDealsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        AppDeal *currentDeal = _user.dealsSaved[indexPath.row-1];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.deal = currentDeal;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
