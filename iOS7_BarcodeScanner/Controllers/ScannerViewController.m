//
//  ViewController.m
//  iOS7_BarcodeScanner
//
//  Created by Jake Widmer on 11/16/13.
//  Copyright (c) 2013 Jake Widmer. All rights reserved.
//

#import "ScannerViewController.h"
#import "SettingsViewController.h"
#import "Barcode.h"
#import "AddUpdateViewController.h"

@import AVFoundation;   // iOS7 only import style

@interface ScannerViewController ()

@property (strong, nonatomic) NSMutableArray * foundBarcodes;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@property (strong, nonatomic) SettingsViewController * settingsVC;

@end

@implementation ScannerViewController{
    /* Here’s a quick rundown of the instance variables (via 'iOS 7 By Tutorials'):
     
     1. _captureSession – AVCaptureSession is the core media handling class in AVFoundation. It talks to the hardware to retrieve, process, and output video. A capture session wires together inputs and outputs, and controls the format and resolution of the output frames.
     
     2. _videoDevice – AVCaptureDevice encapsulates the physical camera on a device. Modern iPhones have both front and rear cameras, while other devices may only have a single camera.
     
     3. _videoInput – To add an AVCaptureDevice to a session, wrap it in an AVCaptureDeviceInput. A capture session can have multiple inputs and multiple outputs.
     
     4. _previewLayer – AVCaptureVideoPreviewLayer provides a mechanism for displaying the current frames flowing through a capture session; it allows you to display the camera output in your UI.
     5. _running – This holds the state of the session; either the session is running or it’s not.
     6. _metadataOutput - AVCaptureMetadataOutput provides a callback to the application when metadata is detected in a video frame. AV Foundation supports two types of metadata: machine readable codes and face detection.
     7. _backgroundQueue - Used for showing alert using a separate thread.
     */
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
    
    // keep track of if UIAlert showing
    BOOL alertShowing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    alertShowing = false;
    
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    self.foundBarcodes = [[NSMutableArray alloc] init];
    
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
    [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue =
    dispatch_queue_create("com.1337labz.featurebuild.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes =
    _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}

#pragma mark - Button action functions
- (IBAction)settingsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"toSettings" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toSettings"]) {
        self.settingsVC = (SettingsViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SettingsViewController"];
        self.settingsVC = segue.destinationViewController;
        self.settingsVC.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"pushToAdd"]) {
        AddUpdateViewController *vc = [segue destinationViewController];
        [vc setFields:self.objectLastScanned];
    }
}


#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             
             for(NSString * str in self.allowedBarcodeTypes){
                if([barcode.getBarcodeType isEqualToString:str]){
                    [self validBarcodeFound:barcode];
                    return;
                }
            }
         }
     }];
}

- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    [self.foundBarcodes addObject:barcode];
    
    // Charles Riley
    if (!self->alertShowing) {
        self->alertShowing = true;
        PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
        [query whereKey:@"serial_number" equalTo:barcode.getBarcodeData];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                // barcode found
                NSLog(@"Found barcode %@.\n", barcode.getBarcodeData);
                NSDate *date = [NSDate date];
                object[@"lastScanned"] = date;
                //object[@"serial_number"] = barcode.getBarcodeData;
                [object saveInBackground];
                self.objectLastScanned = object;
                [self showBarcodeAlert:barcode barcodeFound:YES inRoom:object[@"room"]];
            } else {
                // barcode not found
                NSLog(@"Barcode not found %@.\n", barcode.getBarcodeData);
                //PFObject *object = [PFObject objectWithClassName:@"DeviceInventory"];
                //object[@"serial_number"] = barcode.getBarcodeData;
                //[object saveInBackground];
                self.objectLastScanned = [PFObject objectWithClassName:@"DeviceInventory"];
                NSDate *date = [NSDate date];
                self.objectLastScanned[@"serial_number"] = barcode.getBarcodeData;
                self.objectLastScanned[@"lastScanned"] = date;
                [self showBarcodeAlert:barcode barcodeFound:NO inRoom:nil];
            }
        }];
    }
    

    
/*
    //==The following code using parse was written by Maria Ramos==

    //Look for entry with barcode in theParse database and set found entry to true (@YES)
    
    PFQuery *query = [PFQuery queryWithClassName:@"DeviceInventory"];
    
    [query whereKey:@"serial_number" equalTo:barcode]; //if serial_number is unique, this should be enough
                                                        //otherwise, we need to add another constraint, like 'location'
    
    //this works if there is only one entry for this serial number (and possibly location)
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *deviceInfo, NSError *error) {
        if (!deviceInfo) {
            
            //did not find. want to add it? re-read?
            
        } else { //change to work with LastUpdated
            
            // The find succeeded. Make update to 'found' entry
            deviceInfo[@"found"] = @YES;
            [deviceInfo saveInBackground]; //can I use saveEventually here?
                
        }
    }];
 */
}
- (void) showBarcodeAlert:(Barcode *)barcode barcodeFound:(BOOL)found inRoom:(NSString *)room{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Code to do in background processing
        NSString * alertMessage = @"You scanned a barcode with type ";
        alertMessage = [alertMessage stringByAppendingString:[barcode getBarcodeType]];
        alertMessage = [alertMessage stringByAppendingString:@" and data "];
        alertMessage = [alertMessage stringByAppendingString:[barcode getBarcodeData]];
        //alertMessage = [alertMessage stringByAppendingString:@"\n\nBarcode added to array of "];
        //alertMessage = [alertMessage stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)[self.foundBarcodes count]-1]];
        //alertMessage = [alertMessage stringByAppendingString:@" previously found barcodes."];
        UIAlertView *message;
        if (found) {
            alertMessage = [alertMessage stringByAppendingString:@" and room "];
            alertMessage = [alertMessage stringByAppendingString:room];
            message = [[UIAlertView alloc] initWithTitle:@"Barcode Found!"
                                                              message:alertMessage
                                                             delegate:self
                                                    cancelButtonTitle:@"Update"
                                                    otherButtonTitles:@"Scan again",nil];

        } else {
            message = [[UIAlertView alloc] initWithTitle:@"Barcode Not Found!"
                                                              message:alertMessage
                                                             delegate:self
                                                    cancelButtonTitle:@"Add"
                                                    otherButtonTitles:@"Scan again",nil];

        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Code to update the UI/send notifications based on the results of the background processing
            [message show];

        });
    });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        // Code for Add/Update button
        self->alertShowing = false;
        [self performSegueWithIdentifier:@"pushToAdd" sender:self];
    }
    if(buttonIndex == 1){
        // Code for Scan more button
        self->alertShowing = false;
        [self startRunning];
    }
}

- (void) settingsChanged:(NSMutableArray *)allowedTypes{
    for(NSObject * obj in allowedTypes){
        NSLog(@"%@",obj);
    }
    if(allowedTypes){
        self.allowedBarcodeTypes = [NSMutableArray arrayWithArray:allowedTypes];
    }
}



@end


