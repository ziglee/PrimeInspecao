//
//  PrimeInspecaoDetailViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObraDetalheViewController.h"

@interface ObraDetalheViewController ()
    - (void)configureView;
@end

@implementation ObraDetalheViewController

@synthesize detailItem = _detailItem;
@synthesize nomeTextField = _nomeTextField;
@synthesize engenheiroTextField = _engenheiroTextField;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;        
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        self.nomeTextField.text = self.detailItem.nome;
        self.engenheiroTextField.text = self.detailItem.engenheiro;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
                                       
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Salvar" style:UIBarButtonItemStyleDone target:self action:@selector(saveButton)];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemTrash target:self action:@selector(deletelButton)];
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style: UIBarButtonItemStyleBordered target:self action:@selector(cancelButton)];
        
    NSArray *barButtonItems = [[NSArray alloc] initWithObjects:deleteButton, spaceButton, cancelButton, spaceButton, saveButton, nil];
    [self setToolbarItems:barButtonItems];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)deletelButton
{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle: @"Exclusão" message: @"Você realmente deseja excluir a obra?" delegate: self cancelButtonTitle: @"Sim"  otherButtonTitles:@"Não",nil];
    [deleteAlert show];    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self.managedObjectContext deleteObject:self.detailItem];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }  
    }
    
}

- (void)cancelButton
{
    [self.managedObjectContext rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButton
{
    self.detailItem.nome = self.nomeTextField.text;
    self.detailItem.engenheiro = self.engenheiroTextField.text;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sucesso" message:@"Obra salva com sucesso" delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
