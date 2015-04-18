//
//  AddUpdateViewController.h
//  PowellCountyInventory
//
//  Created by Charles Riley on 3/29/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//
/* AddUpdateViewController handles the textfields in the add or update UI, queries the Parse database for the specific barcode the user entered, and if the barcode is found, updates the fields in the database with the information the user entered in the textfields. If the barcode is not found, it adds the barcode (and its respective fields) to the Parse database. */

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddUpdateViewController : UIViewController
-(void)setFields:(PFObject *)object;
@end
