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
        //Find path of file inside the Documents folder of our app.
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
        //Should use a sample .csv file within simulator, for testing***
        //the following outputs in the xcode terminal what the path for our simulator is
        NSLog(@"%@\n", filePath);
        
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
            BOOL problemExists = NO;
            
            //__block NSMutableArray *duplicateRows = [[NSMutableArray alloc]init];
            //__block BOOL duplicateSerials = NO;
            
            NSMutableArray *allTheData = [[NSMutableArray alloc]init];
            
            //store column names
            NSArray *columnNames = [rows[0] componentsSeparatedByString:@","];
            NSUInteger numOfColumns = [columnNames count];
            
            //Before dealing with the data in the table of the .csv file, let's first make sure that the
            //column names are valid column names (as in, the column names are the same as their respective
            //column names within the Parse table).
            
            //create mutable array to store correct Parse table column names (for comparison)
            
            NSMutableArray *parseColumnNames = [[NSMutableArray alloc] init];
            
            [parseColumnNames addObject:@"serial_number"];
            [parseColumnNames addObject:@"asset_tag"];
            [parseColumnNames addObject:@"building"];
            [parseColumnNames addObject:@"room"];
            [parseColumnNames addObject:@"device_type"];
            [parseColumnNames addObject:@"device_brand"];
            [parseColumnNames addObject:@"device_model"];
            [parseColumnNames addObject:@"os"];
            [parseColumnNames addObject:@"cpu_MHZ"];
            [parseColumnNames addObject:@"ram_mem"];
            [parseColumnNames addObject:@"hd_size"];
            [parseColumnNames addObject:@"funding"];
            [parseColumnNames addObject:@"admin_access"];
            [parseColumnNames addObject:@"teacher_access"];
            [parseColumnNames addObject:@"student_access"];
            [parseColumnNames addObject:@"instructional_access"];
            [parseColumnNames addObject:@"location"];

            //go through column names and check if they exist
            
            BOOL columnNameProblem = NO;
            NSMutableArray *problemColumnNames = [[NSMutableArray alloc]init];
            
            NSMutableArray *theSerials = [[NSMutableArray alloc] init];
            NSMutableArray *repeatedSerials = [[NSMutableArray alloc] init];
            
            for(int i = 0; i < numOfColumns; i++)
            {
                if([parseColumnNames containsObject: columnNames[i]] == NO)
                {
                    //Error! Error! Store column name to later report which columns have the wrong name...
                    
                    NSString *colName = columnNames[i];
                    [problemColumnNames addObject:colName];
                    
                    columnNameProblem = YES;
                }
                else
                {
                    //remove found column names so to not allow for repeated column names in the file
                    NSInteger theindex = [parseColumnNames indexOfObject:columnNames[i]];
                    [parseColumnNames removeObjectAtIndex:theindex];
                    //let's keep checking, shall we?
                }
            }
            
            //Now check if the .csv file contains a serial_number column and a room column
            //We will check this by checking if "serial_number" and "room" are still in parsecolumnNames.
            //These two strings would have been removed by now if the .csv file did have the respective
            //columns.

            if(columnNameProblem == YES)
            {
                //ALERT THE USER
                //Tell him/her which columns have inconsistencies
                //should tell the user that it is possible that the column name is correct but it is a duplicate**
                
                NSString *message1 = @"The following column names in the file are not valid (or are repeated): ";
                NSString *theproblemcols = [[problemColumnNames valueForKey:@"description"] componentsJoinedByString:@","];
                
                NSString *themessage = [NSString stringWithFormat:@"%@%@", message1, theproblemcols];
                
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                 message:themessage
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                [alert show];
                
                //Don't continue beyond this point.
                return;
            }
            else
            {
                //Okay, so the column names in the .csv file exist within the Parse table.
                
                //Now check if the .csv file contains a serial_number column and a room column
                //We will check this by checking if "serial_number" and "room" are still in parsecolumnNames.
                //These two strings would have been removed by now if the .csv file did have the respective
                //columns.
                
                if(([parseColumnNames containsObject: @"serial_number"] == YES) || ([parseColumnNames containsObject: @"room"] == YES))
                {
                    //ALERT THE USER
                    //Tell him/her which columns have inconsistencies
                    //should tell the user that it is possible that the column name is correct but it is a duplicate**
                    
                    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                     message:@"The file is missing either a serial_number column or a room column."
                                                                    delegate:self
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles: nil];
                    [alert show];
                    
                    //Don't continue beyond this point.
                    return;
                }
            }
            
            
            //Now that we know column names are right, let's go through values of the .csv file
            
            //for (NSString *row in rows)
            for(int i = 1; i < numOfRows; i++) //ignore first row, which contains column names
            {
                //change this so that it works when an entry has commas
                //f an entry is num1,num2 then the csv file has it as "num1,num2" (including the quotes)
                NSArray *columns = [rows[i] componentsSeparatedByString:@","]; //entries in row i
                
                //go through stored entries in current row and check if serial number or room are empty
                for(int j = 0; j < [columns count]; j++)
                {
                    if([columnNames[j] isEqualToString:@"room"] || [columnNames[j] isEqualToString:@"serial_number"])
                    {
                        if([columns[j] length] == 0) //if there is no room value...
                        {
                            //serial number or room entry is empty. not good! This means that none of this will be stored
                            //into the Parse table until the problem is fixed. So, for now, store the row number so
                            //that later we can tell the user where the problem was found.
                            
                            NSNumber *rowNum = [NSNumber numberWithInt:i+1]; //store row index into NSNumber object
                            [problemRows addObject:rowNum];
                            problemExists = YES;
                        }
                        else //there is a value for serial number, let's check if it is repeated
                        {
                            if([columnNames[j] isEqualToString:@"serial_number"])
                            {
                                NSString *serialnumber = columns[j];
                                if([theSerials containsObject: serialnumber] == YES)
                                {
                                    
                                    NSNumber *rowNum = [NSNumber numberWithInt:i+1];
                                    [repeatedSerials addObject:rowNum];
                                    
                                }
                                else
                                {
                                    [theSerials addObject:serialnumber]; //serialnumber is columns[i] or something
                                }
                            }
                        }
                    }
                }
                
                //Add data into multidimensional array, so to later have all the data in one place and, if conditions
                //are right, store the data into the Parse database
                
                [allTheData addObject:columns];

            }
            
            //Now, if no problems are present (no serial numbers or rooms were empty), then proceed to update Parse.
            
            if((problemExists == NO) && ([repeatedSerials count] == 0))
            {
                    NSInteger serialColIndex = [columnNames indexOfObject:@"serial_number"];
                
                    for(int i = 0; i < (numOfRows-1); i++) //go through rows
                    {
                        NSString *serialnumber = allTheData[i][(int)serialColIndex];
                        
                        
                        PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
                        [query whereKey:@"serial_number" equalTo:serialnumber];
                        
                        NSArray *therow = allTheData[i];
                        
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            if (!error)
                            { //Serial number already exists in the database, so update the entry.
                        
                                for(int j=0; j < numOfColumns; j++) //go through rows
                                {
                                    if(j != serialColIndex) //ignore serial number for update
                                    {
                                        //if the column is a boolean, cast the string to boolean
                        
                                        if([columnNames[j] isEqualToString:@"admin_access"] || [columnNames[j] isEqualToString:@"teacher_access"] || [columnNames[j] isEqualToString:@"student_access"] || [columnNames[j] isEqualToString:@"instructional_access"])
                                        {
                            
                                            BOOL thething = [therow[j] boolValue];
                                            NSNumber *number = [NSNumber numberWithBool:thething];
                                            object[columnNames[j]] = number;
                                        }
                                        else
                                        {
                                            object[columnNames[j]] = therow[j];
                                        }
                                    }
                                }
                                
                                [object saveInBackground];
                            }
                            else if ([error code] == kPFErrorConnectionFailed)
                            {
                                // couldn't connect to parse
                                NSLog(@"Uh oh, we couldn't even connect to the Parse Cloud!");
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Connect!" message:@"We couldn't connect to Parse. Make sure you have internet access or cell service." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                [alert show];
                                
                                return;
                            }
                            else
                            {
                                //Serial number does not exist in the Parse database. Add new entry to parse table.
                                
                                NSLog(@"Serial number not found %@.\n", serialnumber);
                                
                                PFObject *object = [PFObject objectWithClassName:@"DeviceInventory"];
                                
                                for(int j=0; j < numOfColumns; j++) //go through rows
                                {
                                    
                                    //if the column is a boolean, cast the string to boolean
                                        
                                    if([columnNames[j] isEqualToString:@"admin_access"] || [columnNames[j] isEqualToString:@"teacher_access"] || [columnNames[j] isEqualToString:@"student_access"] || [columnNames[j] isEqualToString:@"instructional_access"])
                                    {
                                        
                                        BOOL thething = [therow[j] boolValue];
                                        NSNumber *number = [NSNumber numberWithBool:thething];
                                        object[columnNames[j]] = number;
                                    }
                                    else
                                    {
                                        object[columnNames[j]] = therow[j];
                                    }
                                    
                                }
                                
                                [object saveInBackground];
                            }
                            
                        }];
                        
                        //deviceInfo[@"serial_number"] = therow[0];
                        
                    }
                
                    //The import has been completed! Now let's inform the user of this.
                
                    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Success!"
                                                                message:@"The data was imported successfully."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                    [alert show];
                
            }
            else if(problemExists == YES)//there is a problem present!
            {
                //Alert the user that either serial numbers or rooms were left blank in some rows
                //and specify in which rows
                
                NSString *message1 = @"The following rows in the file have either empty serial numbers or empty room values: ";
                NSString *theproblemrows = [[problemRows valueForKey:@"description"] componentsJoinedByString:@","];
                
                NSString *themessage = [NSString stringWithFormat:@"%@%@", message1, theproblemrows];
                
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                 message:themessage
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                [alert show];
            }
            else if(([repeatedSerials count] > 0))
            {
                //Alert the user that some serial numbers were repeated within the csv
                
                NSString *message1 = @"The following rows in the file contain repeated serial numbers within the file: ";
                NSString *therepeatedrows = [[repeatedSerials valueForKey:@"description"] componentsJoinedByString:@","];
                
                NSString *themessage = [NSString stringWithFormat:@"%@%@", message1, therepeatedrows];
                
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
