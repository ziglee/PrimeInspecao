//
//  PrimeInspecaoDetailViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrimeInspecaoDetailViewController.h"

@interface PrimeInspecaoDetailViewController ()
    - (void)configureView;
@end

@implementation PrimeInspecaoDetailViewController

@synthesize detailItem = _detailItem;
@synthesize nomeTextField = _nomeTextField;
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
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.leftBarButtonItem = addButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButton)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)insertNewObject
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    self.detailItem = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    self.nomeTextField.text = @"";
}

- (void)saveButton
{
    NSManagedObjectContext *context = self.managedObjectContext;
    [self.detailItem setValue:self.nomeTextField.text forKey:@"nome"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
