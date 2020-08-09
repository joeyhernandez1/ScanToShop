//
//  ItemHistoryViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 8/7/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "ItemHistoryViewController.h"
#import "DealsViewController.h"
#import "DatabaseManager.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "HUDManager.h"
#import "ItemCollectionCell.h"
#import "AppItem.h"

@interface ItemHistoryViewController () <UICollectionViewDelegate,
                                         UICollectionViewDataSource,
                                         UICollectionViewDelegateFlowLayout,
                                         UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIView *searchBarPlaceHolder;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSArray *filteredItems;

@end

@implementation ItemHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    progressHUD.textLabel.text = @"Fetching recents...";
    [progressHUD showInView:self.view];
    [HUDManager setViewLoadingState:YES viewController:self];
    [DatabaseManager fetchRecentItems:^(NSArray * _Nonnull items, NSError * _Nonnull error) {
        if (items.count > 0) {
            self.items = (NSMutableArray *) items;
            self.filteredItems = self.items;
            [self.collectionView reloadData];
            progressHUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        }
        [progressHUD dismissAfterDelay:0.1 animated:YES];
        [HUDManager setViewLoadingState:NO viewController:self];
    }];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollab;
    self.definesPresentationContext = YES;

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.flowLayout.minimumLineSpacing = 1.25;
    self.flowLayout.minimumInteritemSpacing = 1.25;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - CollectionView Delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCollectionCell" forIndexPath:indexPath];
    AppItem *currentItem = self.filteredItems[indexPath.row];
    [cell setItem:currentItem];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredItems.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat totalwidth = self.collectionView.bounds.size.width;
    CGFloat postersPerLine = 2;
    CGFloat dimensions = (totalwidth - self.flowLayout.minimumInteritemSpacing * (postersPerLine-1)) / postersPerLine;
    return CGSizeMake(dimensions, dimensions*1.3);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"historySegue"]) {
        DealsViewController *dealsController = [segue destinationViewController];
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        AppItem *currentItem = self.items[indexPath.row];
        dealsController.barcode = currentItem.barcode;
    }
}

#pragma mark - SearchResultsUpdating

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (searchText) {
        if (searchText.length != 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",searchText];
            self.filteredItems = [self.items filteredArrayUsingPredicate:predicate];
        }
        else {
            self.filteredItems = self.items;
        }
        
        [self.collectionView reloadData];
    }
}

@end
