//
//  ViewController.h
//  iOS7_BarcodeScanner
//
//  Created by Jake Widmer on 11/16/13.
//  Copyright (c) 2013 Jake Widmer. All rights reserved.
//
/* ScannerViewController manages calls to AVCaptureSession and AVCaptureMetadataOutput, classes that are included in Apple’s AVFoundation framework, for barcode scanning. Also, this class queries the Parse database for the scanned barcodes and passes data to the add or update UI. Finally, this class updates the ‘lastScanned’ column in the Parse database. */
/* We used an open-source implementation of a barcode scanner, found at https://github.com/jpwidmer/iOS7-BarcodeScanner, written by Jake Widmer. We modified the implementation to interact with the Parse database, as well as the add or update feature in our app. We also fixed a bug which caused it to scan a barcode multiple times. */

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface ScannerViewController : UIViewController<UIAlertViewDelegate, SettingsDelegate>
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;
@property (strong, nonatomic) PFObject *objectLastScanned;
- (IBAction)unwindToScan:(UIStoryboardSegue *)segue;
@end
