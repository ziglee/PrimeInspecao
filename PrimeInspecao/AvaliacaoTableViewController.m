//
//  AvaliacaoTableViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AvaliacaoTableViewController.h"
#import "Pergunta.h"
#import "SecaoPerguntas.h"
#import "PerguntaRespostaCell.h"

@interface AvaliacaoTableViewController ()
- (void)configureView;
@end

@implementation AvaliacaoTableViewController

@synthesize obra = _obra;
@synthesize avaliacao = _avaliacao;
@synthesize nomeLabel = _nomeLabel;
@synthesize secoesPerguntas = _secoesPerguntas;
@synthesize comentCriticosTextView = _comentCriticosTextView;
@synthesize comentMelhorarTextView = _comentMelhorarTextView;
@synthesize comentPositivosTextView = _comentPositivosTextView;
@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - Managing the detail item


- (void)configureView
{
    if (self.obra) {
        self.nomeLabel.text = self.obra.nome;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posicao" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.secoesPerguntas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.secoesPerguntas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SecaoPerguntas *secaoPerguntas = [self.secoesPerguntas objectAtIndex:section];
    return [secaoPerguntas.perguntas count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SecaoPerguntas *secaoPerguntas = [self.secoesPerguntas objectAtIndex:section];
    return secaoPerguntas.titulo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PerguntaRespostaCell";
    PerguntaRespostaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    SecaoPerguntas *secaoPerguntas = [self.secoesPerguntas objectAtIndex:indexPath.section];
    NSArray *sortedPerguntas = [[NSArray alloc] initWithArray:[secaoPerguntas.perguntas allObjects]];
    Pergunta *pergunta = [sortedPerguntas objectAtIndex:indexPath.row];
    [cell setPergunta:pergunta];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)save
{
    if (!self.avaliacao) 
    {
        self.avaliacao = [NSEntityDescription insertNewObjectForEntityForName:@"Avaliacao" inManagedObjectContext:self.managedObjectContext];
        self.avaliacao.data = [[NSDate alloc] init];
    }
    
    self.avaliacao.comentCriticos = self.comentCriticosTextView.text;
    self.avaliacao.comentMelhorar = self.comentMelhorarTextView.text;
    self.avaliacao.comentPositivos = self.comentPositivosTextView.text;
    
    NSError *error = nil;
	if (![self.managedObjectContext save:&error]) 
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - PerguntaRepostaCell Delegate

- (void) onRespostaButtonClicked:(id)sender cell:(PerguntaRespostaCell *)cell;
{
    //NSIndexPath *cellPath = [self.tableView indexPathForCell:cell];
    NSLog(@"Pergunta: [%@], Resposta: [%d]", cell.perguntaObj.titulo, cell.segmentedControl.selectedSegmentIndex);
}

@end
