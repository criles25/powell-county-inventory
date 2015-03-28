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
    PFQuery *query = [PFQuery queryWithClassName:@"practice"];
    
    // check if text filed is not empty
    if(self.searchTextField.text.length>0)
    {
        NSString *buildingName = self.searchTextField.text;
        [query whereKey:@"building" equalTo:(buildingName)];
        
    }
    
    // get the objects from parse
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
        if(!error)
        {
            
            NSString *line = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                              @"adm_use",
                              @"asset_number",
                              @"building",
                              @"computer",
                              @"cpu",
                              @"device_type",
                              @"funding",
                              @"hd",
                              @"inst_use",
                              @"os",
                              @"ram",
                              @"serial",
                              @"stu_use",
                              @"tchr_use",
                              @"room"];
            // array to store each row as line
            NSMutableArray *objectList = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
                line = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                        object[@"adm"],
                        object[@"asset"],
                        object[@"building"],
                        object[@"computer"],
                        object[@"cpu"],
                        object[@"device_type"],
                        object[@"funding"],
                        object[@"hd"],
                        object[@"inst"],
                        object[@"os"],
                        object[@"ram"],
                        object[@"serial"],
                        object[@"stu"],
                        object[@"tchr"],
                        object[@"teacher"]];
                [objectList addObject:line];
            }
        }
    }];
    }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
