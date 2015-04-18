//
//  ViewController.h
//  iOS7_BarcodeScanner
//
//  Created by Jake Widmer on 11/16/13.
//  Copyright (c) 2013 Jake Widmer. All rights reserved.
//
/* ScannerViewController manages calls to AVCaptureSession and AVCaptureMetadataOutput, classes that are included in Apple’s AVFoundation framework, for barcode scanning. Also, this class queries the Parse database for the scanned barcodes and passes data to the add or update UI. Finally, this class updates the ‘lastScanned’ column in the Parse database. */

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface ScannerViewController : UIViewController<UIAlertViewDelegate, SettingsDelegate>
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;
@property (strong, nonatomic) PFObject *objectLastScanned;
- (IBAction)unwindToScan:(UIStoryboardSegue *)segue;
@end
