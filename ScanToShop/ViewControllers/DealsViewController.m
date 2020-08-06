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
#import "AppDeal.h"
#import "DealCell.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "HUDManager.h"

@interface DealsViewController () <UITableViewDelegate,
                                   UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *deals;

@end

@implementation DealsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    JGProgressHUD *progressHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    progressHUD.textLabel.text = @"Fetching deals...";
    [progressHUD showInView:self.view];
    [HUDManager setViewLoadingState:YES viewController:self];
    [DatabaseManager fetchItem:self.barcode viewController:self withCompletion:^(NSArray * _Nonnull deals, NSError * _Nonnull error) {
        if (deals.count > 0) {
            self.deals = (NSMutableArray *) deals;
            [self.tableView reloadData];
        }
        else {
            //alert
            NSLog(@"error %@", error.localizedDescription);
        }
        [progressHUD dismissAfterDelay:0.1 animated:YES];
        [HUDManager setViewLoadingState:NO viewController:self];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell"];
    AppDeal *deal = self.deals[indexPath.row];
    [cell setDeal:deal];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deals.count;
}

- (void)didScanBarcode:(NSString *)barcode {
    self.barcode = barcode;
}

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
