//
//  SearchController.m
//  iOS7_BarcodeScanner
//
//  Created by Charles Riley on 3/24/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//

#import "SearchController.h"
#import <Parse/Parse.h>

@interface SearchController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


@end

@implementation SearchController
- (IBAction)searchButtonPressed:(id)sender {
    // Query parse back end
//    PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
    
    // check if text filed is not empty
    if(self.searchTextField.text.length>0)
    {
        //NSString *barcodeId= self.searchTextField.text;
        //[query whereKey:@"serial_number" equalTo:barcodeId];
        PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
        [query whereKey:@"serial_number" equalTo:self.searchTextField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                // Create object
                PFObject *object = objects[0];
                NSString *line = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@\n",
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
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    }
    
    // get the objects from parse
   // [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
