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
#import <JGProgressHUD/JGProgressHUD.h>
#import "HUDManager.h"

@interface ProfileViewController () <UITableViewDelegate,
                                     UITableViewDataSource,
                                     UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate,
                                     UserCellDelegate>

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
    
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    progressHUD.textLabel.text = @"Fetching profile...";
    [progressHUD showInView:self.view];
    [HUDManager setViewLoadingState:YES viewController:self];
    [DatabaseManager getCurrentUser:^(User * _Nonnull user) {
         if (user) {
             [self setUser:user];
             [self.tableView reloadData];
             progressHUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
         }
        [progressHUD dismissAfterDelay:0.1 animated:YES];
        [HUDManager setViewLoadingState:NO viewController:self];
     }];
    
}

- (void)setLoadingState:(BOOL)isLoading {
    if (isLoading) {
        self.view.userInteractionEnabled = NO;
        self.view.alpha = 0.3f;
        [self.navigationController setNavigationBarHidden:YES];
        [self.tabBarController.tabBar setHidden:YES];
    }
    else {
        self.view.userInteractionEnabled = YES;
        [self.navigationController setNavigationBarHidden:NO];
        [self.tabBarController.tabBar setHidden:NO];
        self.view.alpha = 1;
    }
}

- (void)setUser:(User *)user {
    _user = user;
}

#pragma mark - TableView Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        cell.delegate = self;
        [cell setUser:_user];
        return cell;
    }
    else {
        DealCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DealCell"];
        AppDeal *deal = _user.dealsSaved[indexPath.row - 1];
        [cell setDeal:deal];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _user.dealsSaved.count + 1;
}

#pragma mark - UserCell Delegate

- (void)userCell:(UserCell *)userCell didTapProfileImage:(UIImage *)image {
    UIImageView *fullScreenImageView = [[UIImageView alloc] initWithImage:userCell.profileImageView.image];
    fullScreenImageView.frame = [[UIScreen mainScreen] bounds];
    fullScreenImageView.backgroundColor = [UIColor blackColor];
    fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
    fullScreenImageView.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissFullScreenImage:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [fullScreenImageView addGestureRecognizer:swipeRecognizer];
    fullScreenImageView.alpha = 0;
    [UIView animateWithDuration:0.625 animations:^{
        [self.view addSubview:fullScreenImageView];
        [self.navigationController setNavigationBarHidden:YES];
        [self.tabBarController.tabBar setHidden:YES];
        fullScreenImageView.alpha = 1;
    }];
}

- (void)dismissFullScreenImage:(UISwipeGestureRecognizer *)sender {
    self.view.alpha = 0;
    [UIView animateWithDuration:0.65 animations:^{
        [self.navigationController setNavigationBarHidden:NO];
        [self.tabBarController.tabBar setHidden:NO];
        [sender.view removeFromSuperview];
        self.view.alpha = 1;
    }];
}

#pragma mark - UIImagePickerDelegate / Logic

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self updateProfileImage: originalImage ?: editedImage];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateProfileImage:(UIImage *)image {
    CGSize size = CGSizeMake(400, 400);
    _user.profileImageData = UIImagePNGRepresentation([self resizeImage:image withSize:size]);
}

- (void)pickImage {
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

#pragma mark - Navigation

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
