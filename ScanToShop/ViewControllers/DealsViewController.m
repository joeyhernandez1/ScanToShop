//
//  DealsViewController.m
//  ScanToShop
//
//  Created by Joey R. Hernandez Perez on 7/13/20.
//  Copyright © 2020 joeyrhernandez1. All rights reserved.
//

#import "DealsViewController.h"
#import "BarcodeScanViewController.h"
#import "DealCell.h"

@interface DealsViewController () <UITableViewDelegate,
                                   UITableViewDataSource,
                                   BarcodeScanViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *barcode;

@end

@implementation DealsViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DealCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DealCell"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (void)didScanBarcode:(NSString *)barcode {
    self.barcode = barcode;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    BarcodeScanViewController *barcodeController = (BarcodeScanViewController*)navigationController.topViewController;
    barcodeController.delegate = self;
}

@end
