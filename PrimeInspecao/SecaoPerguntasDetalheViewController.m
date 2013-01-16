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
@synthesize fetchedResultsController = __fetchedResultsController;
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
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
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
    
    Pergunta *affectedObject = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromIndex];
    affectedObject.posicao = [NSNumber numberWithInteger:toIndex];
    
    NSUInteger start, end;
    int delta;
    
    if (fromIndex < toIndex) {
        // move was down, need to shift up
        delta = -1;
        start = fromIndex + 1;
        end = toIndex;
    } else { // fromIndex > toIndex
        // move was up, need to shift down
        delta = 1;
        start = toIndex;
        end = fromIndex - 1;
    }
    
    for (NSUInteger i = start; i <= end; i++) {
        Pergunta *otherObject = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];
        otherObject.posicao = [NSNumber numberWithInteger:delta + otherObject.posicao.intValue];
    }
    
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pergunta *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];

    PerguntaDetalheViewController *detalheObra = [self.storyboard instantiateViewControllerWithIdentifier:@"PerguntaDetalhe"];
    detalheObra.managedObjectContext = self.managedObjectContext;
    detalheObra.pergunta = selectedObject;
    detalheObra.secaoPerguntas = self.secaoPerguntas;
    [self.navigationController pushViewController:detalheObra animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Pergunta *pergunta = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = pergunta.titulo;
    cell.detailTextLabel.text = (pergunta.tipoSimNao.boolValue ? @"Sim/Não" : @"Gradual");
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pergunta" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"secao == %@", self.secaoPerguntas];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posicao" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)insertNewObject
{
    PerguntaDetalheViewController *detalheObra = [self.storyboard instantiateViewControllerWithIdentifier:@"PerguntaDetalhe"];
    detalheObra.managedObjectContext = self.managedObjectContext;
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

@end
