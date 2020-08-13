//
//  DealsViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "DealsViewController.h"
#import "DetailsViewController.h"
#import "DatabaseManager.h"
#import "AlertManager.h"
#import "AppDeal.h"
#import "DealCell.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "HUDManager.h"

@interface DealsViewController () <UITableViewDelegate,
                                   UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *deals;
@property (strong, nonatomic) NSMutableArray *savedDeals;

@end

@implementation DealsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    progressHUD.textLabel.text = @"Fetching deals...";
    [progressHUD showInView:self.view];
    [HUDManager setViewLoadingState:YES viewController:self];
    [DatabaseManager fetchItem:self.barcode viewController:self withCompletion:^(NSArray * _Nonnull deals, NSError * _Nonnull error) {
        if (deals.count > 0) {
            self.deals = (NSMutableArray *) deals;
            [DatabaseManager fetchSavedDeals:^(NSArray * _Nonnull deals, NSError * _Nonnull error) {
                if (self.deals.count == 0) {
                    self.savedDeals = [NSMutableArray array];
                }
                else {
                    self.savedDeals = (NSMutableArray *) deals;
                }
                [self.tableView reloadData];
                [progressHUD dismissAfterDelay:0.1 animated:YES];
                [HUDManager setViewLoadingState:NO viewController:self];
            }];
        }
        else {
            //alert
            NSLog(@"error %@", error.localizedDescription);
        }
    }];
}

- (BOOL)isDealSaved:(AppDeal *)deal {
    if (self.savedDeals.count == 0) {
        return NO;
    }
    for (AppDeal *savedDeal in self.savedDeals) {
        if ([deal.identifier isEqualToString:savedDeal.identifier]) {
            return YES;
        }
    }
    return NO;
}

- (void)removeDealWithIdentifier:(NSString *)identifier {
    AppDeal *dealToDelete;
    for (AppDeal *savedDeal in self.savedDeals) {
        if ([savedDeal.identifier isEqualToString:identifier]) {
            dealToDelete = savedDeal;
            break;
        }
    }
    [self.savedDeals removeObject:dealToDelete];
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell"];
    AppDeal *deal = self.deals[indexPath.row];
    [cell setDeal:deal];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deals.count;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDeal *deal = self.deals[indexPath.row];
    UIContextualAction *unsaveAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Unsave" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [DatabaseManager unsaveDeal:deal withCompletion:^(NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                [AlertManager dealNotSavedAlert:self];
            }
            completionHandler(YES);
        }];
        [self removeDealWithIdentifier:deal.identifier];
        [self.tableView reloadData];
    }];
    
    UIContextualAction *saveAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Save" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [DatabaseManager saveDeal:deal withCompletion:^(NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                [AlertManager dealNotSavedAlert:self];
            }
            completionHandler(YES);
        }];
        if (self.savedDeals.count == 0) {
            self.savedDeals = [NSMutableArray array];
        }
        [self.savedDeals addObject:deal];
        [self.tableView reloadData];
    }];
    saveAction.backgroundColor = [UIColor systemBlueColor];
    
    if ([self isDealSaved:deal]) {
        UISwipeActionsConfiguration *actionConfigurations = [UISwipeActionsConfiguration configurationWithActions:@[unsaveAction]];
        return actionConfigurations;
    }
    else {
        UISwipeActionsConfiguration *actionConfigurations = [UISwipeActionsConfiguration configurationWithActions:@[saveAction]];
        return actionConfigurations;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        AppDeal *currentDeal = self.deals[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.deal = currentDeal;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
