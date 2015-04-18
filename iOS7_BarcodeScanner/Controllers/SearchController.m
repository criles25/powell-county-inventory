//
//  SearchController.m
//  iOS7_BarcodeScanner
//
//  Created by Charles Riley on 3/24/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//
/* SearchController handles the barcode textfield, searches the Parse database for the barcode, and returns information about the barcode if it was found. */

#import "SearchController.h"
#import <Parse/Parse.h>

@interface SearchController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


@end

@implementation SearchController
- (IBAction)searchButtonPressed:(id)sender {
    // Query parse back end
    // check if text field is not empty
    if(self.searchTextField.text.length>0)
    {
        // Set connection with Device Inventory table in parse
        PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
        
        // Get record matched with serial number attribute in Device Inventory table
        [query whereKey:@"serial_number" equalTo:self.searchTextField.text];
        
        // Get the objects
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu scores.", (unsigned long)[objects count]);
                NSUInteger sizeOfObjects = [objects count];
                
                if(sizeOfObjects>0){
                // Create object
                PFObject *object = objects[0];
                NSString *line = [NSString stringWithFormat:@"SerialNumber=%@\rAssetTag=%@\rBuilding=%@\rRoom=%@\rDeviceType=%@\rDeviceBrand=%@\rDeviceModel=%@\n",
                                  object[@"serial_number"],
                                  object[@"asset_tag"],
                                  object[@"building"],
                                  object[@"room"],
                                  object[@"device_type"],
                                  object[@"device_brand"],
                                  object[@"device_model"]
                                  ];
                // show alert
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Found!"
                                                                 message:line
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                [alert show];
                }
                else{
                    // show failure alert
                    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Not Found!"
                                                                     message:@"Enter Valid Barcode"
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles: nil];
                    [alert show];
                    
                }
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            }
        }];
        
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
