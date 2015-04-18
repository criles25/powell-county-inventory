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
@property (weak, nonatomic) IBOutlet UITextField *lastFoundTextField;
@property (weak, nonatomic) IBOutlet UITextField *filenameTextField;

@end

@implementation ExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup last found textfield
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    //[datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.lastFoundTextField setInputView:datePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dateTextField:(id)sender
{
    //[picker setMaximumDate:[NSDate date]];
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    UIDatePicker *picker = (UIDatePicker*)self.lastFoundTextField.inputView;
    NSDate *eventDate = picker.date;
    NSString *dateString = [formatter stringFromDate:eventDate];
    self.lastFoundTextField.text = [NSString stringWithFormat:@"%@",dateString];
}

- (IBAction)handleExportButtonClick:(id)sender {
    // Charles Riley
    self.navigationItem.hidesBackButton = YES;
    NSMutableArray *warnings = [[NSMutableArray alloc] init];
    // query database
    PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
    // Buildings
    NSArray *buildings;
    if (self.buildingTextField.text.length > 0) {
        buildings = [self.buildingTextField.text componentsSeparatedByString:@"/"];
        [query whereKey:@"building" containedIn:buildings];
    }
    // Rooms
    NSArray *rooms;
    if (self.roomTextField.text.length > 0) {
        rooms = [self.roomTextField.text componentsSeparatedByString:@"/"];
        [query whereKey:@"room" containedIn:rooms];
    }
    // Device types
    NSArray *devices;
    if (self.deviceTextField.text.length > 0) {
        devices = [self.deviceTextField.text componentsSeparatedByString:@"/"];
        [query whereKey:@"device_type" containedIn:devices];
    }
    // Last found date
    if (self.lastFoundTextField.text.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDate *date = [[NSDate alloc] init];
        date = [formatter dateFromString:self.lastFoundTextField.text];
        [query whereKey:@"lastScanned" greaterThanOrEqualTo:date];
    }
    // Filename
    NSString *filename = @"inventory.csv";
    if (self.filenameTextField.text.length > 0) {
        filename = self.filenameTextField.text;
        filename = [filename stringByAppendingString:@".csv"];
    }
    // build .csv file
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // create warnings
            for (NSString *building in buildings) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"building == %@", building];
                NSArray *array = [objects filteredArrayUsingPredicate:predicate];
                if (![array count]) {
                    NSLog(@"Warning: none of this building type %@ found!", building);
                    NSString *warning = @"Warning: none of building type ";
                    warning = [warning stringByAppendingString:building];
                    [warnings addObject:warning];
                }
            }
            for (NSString *room in rooms) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"room == %@", room];
                NSArray *array = [objects filteredArrayUsingPredicate:predicate];
                if (![array count]) {
                    NSLog(@"Warning: none of this room type %@ found!", room);
                    NSString *warning = @"Warning: none of room type ";
                    warning = [warning stringByAppendingString:room];
                    [warnings addObject:warning];
                }
            }
            for (NSString *device in devices) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"device_type == %@", device];
                NSArray *array = [objects filteredArrayUsingPredicate:predicate];
                if (![array count]) {
                    NSLog(@"Warning: none of this device type %@ found!", device);
                    NSString *warning = @"Warning: none of device type ";
                    warning = [warning stringByAppendingString:device];
                    [warnings addObject:warning];
                }
            }
            
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
            NSString *file = [path stringByAppendingPathComponent:filename];
            if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
                NSString *warning = @"Warning: overwriting existing file with name ";
                warning = [warning stringByAppendingString:filename];
                [warnings addObject:warning];
            }
            [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:file];
            [fileHandle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
            for (PFObject *object in objects) {
                //NSLog(@"%@", object.objectId);
                line = [NSString stringWithFormat:@"%@,%@,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%@,%@,%@,%@\n",
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
            NSLog(@"%@\n", path);
            NSString *message = @"Exported inventory to .csv file with name ";
            message = [message stringByAppendingString:filename];
            for (NSString *warning in warnings) {
                message = [message stringByAppendingString:@"\n"];
                message = [message stringByAppendingString:warning];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Inventory Exported!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            // log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Export!" message:@"Make sure you have cell service or an internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    // reset text fields to be empty
    self.buildingTextField.text = @"";
    self.roomTextField.text = @"";
    self.deviceTextField.text = @"";
    self.lastFoundTextField.text = @"";
    self.filenameTextField.text = @"";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.buildingTextField resignFirstResponder];
    [self.roomTextField resignFirstResponder];
    [self.deviceTextField resignFirstResponder];
    [self.lastFoundTextField resignFirstResponder];
    [self.filenameTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.navigationItem.hidesBackButton = NO;
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
