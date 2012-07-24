//
//  UIImagePickerViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AssetsLibrary/AssetsLibrary.h"
#import "UIImagePickerViewController.h"

@interface UIImagePickerViewController ()

@end

@implementation UIImagePickerViewController

@synthesize imageView;
@synthesize legendaField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	    
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)];
    
    [[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    //UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    //self.imageView.image = img;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)takePicture:(id) sender 
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imageView setImage:image];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)savePhoto:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    UIImage *image = imageView.image; // imageView is my image from camera
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO]; 
    
    //UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil , nil);
}

- (IBAction)discardPhoto:(id)sender {
}

@end
