//
//  AddUpdateViewController.h
//  PowellCountyInventory
//
//  Created by Charles Riley on 3/29/15.
//  Copyright (c) 2015 Charles Riley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddUpdateViewController : UIViewController
-(void)setFields:(PFObject *)object;
@end
