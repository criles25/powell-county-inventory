//
//  ExportViewController.m
//  iOS7_BarcodeScanner
//
//  Created by Charles Riley on 3/14/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//

#import "ExportViewController.h"
#import <Parse/Parse.h>

@interface ExportViewController ()
@property (weak, nonatomic) IBOutlet UITextField *buildingTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceTextField;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;

@end

@implementation ExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleExportButtonClick:(id)sender {
    // Charles Riley
    // query database
    PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
    if (self.buildingTextField.text.length > 0) {
        NSArray *buildings = [self.buildingTextField.text componentsSeparatedByString:@" "];
        [query whereKey:@"building" containedIn:buildings];
    }
    if (self.roomTextField.text.length > 0) {
        NSArray *rooms = [self.roomTextField.text componentsSeparatedByString:@" "];
        [query whereKey:@"room" containedIn:rooms];
    }
    if (self.deviceTextField.text.length > 0) {
        NSArray *devices = [self.deviceTextField.text componentsSeparatedByString:@" "];
        [query whereKey:@"device_type" containedIn:devices];
    }
    // build .csv file
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // code to build .csv file
            NSString *line = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                              @"serial_number",
                              @"asset_tag",
                              @"building",
                              @"room",
                              @"device_type",
                              @"device_brand",
                              @"device_model",
                              @"os",
                              @"cpu_MHZ",
                              @"ram_mem",
                              @"hd_size",
                              @"funding",
                              @"admin_access",
                              @"teacher_access",
                              @"student_access",
                              @"instructional_access"];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *file = [path stringByAppendingPathComponent:@"inventory.csv"];
            [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:file];
            [fileHandle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
                line = [NSString stringWithFormat:@"%@,%@,%@,\"%@\",%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                        object[@"serial_number"],
                        object[@"asset_tag"],
                        object[@"building"],
                        object[@"room"],
                        object[@"device_type"],
                        object[@"device_brand"],
                        object[@"device_model"],
                        object[@"os"],
                        object[@"cpu_MHZ"],
                        object[@"ram_mem"],
                        object[@"hd_size"],
                        object[@"funding"],
                        object[@"admin_access"],
                        object[@"teacher_access"],
                        object[@"student_access"],
                        object[@"instructional_access"]];
                //NSLog(@"%@", line);
                [fileHandle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
            }
            [fileHandle closeFile];
            //NSLog(@"%@\n", path);
        } else {
            // log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    // email .csv file
    // Dhish, put your code here!
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.buildingTextField resignFirstResponder];
    [self.roomTextField resignFirstResponder];
    [self.deviceTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
