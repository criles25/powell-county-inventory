//
//  AddUpdateViewController.m
//  PowellCountyInventory
//
//  Created by Charles Riley on 3/29/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//

#import "AddUpdateViewController.h"
#import <Parse/Parse.h>

@interface AddUpdateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *assetTextField;
@property (weak, nonatomic) IBOutlet UITextField *buildingTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *operatingSystemTextField;
@property (weak, nonatomic) IBOutlet UITextField *cpuTextField;
@property (weak, nonatomic) IBOutlet UITextField *ramTextField;
@property (weak, nonatomic) IBOutlet UITextField *harddriveTextField;
@property (weak, nonatomic) IBOutlet UITextField *fundingTextField;
@property (weak, nonatomic) IBOutlet UITextField *adminAccessTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherAccessTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentAccessTextField;
@property (weak, nonatomic) IBOutlet UITextField *instructionalAccessTextField;

@end

@implementation AddUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPressed:(id)sender {
    // add if statements for checking fields have correct format
    if (self.barcodeTextField.text.length > 0) {
        // query parse
        PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
        [query whereKey:@"serial_number" equalTo:self.barcodeTextField.text];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                // barcode found
                NSLog(@"Found barcode %@.\n", self.barcodeTextField.text);
                if (self.assetTextField.text.length > 0) {
                    object[@"asset_tag"] = self.assetTextField.text;
                }
                if (self.buildingTextField.text.length > 0) {
                    object[@"building"] = self.buildingTextField.text;
                }
                if (self.roomTextField.text.length > 0) {
                    object[@"room"] = self.roomTextField.text;
                }
                if (self.deviceTypeTextField.text.length > 0) {
                    object[@"device_type"] = self.deviceTypeTextField.text;
                }
                if (self.brandTextField.text.length > 0) {
                    object[@"device_brand"] = self.brandTextField.text;
                }
                if (self.modelTextField.text.length > 0) {
                    object[@"device_model"] = self.modelTextField.text;
                }
                if (self.operatingSystemTextField.text.length > 0) {
                    object[@"os"] = self.operatingSystemTextField.text;
                }
                if (self.cpuTextField.text.length > 0) {
                    object[@"cpu_MHZ"] = self.cpuTextField.text;
                }
                if (self.ramTextField.text.length > 0) {
                    object[@"ram_mem"] = self.ramTextField.text;
                }
                if (self.harddriveTextField.text.length > 0) {
                    object[@"hd_size"] = self.harddriveTextField.text;
                }
                if (self.fundingTextField.text.length > 0) {
                    object[@"funding"] = self.fundingTextField.text;
                }
                if (self.adminAccessTextField.text.length > 0) {
                    object[@"admin_access"] = self.adminAccessTextField.text;
                }
                if (self.teacherAccessTextField.text.length > 0) {
                    object[@"teacher_access"] = self.teacherAccessTextField.text;
                }
                if (self.studentAccessTextField.text.length > 0) {
                    object[@"student_access"] = self.studentAccessTextField.text;
                }
                if (self.instructionalAccessTextField.text.length > 0) {
                    object[@"instructional_access"] = self.instructionalAccessTextField.text;
                }
                [object saveInBackground];
                //[self showBarcodeAlert:barcode barcodeFound:YES inRoom:object[@"room"]];
            } else {
                // barcode not found
                NSLog(@"Barcode not found %@.\n", self.barcodeTextField.text);
                PFObject *object = [PFObject objectWithClassName:@"DeviceInventory"];
                object[@"serial_number"] = self.barcodeTextField.text;
                //NSDate *date = [NSDate date]; // should we update lastScanned?
                //object[@"lastScanned"] = date;
                if (self.assetTextField.text.length > 0) {
                    object[@"asset_tag"] = self.assetTextField.text;
                } else {
                    object[@"asset_tag"] = @"not defined";
                }
                if (self.buildingTextField.text.length > 0) {
                    object[@"building"] = self.buildingTextField.text;
                } else {
                    object[@"building"] = @"not defined";
                }
                if (self.roomTextField.text.length > 0) {
                    object[@"room"] = self.roomTextField.text;
                } else {
                    object[@"room"] = @"not defined";
                }
                if (self.deviceTypeTextField.text.length > 0) {
                    object[@"device_type"] = self.deviceTypeTextField.text;
                } else {
                    object[@"device_type"] = @"not defined";
                }
                if (self.brandTextField.text.length > 0) {
                    object[@"device_brand"] = self.brandTextField.text;
                } else {
                    object[@"device_brand"] = @"not defined";
                }
                if (self.modelTextField.text.length > 0) {
                    object[@"device_model"] = self.modelTextField.text;
                } else {
                    object[@"device_model"] = @"not defined";
                }
                if (self.operatingSystemTextField.text.length > 0) {
                    object[@"os"] = self.operatingSystemTextField.text;
                } else {
                    object[@"os"] = @"not defined";
                }
                if (self.cpuTextField.text.length > 0) {
                    object[@"cpu_MHZ"] = self.cpuTextField.text;
                } else {
                    object[@"cpu_MHZ"] = @"not defined";
                }
                if (self.ramTextField.text.length > 0) {
                    object[@"ram_mem"] = self.ramTextField.text;
                } else {
                    object[@"ram_mem"] = @"not defined";
                }
                if (self.harddriveTextField.text.length > 0) {
                    object[@"hd_size"] = self.harddriveTextField.text;
                } else {
                    object[@"hd_size"] = @"not defined";
                }
                if (self.fundingTextField.text.length > 0) {
                    object[@"funding"] = self.fundingTextField.text;
                } else {
                    object[@"funding"] = @"not defined";
                }
                if (self.adminAccessTextField.text.length > 0) {
                    object[@"admin_access"] = self.adminAccessTextField.text;
                } else {
                    object[@"admin_access"] = false; // check that this works
                }
                if (self.teacherAccessTextField.text.length > 0) {
                    object[@"teacher_access"] = self.teacherAccessTextField.text;
                } else {
                    object[@"teacher_access"] = false; // same
                }
                if (self.studentAccessTextField.text.length > 0) {
                    object[@"student_access"] = self.studentAccessTextField.text;
                } else {
                    object[@"student_access"] = false; // sa,e
                }
                if (self.instructionalAccessTextField.text.length > 0) {
                    object[@"instructional_access"] = self.instructionalAccessTextField.text;
                } else {
                    object[@"instructional_access"] = false; // same again
                }
                [object saveInBackground];
                //[self showBarcodeAlert:barcode barcodeFound:NO inRoom:nil];
            }
        }];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.barcodeTextField resignFirstResponder];
    [self.assetTextField resignFirstResponder];
    [self.buildingTextField resignFirstResponder];
    [self.roomTextField resignFirstResponder];
    [self.deviceTypeTextField resignFirstResponder];
    [self.brandTextField resignFirstResponder];
    [self.modelTextField resignFirstResponder];
    [self.operatingSystemTextField resignFirstResponder];
    [self.cpuTextField resignFirstResponder];
    [self.ramTextField resignFirstResponder];
    [self.harddriveTextField resignFirstResponder];
    [self.fundingTextField resignFirstResponder];
    [self.adminAccessTextField resignFirstResponder];
    [self.teacherAccessTextField resignFirstResponder];
    [self.studentAccessTextField resignFirstResponder];
    [self.instructionalAccessTextField resignFirstResponder];
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
