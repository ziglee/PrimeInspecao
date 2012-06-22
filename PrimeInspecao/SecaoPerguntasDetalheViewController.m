//
//  SecaoPerguntasDetalheViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecaoPerguntasDetalheViewController.h"
#import "PerguntaDetalheViewController.h"
#import "Pergunta.h"

@interface SecaoPerguntasDetalheViewController ()
- (void)configureView;
@end

@implementation SecaoPerguntasDetalheViewController

@synthesize detailItem = _detailItem;
@synthesize perguntas = _perguntas;
@synthesize tituloTextField = _tituloTextField;
@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton, self.editButtonItem, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posicao" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	
	NSMutableArray *sortedPerguntas = [[NSMutableArray alloc] initWithArray:[self.detailItem.perguntas allObjects]];
	[sortedPerguntas sortUsingDescriptors:sortDescriptors];
	self.perguntas = sortedPerguntas;
    
    [self.tableView reloadData]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detailItem.perguntas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Perguntas";
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pergunta *selectedObject = [self.perguntas objectAtIndex:indexPath.row];
    
    PerguntaDetalheViewController *detalheObra = [self.storyboard instantiateViewControllerWithIdentifier:@"PerguntaDetalhe"];
    detalheObra.managedObjectContext = self.managedObjectContext;
    detalheObra.pergunta = selectedObject;
    detalheObra.secaoPerguntas = self.detailItem;    
    [self.navigationController pushViewController:detalheObra animated:YES];
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {    
    [super setEditing:editing animated:animated];
    self.tituloTextField.enabled = editing;
    [self.navigationItem setHidesBackButton:editing animated:YES];
	
	if (!editing) {
		NSManagedObjectContext *context = self.managedObjectContext;
		NSError *error = nil;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (textField == self.tituloTextField) {
		self.detailItem.titulo = self.tituloTextField.text;
		self.navigationItem.title = self.detailItem.titulo;
	}
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)configureView
{
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem.titulo;
        self.tituloTextField.text = self.detailItem.titulo;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Pergunta *pergunta = [self.perguntas objectAtIndex:indexPath.row];
    cell.textLabel.text = pergunta.titulo;
}

- (void)insertNewObject
{
    PerguntaDetalheViewController *detalheObra = [self.storyboard instantiateViewControllerWithIdentifier:@"PerguntaDetalhe"];
    detalheObra.managedObjectContext = self.managedObjectContext;
    detalheObra.secaoPerguntas = self.detailItem;    
    [self.navigationController pushViewController:detalheObra animated:YES];
}

@end
