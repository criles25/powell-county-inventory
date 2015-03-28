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
    PFQuery *query = [PFQuery queryWithClassName:@"practice"];
    if (self.buildingTextField.text.length > 0) {
        NSArray *buildings = [self.buildingTextField.text componentsSeparatedByString:@" "];
        [query whereKey:@"building" containedIn:buildings];
    }
    if (self.roomTextField.text.length > 0) {
        NSArray *rooms = [self.roomTextField.text componentsSeparatedByString:@" "];
        [query whereKey:@"teacher" containedIn:rooms];
    }
    if (self.deviceTextField.text.length > 0) {
        NSArray *devices = [self.deviceTextField.text componentsSeparatedByString:@" "];
        [query whereKey:@"device_type" containedIn:devices];
    }
    // build .csv file
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // code to build .csv file
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
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *file = [path stringByAppendingPathComponent:@"inventory.csv"];
            [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:file];
            [fileHandle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
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