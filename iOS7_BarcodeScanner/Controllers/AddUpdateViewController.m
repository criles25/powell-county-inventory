//
//  AddUpdateViewController.m
//  PowellCountyInventory
//
//  Created by Charles Riley on 3/29/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//
/* AddUpdateViewController handles the textfields in the add or update UI, queries the Parse database for the specific barcode the user entered, and if the barcode is found, updates the fields in the database with the information the user entered in the textfields. If the barcode is not found, it adds the barcode (and its respective fields) to the Parse database. */


#import "AddUpdateViewController.h"
#import "ScannerViewController.h"
#define NSStringFromBOOL(aBOOL)    aBOOL? @"YES" : @"NO"

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

@implementation AddUpdateViewController {
    PFObject *objectLastScanned;
    BOOL fromScan;
}

// Do any additional setup after loading the view.
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
    // setup segue from scanner
    self.barcodeTextField.text = objectLastScanned[@"serial_number"];
    self.assetTextField.text = objectLastScanned[@"asset_tag"];
    self.buildingTextField.text = objectLastScanned[@"building"];
    self.roomTextField.text = objectLastScanned[@"room"];
    self.deviceTypeTextField.text = objectLastScanned[@"device_type"];
    self.brandTextField.text = objectLastScanned[@"device_brand"];
    self.modelTextField.text = objectLastScanned[@"device_model"];
    self.operatingSystemTextField.text = objectLastScanned[@"os"];
    self.cpuTextField.text = objectLastScanned[@"cpu_MHZ"];
    self.ramTextField.text = objectLastScanned[@"ram_mem"];
    self.harddriveTextField.text = objectLastScanned[@"hd_size"];
    self.fundingTextField.text = objectLastScanned[@"funding"];
    if ([objectLastScanned objectForKey:@"admin_access"]) {
        self.adminAccessTextField.text = NSStringFromBOOL(objectLastScanned[@"admin_access"]);
    }
    if ([objectLastScanned objectForKey:@"teacher_access"]) {
        self.teacherAccessTextField.text = NSStringFromBOOL(objectLastScanned[@"teacher_access"]);
    }
    if ([objectLastScanned objectForKey:@"student_access"]) {
        self.studentAccessTextField.text = NSStringFromBOOL(objectLastScanned[@"student_access"]);
    }
    if ([objectLastScanned objectForKey:@"instructional_access"]) {
        self.instructionalAccessTextField.text = NSStringFromBOOL(objectLastScanned[@"instructional_access"]);
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    self.txtFieldBranchYear.text = [formatter stringFromDate:objectLastScanned[@"lastScanned"]];
}

// Fill in textfields with values from scanner
-(void)setFields:(PFObject *)object; {
    self->objectLastScanned = object;
    self->fromScan = true;
}

// Hide the keyboard when user taps outside the textfield
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

// Format the string that appears in the date textfield
-(void) dateTextField:(id)sender
{
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

// Submit button pressed
- (IBAction)submitPressed:(id)sender {
    self.navigationItem.hidesBackButton = YES;
    // lock
    @synchronized(self) {
        if (self.barcodeTextField.text.length > 0) {
            // barcode entered
            // query parse
            PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
            [query whereKey:@"serial_number" equalTo:self.barcodeTextField.text];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    // barcode found
                    NSLog(@"Found barcode %@.\n", self.barcodeTextField.text);
                    bool update = false;
                    // get values from textfields
                    if (self.assetTextField.text.length > 0) {
                        update = true;
                        object[@"asset_tag"] = self.assetTextField.text;
                    }
                    if (self.buildingTextField.text.length > 0) {
                        update = true;
                        object[@"building"] = self.buildingTextField.text;
                    }
                    if (self.roomTextField.text.length > 0) {
                        update = true;
                        object[@"room"] = self.roomTextField.text;
                    }
                    if (self.deviceTypeTextField.text.length > 0) {
                        update = true;
                        object[@"device_type"] = self.deviceTypeTextField.text;
                    }
                    if (self.brandTextField.text.length > 0) {
                        update = true;
                        object[@"device_brand"] = self.brandTextField.text;
                    }
                    if (self.modelTextField.text.length > 0) {
                        update = true;
                        object[@"device_model"] = self.modelTextField.text;
                    }
                    if (self.operatingSystemTextField.text.length > 0) {
                        update = true;
                        object[@"os"] = self.operatingSystemTextField.text;
                    }
                    if (self.cpuTextField.text.length > 0) {
                        update = true;
                        object[@"cpu_MHZ"] = self.cpuTextField.text;
                    }
                    if (self.ramTextField.text.length > 0) {
                        update = true;
                        object[@"ram_mem"] = self.ramTextField.text;
                    }
                    if (self.harddriveTextField.text.length > 0) {
                        update = true;
                        object[@"hd_size"] = self.harddriveTextField.text;
                    }
                    if (self.fundingTextField.text.length > 0) {
                        update = true;
                        object[@"funding"] = self.fundingTextField.text;
                    }
                    if (self.adminAccessTextField.text.length > 0) {
                        update = true;
                        bool boolean = [self.adminAccessTextField.text boolValue];
                        NSNumber *number = [NSNumber numberWithBool:boolean];
                        object[@"admin_access"] = number;
                    }
                    if (self.teacherAccessTextField.text.length > 0) {
                        update = true;
                        bool boolean = [self.teacherAccessTextField.text boolValue];
                        NSNumber *number = [NSNumber numberWithBool:boolean];
                        object[@"teacher_access"] = number;
                    }
                    if (self.studentAccessTextField.text.length > 0) {
                        update = true;
                        bool boolean = [self.studentAccessTextField.text boolValue];
                        NSNumber *number = [NSNumber numberWithBool:boolean];
                        object[@"student_access"] = number;
                    }
                    if (self.instructionalAccessTextField.text.length > 0) {
                        update = true;
                        bool boolean = [self.instructionalAccessTextField.text boolValue];
                        NSNumber *number = [NSNumber numberWithBool:boolean];
                        object[@"instructional_access"] = number;
                    }
                    if (self.txtFieldBranchYear.text.length > 0) {
                        update = true;
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
                        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                        NSDate *date = [[NSDate alloc] init];
                        date = [formatter dateFromString:self.txtFieldBranchYear.text];
                        object[@"lastScanned"] = date;
                        //NSLog(@"%@\n", date);
                    }
                    if (update) {
                        [object saveInBackground];
                        // alert message
                        NSString *string = @"You successfully updated the values for device with barcode ";
                        NSString *append = self.barcodeTextField.text;
                        NSString *message = [string stringByAppendingString:append];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Updated!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        // reset values in textfields
                        self.barcodeTextField.text = @"";
                        self.assetTextField.text = @"";
                        self.buildingTextField.text = @"";
                        self.roomTextField.text = @"";
                        self.deviceTypeTextField.text = @"";
                        self.brandTextField.text = @"";
                        self.modelTextField.text = @"";
                        self.operatingSystemTextField.text = @"";
                        self.cpuTextField.text = @"";
                        self.ramTextField.text = @"";
                        self.harddriveTextField.text = @"";
                        self.fundingTextField.text = @"";
                        self.adminAccessTextField.text = @"";
                        self.teacherAccessTextField.text = @"";
                        self.studentAccessTextField.text = @"";
                        self.instructionalAccessTextField.text = @"";
                        self.txtFieldBranchYear.text = @"";
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Fields!" message:@"Enter a value into a field to change its value" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                    
                } else if ([error code] == kPFErrorConnectionFailed) {
                    // couldn't connect to parse
                    NSLog(@"Uh oh, we couldn't even connect to the Parse Cloud!");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Connect!" message:@"We couldn't connect to Parse. Make sure you have internet access or cell service." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                } else {
                    // barcode not found
                    NSLog(@"Barcode not found %@.\n", self.barcodeTextField.text);
                    // create object to be stored in parse
                    PFObject *object = [PFObject objectWithClassName:@"DeviceInventory"];
                    object[@"serial_number"] = self.barcodeTextField.text;
                    // get values from textfields
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
                        bool boolean = [self.adminAccessTextField.text boolValue];
                        NSNumber *number = [NSNumber numberWithBool:boolean];
                        object[@"admin_access"] = number;
                    }
                    if (self.teacherAccessTextField.text.length > 0) {
                        bool boolean = [self.teacherAccessTextField.text boolValue];
                        NSNumber *number = [NSNumber numberWithBool:boolean];
                        object[@"teacher_access"] = number;
                    }
                    if (self.studentAccessTextField.text.length > 0) {
                        bool boolean = [self.studentAccessTextField.text boolValue];
                        NSNumber *number = [NSNumber numberWithBool:boolean];
                        object[@"student_access"] = number;
                    }
                    if (self.instructionalAccessTextField.text.length > 0) {
                        bool boolean = [self.instructionalAccessTextField.text boolValue];
                        NSNumber *number = [NSNumber numberWithBool:boolean];
                        object[@"instructional_access"] = number;
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
                    // alert message
                    NSString *string = @"You successfully added the device with barcode ";
                    NSString *append = self.barcodeTextField.text;
                    NSString *message = [string stringByAppendingString:append];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Added!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    // reset values in textfields
                    self.barcodeTextField.text = @"";
                    self.assetTextField.text = @"";
                    self.buildingTextField.text = @"";
                    self.roomTextField.text = @"";
                    self.deviceTypeTextField.text = @"";
                    self.brandTextField.text = @"";
                    self.modelTextField.text = @"";
                    self.operatingSystemTextField.text = @"";
                    self.cpuTextField.text = @"";
                    self.ramTextField.text = @"";
                    self.harddriveTextField.text = @"";
                    self.fundingTextField.text = @"";
                    self.adminAccessTextField.text = @"";
                    self.teacherAccessTextField.text = @"";
                    self.studentAccessTextField.text = @"";
                    self.instructionalAccessTextField.text = @"";
                    self.txtFieldBranchYear.text = @"";
                    [alert show];
                }
            }];
        } else {
            // no barcode entered
            NSLog(@"No barcode!\n");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Barcode!" message:@"Please enter a barcode to add or update." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

// Hide keyboard when 'Return' pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Go back to scanner
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.navigationItem.hidesBackButton = NO;
    if (self->fromScan) {
        [self performSegueWithIdentifier:@"unwindToScan" sender:self];
    }
}

@end
