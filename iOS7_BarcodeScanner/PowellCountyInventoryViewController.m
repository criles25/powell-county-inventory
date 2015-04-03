//
//  PowellCountyInventoryViewController.m
//  PowellCountyInventory
//
//  Created by Charles Riley on 3/29/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//

#import "PowellCountyInventoryViewController.h"
#import "ScannerViewController.h"

@interface PowellCountyInventoryViewController ()

@end

@implementation PowellCountyInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToPCInventory:(UIStoryboardSegue *)segue {
    ScannerViewController *source = [segue sourceViewController];
    self.objectLastScanned = source.objectLastScanned;
    NSLog(@"Barcode in unwind method %@.\n", self.objectLastScanned[@"serial_number"]);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
