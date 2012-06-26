//
//  AvaliacaoTableViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AvaliacaoTableViewController.h"
#import "Pergunta.h"
#import "Resposta.h"
#import "SecaoPerguntas.h"
#import "PerguntaRespostaCell.h"

@interface AvaliacaoTableViewController ()
- (void)configureView;
@end

@implementation AvaliacaoTableViewController

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
    if (self.avaliacao) {
        self.nomeLabel.text = self.avaliacao.obra.nome;
        self.comentCriticosTextView.text = self.avaliacao.comentCriticos;
        self.comentMelhorarTextView.text = self.avaliacao.comentMelhorar;
        self.comentPositivosTextView.text = self.avaliacao.comentPositivos;
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pergunta == %@ and avaliacao == %@", pergunta, self.avaliacao];
    [fetchRequest setPredicate:predicate];
    
    NSArray *respostas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([respostas count] > 0)
    {
        Resposta *resposta = [respostas objectAtIndex:0];
        [cell setResposta:resposta];
    }
    
    return cell;
}

# pragma mark - PerguntaRepostaCell Delegate

- (void) onRespostaButtonClicked:(id)sender cell:(PerguntaRespostaCell *)cell;
{
    Resposta *resposta = cell.respostaObj;
    if (resposta == nil)
    {
        resposta = [NSEntityDescription insertNewObjectForEntityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
    }
    
    resposta.avaliacao = self.avaliacao;
    resposta.pergunta = cell.perguntaObj;
    resposta.valor = [NSNumber numberWithInt:cell.segmentedControl.selectedSegmentIndex];
    
    [cell setResposta:resposta];
    
    NSError *error = nil;
	if (![self.managedObjectContext save:&error]) 
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

- (void)save
{
    self.avaliacao.comentCriticos = self.comentCriticosTextView.text;
    self.avaliacao.comentMelhorar = self.comentMelhorarTextView.text;
    self.avaliacao.comentPositivos = self.comentPositivosTextView.text;
    
    NSError *error = nil;
	if (![self.managedObjectContext save:&error]) 
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

@end