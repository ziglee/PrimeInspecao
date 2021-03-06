//
//  UIImagePickerViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecaoPerguntas.h"
#import "Foto.h"
#import "Avaliacao.h"
#import "Obra.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "UIImagePickerViewController.h"
#import "NSData+CITBase64.h"

@interface UIImagePickerViewController ()
@property (strong, nonatomic) NSArray *secoes;
@end

@implementation UIImagePickerViewController

@synthesize secoes;
@synthesize foto;
@synthesize imageView;
@synthesize legendaField;
@synthesize secaoPickerView;
@synthesize avaliacao = _avaliacao;
@synthesize popVC = _popVC;
@synthesize managedObjectContext = __managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
	    
    self.navigationItem.title = [NSString stringWithFormat:@"Tirar Foto - %@", self.avaliacao.obra.nome];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posicao" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.secoes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if (foto != nil) {
        [self.imageView setImage:foto.image];
        self.legendaField.text = foto.legenda;
        [secaoPickerView selectRow:[self.secoes indexOfObject:self.foto.secao] inComponent:0 animated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

#pragma mark Actions

- (IBAction)takePicture:(id) sender 
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (IBAction)pickAlbum:(UIButton*)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setDelegate:self];
        
        self.popVC = [[UIPopoverController alloc]
                                       initWithContentViewController: imagePicker];
        self.popVC.delegate = self;
        [self.popVC setPopoverContentSize:CGSizeMake(500, 500)];
        
        CGSize size = CGSizeMake(100, 100);
        [self.popVC presentPopoverFromRect: CGRectMake(sender.center.x, sender.center.y, size.width, size.height)
                               inView:self.view
             permittedArrowDirections:UIPopoverArrowDirectionAny
                             animated:YES];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [imagePicker setDelegate:self];
        
        [self presentModalViewController:imagePicker animated:YES];
    }
}

- (IBAction)savePhoto:(id)sender {
    if (foto == nil)
        foto = [NSEntityDescription insertNewObjectForEntityForName:@"Foto" inManagedObjectContext: self.managedObjectContext];
    
    if (imageView.image != nil) {
        foto.legenda = self.legendaField.text;
        foto.avaliacao = self.avaliacao;
        foto.image = imageView.image;
        
        NSInteger row = [secaoPickerView selectedRowInComponent:0];
        foto.secao = [secoes objectAtIndex:row];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma mark UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [secoes count];
}

#pragma mark UIPickerView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SecaoPerguntas *secao = [secoes objectAtIndex:row];
    return secao.titulo;
}

@end
