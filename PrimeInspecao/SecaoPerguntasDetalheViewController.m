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

@synthesize secaoPerguntas = _secaoPerguntas;
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

- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)configureView
{
    if (self.secaoPerguntas) {
        self.navigationItem.title = self.secaoPerguntas.titulo;
        self.tituloTextField.text = self.secaoPerguntas.titulo;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.secaoPerguntas.perguntas count];
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
        [self.managedObjectContext deleteObject:[self.secaoPerguntas.perguntas objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }  
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSUInteger fromIndex = fromIndexPath.row;
    NSUInteger toIndex = toIndexPath.row;
    
    if (fromIndex == toIndex) {
        return;
    }
    
    Pergunta *affectedObject = [self.secaoPerguntas.perguntas objectAtIndex:fromIndex];
    
    NSMutableOrderedSet *perguntas = [self.secaoPerguntas mutableOrderedSetValueForKey:@"perguntas"];
    
    [perguntas removeObjectAtIndex:fromIndex];
    [perguntas insertObject:affectedObject atIndex:toIndex];
    
    self.secaoPerguntas.perguntas = perguntas;
    
    NSError *error = nil;
    if ([self.managedObjectContext save:&error]){
        NSLog(@"Successfully saved the context for reorder");
    } else {
        NSLog(@"Failed to save the context. Error = %@", error);
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pergunta *selectedObject = [self.secaoPerguntas.perguntas objectAtIndex:indexPath.row];

    PerguntaDetalheViewController *detalheObra = [self.storyboard instantiateViewControllerWithIdentifier:@"PerguntaDetalhe"];
    detalheObra.managedObjectContext = self.managedObjectContext;
    detalheObra.pergunta = selectedObject;
    detalheObra.secaoPerguntas = self.secaoPerguntas;
    [self.navigationController pushViewController:detalheObra animated:YES];
}

#pragma mark - Editing

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
		self.secaoPerguntas.titulo = self.tituloTextField.text;
		self.navigationItem.title = self.secaoPerguntas.titulo;
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Pergunta *pergunta = [self.secaoPerguntas.perguntas objectAtIndex:indexPath.row];
    cell.textLabel.text = pergunta.titulo;
}

- (void)insertNewObject
{
    PerguntaDetalheViewController *detalheObra = [self.storyboard instantiateViewControllerWithIdentifier:@"PerguntaDetalhe"];
    detalheObra.managedObjectContext = self.managedObjectContext;
    detalheObra.secaoPerguntas = self.secaoPerguntas;    
    [self.navigationController pushViewController:detalheObra animated:YES];
}

@end
