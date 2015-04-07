//
//  ImportViewController.m
//  iOS7_BarcodeScanner
//
//  Created by Charles Riley on 3/24/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//

#import "ImportViewController.h"

@interface ImportViewController ()
@property (weak, nonatomic) IBOutlet UITextField *filenameTextField;

@end

@implementation ImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleImportButtonClick:(id)sender {
    // Charles Riley
    // Maria, put your code here please!
    
    //Store file name specified by user.
    
    NSString *filename = self.filenameTextField.text;
    
    //Check that file specified is a csv file.
    
    NSString *ext=[filename pathExtension];
    
    if (![ext isEqualToString:@"csv"]) //if not a csv file ... then alert the user.
    {
        //Alert the user that the file is not of the correct format.
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                    message:@"The file specified is not a .csv file."
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [alert show];
        
        //don't let anything else happen beyong this point. Go back to original display.
    }
    else //else ... the file is of the correct format (.csv), so continue the import process
    {
        //Should use a sample .csv file within simulator, for testing**
        
        //Find path of file inside the Documents folder of our app.
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
        //Check if file exists
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if(fileExists == NO) //if file does not exist ... then alert the user
        {
            //Alert the user that the file is not of the correct format.
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                        message:@"The file specified does not exist in the device."
                                                        delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            [alert show];
            
            //don't let anything else happen beyong this point. Go back to original display.
        }
        else
        {
            //Access the contents of the file and parse the file. ***
    
            NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
            //Note: Make sure that serial number and room have values in the csv file.
        
            //I will use code from https://parse.com/questions/import-xlscsv-in-existing-table to do stuff here
        }
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.filenameTextField resignFirstResponder];
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
