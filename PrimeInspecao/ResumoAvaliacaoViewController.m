//
//  ResumoAvaliacaoViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResumoAvaliacaoViewController.h"
#import "AvaliacaoTableViewController.h"
#import "SecaoPerguntas.h"
#import "ResumoSecaoPerguntasCell.h"

@interface ResumoAvaliacaoViewController ()
    - (void)configureCell:(ResumoSecaoPerguntasCell *)cell atIndexPath:(NSIndexPath *)indexPath;
    - (void)configureView;
@end

@implementation ResumoAvaliacaoViewController

@synthesize dateFormatter;
@synthesize avaliacao = _avaliacao;
@synthesize avaliacaoAnterior = _avaliacaoAnterior;
@synthesize nomeLabel = _nomeLabel;
@synthesize dataLabel = _dataLabel;
@synthesize engenheiroLabel = _engenheiroLabel;
@synthesize supervisorLabel = _supervisorLabel;
@synthesize gerenteLabel = _gerenteLabel;
@synthesize numeroLabel = _numeroLabel;
@synthesize notaGeralLabel = _notaGeralLabel;
@synthesize rateView = _rateView;
@synthesize situacaoImage = _situacaoImage;
@synthesize sinalizacaoImage = _sinalizacaoImage;
@synthesize comentCriticosTextView = _comentCriticosTextView;
@synthesize comentMelhorarTextView = _comentMelhorarTextView;
@synthesize comentPositivosTextView = _comentPositivosTextView;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

#pragma mark - Managing the detail item

- (void)configureView
{
    if (self.avaliacao) {
        self.nomeLabel.text = self.avaliacao.obra.nome;
        self.engenheiroLabel.text = self.avaliacao.obra.engenheiro;
        self.supervisorLabel.text = self.avaliacao.obra.supervisor;
        self.gerenteLabel.text = self.avaliacao.obra.gerente;
        self.numeroLabel.text = self.avaliacao.numero;
        self.dataLabel.text = [self.dateFormatter stringFromDate:self.avaliacao.data];
        self.comentCriticosTextView.text = self.avaliacao.comentCriticos;
        self.comentMelhorarTextView.text = self.avaliacao.comentMelhorar;
        self.comentPositivosTextView.text = self.avaliacao.comentPositivos;
        self.notaGeralLabel.text = [NSString stringWithFormat:@"%1.0f%%", self.avaliacao.notaGeral.doubleValue * 20];
        self.rateView.notSelectedImage = [UIImage imageNamed:@"rate_star_off_yellow.png"];
        self.rateView.halfSelectedImage = [UIImage imageNamed:@"rate_star_half_yellow.png"];
        self.rateView.fullSelectedImage = [UIImage imageNamed:@"rate_star_on_yellow.png"];
        self.rateView.maxRating = 5;
        self.rateView.rating = self.avaliacao.notaGeral.doubleValue;
        
        UIImage *sinalizacaoImage = [UIImage imageNamed:@"circle_green.png"];
        if (self.avaliacao.notaGeral.doubleValue * 20 < 50) {
            sinalizacaoImage = [UIImage imageNamed:@"circle_red.png"];
        } else if (self.avaliacao.notaGeral.doubleValue * 20 < 75) {
            sinalizacaoImage = [UIImage imageNamed:@"circle_yellow.png"];
        }
        self.sinalizacaoImage.image = sinalizacaoImage;
        
        if (self.avaliacaoAnterior) {
            if (self.avaliacao.notaGeral.doubleValue > self.avaliacaoAnterior.notaGeral.doubleValue) {
                self.situacaoImage.image = [UIImage imageNamed:@"arrow_up_green.png"];
            } else if (self.avaliacao.notaGeral.doubleValue < self.avaliacaoAnterior.notaGeral.doubleValue) {
                self.situacaoImage.image = [UIImage imageNamed:@"arrow_down_red.png"];
            } else {
                self.situacaoImage.image = [UIImage imageNamed:@"arrow_right_gray.png"];  
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAvaliacao)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:editButton, nil];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Avaliacao" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"data" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];    
    [fetchRequest setSortDescriptors:sortDescriptors]; 
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"obra == %@ and data < %@", self.avaliacao.obra, self.avaliacao.data];
    [fetchRequest setPredicate:predicate];
    
    NSArray *avaliacoes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];    
    if (avaliacoes != nil && avaliacoes.count > 0) {
        self.avaliacaoAnterior = [avaliacoes objectAtIndex:0];       
    }
}

- (void)viewWillAppear:(BOOL)animated
{    
    [self configureView];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
    static NSString *CellIdentifier = @"SecaoCell";
    ResumoSecaoPerguntasCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ResumoSecaoPerguntasCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SecaoPerguntas *secao = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.tituloLabel.text = secao.titulo;
    cell.rateView.notSelectedImage = [UIImage imageNamed:@"rate_star_off_yellow.png"];
    cell.rateView.halfSelectedImage = [UIImage imageNamed:@"rate_star_half_yellow.png"];
    cell.rateView.fullSelectedImage = [UIImage imageNamed:@"rate_star_on_yellow.png"];
    cell.rateView.maxRating = 5;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pergunta.secao == %@ and avaliacao == %@", secao, self.avaliacao];
    [fetchRequest setPredicate:predicate];
    
    NSArray *respostas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    int respostasCount = 0;
    int respostasSum = 0;
    
    for (Resposta *resposta in respostas) {
        if (resposta.valor.intValue >= 0) {
            respostasSum += resposta.valor.intValue;
            respostasCount++;
        }
    }
    
    UIImage *sinalizacaoImage = [UIImage imageNamed:@"circle_red.png"];
    
    if (respostasCount > 0) {
        cell.rateView.rating = (float) respostasSum / respostasCount;
        cell.porcentagemLabel.text = [NSString stringWithFormat:@"%1.0f%%", cell.rateView.rating * 20];
        if (cell.rateView.rating * 20 < 50) {
            sinalizacaoImage = [UIImage imageNamed:@"circle_red.png"];
        } else if (cell.rateView.rating * 20 < 75) {
            sinalizacaoImage = [UIImage imageNamed:@"circle_yellow.png"];
        } else {
            sinalizacaoImage = [UIImage imageNamed:@"circle_green.png"];
        }
    } else {
        cell.rateView.rating = 0;
        cell.porcentagemLabel.text = @"0%";
    }
    cell.sinalizacaoImage.image = sinalizacaoImage;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];    
    [fetchRequest setFetchBatchSize:20];
    
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

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
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

#pragma mark - Action Bar

- (void)editAvaliacao
{
    AvaliacaoTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Avaliacao"];
    controller.managedObjectContext = self.managedObjectContext;
    controller.avaliacao = self.avaliacao;
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
