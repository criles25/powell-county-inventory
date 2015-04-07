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
        
        //don't let anything else happen beyond this point. Go back to original display.
    }
    else //else ... the file is of the correct format (.csv), so continue the import process
    {
        //Should use a sample .csv file within simulator, for testing***
        //check here for where to store file so that simulator has access:
        //http://stackoverflow.com/questions/9712551/finding-a-saved-file-on-the-simulator
        
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
            
            //don't let anything else happen beyond this point. Go back to original display.
        }
        else
        {
            //Access the contents of the file and parse the file.
    
            NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
            NSArray *rows = [content componentsSeparatedByString:@"\n"];
            NSUInteger numOfRows = [rows count];
            
            NSMutableArray *problemRows = [[NSMutableArray alloc]init];
            NSMutableArray *allTheData = [[NSMutableArray alloc]init];
            
            BOOL problemExists = NO;
            
            //store column names
            NSArray *columnNames = [rows[0] componentsSeparatedByString:@","];
            NSUInteger numOfColumns = [columnNames count];
            
            //remove row with names from rows array
            
            //for (NSString *row in rows)
            for(int i = 1; i < numOfRows; i++) //ignore first row, which contains column names
            {
                NSArray *columns = [rows[i] componentsSeparatedByString:@","]; //entries in row i
                
                //go through stored entries in current row and check if serial number or room are empty
                for(int j = 0; [columns count]; j++)
                {
                    if([columnNames[j] isEqualToString:@"serial_number"])
                    {
                        if([columns[j] length] == 0)
                        {
                            //Serial number entry is empty. not good! This means that none of this will be stored
                            //into the Parse table until the problem is fixed. So, for now, store the row number so
                            //that later we can tell the user where the problem was found.
                            
                            NSNumber *rowNum = [NSNumber numberWithInt:i]; //store row index into NSNumber object
                            [problemRows addObject:rowNum];
                            problemExists = YES;
                        }
                    }
                    if([columnNames[j] isEqualToString:@"room"])
                    {
                        if([columns[j] length] == 0)
                        {
                            //Room entry is empty. not good! This means that none of this will be stored
                            //into the Parse table until the problem is fixed. So, for now, store the row number so
                            //that later we can tell the user where the problem was found.
                            
                            NSNumber *rowNum = [NSNumber numberWithInt:i]; //store row index into NSNumber object
                            [problemRows addObject:rowNum];
                            problemExists = YES;
                        }
                    }
                    
                }
                
                //Add data into multidimensional array, so to later have all the data in one place and, if conditions
                //are right, store the data into the Parse database
                
                [allTheData addObject:columns];

            }
            
            //Now, if no problems are present (no serial numbers or rooms were empty), then proceed to update Parse.
            
            if(problemExists == NO)
            {
                for(int i = 0; i < numOfRows; i++) //go through rows
                {
                    //PFObject *deviceInfo = [PFObject objectWithClassName:@"DeviceInventory"];
                    PFObject *deviceInfo = [PFObject objectWithClassName:@"practice"]; //practice table
                    NSArray *therow = allTheData[i];
                    
                    for(int j=0; j < numOfColumns; j++) //go through rows
                    {
                        deviceInfo[columnNames[j]] = therow[j];
                    }
                    
                    //add or update row in Parse table
                    
                    [deviceInfo saveInBackground];
                    
                }
            }
            else //there is a problem present!
            {
                //Alert the user that either serial numbers or rooms were left blank in some rows
                //and specify in which rows
                
                NSString *message1 = @"The following rows in the file have either empty serial numbers or empty room values: ";
                NSString *theproblemrows = [[problemRows valueForKey:@"description"] componentsJoinedByString:@","];
                
                NSString *themessage = [NSString stringWithFormat:@"%@/%@/", message1, theproblemrows];
                
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                 message:themessage
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                [alert show];
            }

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
