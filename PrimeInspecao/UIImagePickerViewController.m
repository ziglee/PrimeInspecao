//
//  UIImagePickerViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Foto.h"
#import "Avaliacao.h"
#import "Obra.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "UIImagePickerViewController.h"

@interface UIImagePickerViewController ()

@end

@implementation UIImagePickerViewController

@synthesize imageView;
@synthesize legendaField;
@synthesize avaliacao = _avaliacao;
@synthesize managedObjectContext = __managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
	    
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)];
    
    [[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Tirar Foto - %@", self.avaliacao.obra.nome];
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    //UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    //self.imageView.image = img;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark Actions

- (void)takePicture:(id) sender 
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)savePhoto:(id)sender {    
    if (imageView.image != nil) {
        Foto *foto = [NSEntityDescription insertNewObjectForEntityForName:@"Foto" inManagedObjectContext: self.managedObjectContext];
        foto.legenda = self.legendaField.text;
        foto.avaliacao = self.avaliacao;
        foto.image = imageView.image;
    
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) 
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    //    UIImage *image = imageView.image; // imageView is my image from camera
    //    NSData *imageData = UIImagePNGRepresentation(image);
    //    [imageData writeToFile:savedImagePath atomically:NO]; 
    
    //UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil , nil);
}

- (IBAction)discardPhoto:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Image picker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    [self.imageView setImage:selectedImage];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
}

@end
