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
@property (weak, nonatomic) IBOutlet UITextField *txtFieldBranchYear;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end

@implementation AddUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup scroll view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];
    // setup last found textfield
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.txtFieldBranchYear setInputView:datePicker];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    // hide keyboard
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
    [self.txtFieldBranchYear resignFirstResponder];
}

-(void) dateTextField:(id)sender
{
    
    //[picker setMaximumDate:[NSDate date]];
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    UIDatePicker *picker = (UIDatePicker*)self.txtFieldBranchYear.inputView;
    NSDate *eventDate = picker.date;
    NSString *dateString = [formatter stringFromDate:eventDate];
    self.txtFieldBranchYear.text = [NSString stringWithFormat:@"%@",dateString];
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
                if (self.txtFieldBranchYear.text.length > 0) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    NSDate *date = [[NSDate alloc] init];
                    date = [formatter dateFromString:self.txtFieldBranchYear.text];
                    object[@"lastScanned"] = date;
                    //NSLog(@"%@\n", date);
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
                }
                if (self.buildingTextField.text.length > 0) {
                    object[@"building"] = self.buildingTextField.text;
                }
                if (self.roomTextField.text.length > 0) {
                    object[@"room"] = self.roomTextField.text;
                } else {
                    object[@"room"] = @"undefined";
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
                if (self.txtFieldBranchYear.text.length > 0) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    NSDate *date = [[NSDate alloc] init];
                    date = [formatter dateFromString:self.txtFieldBranchYear.text];
                    object[@"lastScanned"] = date;
                    //NSLog(@"%@\n", date);
                }
                [object saveInBackground];
                //[self showBarcodeAlert:barcode barcodeFound:NO inRoom:nil];
            }
        }];
    }
    
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
