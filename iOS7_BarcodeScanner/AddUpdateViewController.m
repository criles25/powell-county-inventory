//
//  AddUpdateViewController.m
//  PowellCountyInventory
//
//  Created by Charles Riley on 3/29/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//

#import "AddUpdateViewController.h"

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
