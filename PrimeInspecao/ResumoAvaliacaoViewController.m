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
#import "Foto.h"
#import "ResumoSecaoPerguntasCell.h"
#import "FotosTableViewController.h"
#import "NSData+CITBase64.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"

@interface ResumoAvaliacaoViewController ()
- (void)configureCell:(ResumoSecaoPerguntasCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureView;
- (float) nota: (SecaoPerguntas *)secao avaliacaoAnterior:(Avaliacao *) avaliacao;
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
    
    UIBarButtonItem *exportarButton = [[UIBarButtonItem alloc] initWithTitle:@"Exportar" style:UIBarButtonItemStyleBordered target:self action:@selector(generatePdfButtonPressed:)];
    
    UIBarButtonItem *fotosButton = [[UIBarButtonItem alloc] initWithTitle:@"Fotos" style:UIBarButtonItemStyleBordered target:self action:@selector(fotosList)];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAvaliacao)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: editButton, fotosButton, exportarButton, nil];
    
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
    
    self.navigationItem.title = @"Resumo da avaliação";
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
    
    UIImage *sinalizacaoImage = [UIImage imageNamed:@"circle_yellow.png"];
    
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
        cell.porcentagemLabel.text = @"N.A.";
    }
    cell.sinalizacaoImage.image = sinalizacaoImage;
    
    cell.situacaoImage.image = [UIImage imageNamed:@"arrow_right_gray.png"];
    
    if (self.avaliacaoAnterior) {
        double notaAnterior = [self nota:secao avaliacaoAnterior:self.avaliacaoAnterior];        
        if (cell.rateView.rating > notaAnterior) {
            cell.situacaoImage.image = [UIImage imageNamed:@"arrow_up_green.png"];
        } else if (cell.rateView.rating < notaAnterior) {
            cell.situacaoImage.image = [UIImage imageNamed:@"arrow_down_red.png"];
        } else {
            cell.situacaoImage.image = [UIImage imageNamed:@"arrow_right_gray.png"];
        }
    }
}

- (float) nota: (SecaoPerguntas *)secao avaliacaoAnterior:(Avaliacao *) avaliacao { 
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pergunta.secao == %@ and avaliacao == %@", secao, avaliacao];
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
    
    if (respostas == 0)
        return 0;
    
    return (float) respostasSum / respostasCount;
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

- (void)fotosList
{
    FotosTableViewController *fotos = [self.storyboard instantiateViewControllerWithIdentifier:@"FotosList"];
    fotos.managedObjectContext = self.managedObjectContext;
    fotos.avaliacao = self.avaliacao;
    [self.navigationController pushViewController:fotos animated:YES];
}

- (void)generatePdfButtonPressed:(id)sender
{
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.avaliacao.obra.nome, @"obra", nil];
    
    if (self.avaliacao.obra.engenheiro)
        [data setObject: self.avaliacao.obra.engenheiro forKey: @"engenheiro"];    
    if (self.avaliacao.obra.supervisor)
        [data setObject: self.avaliacao.obra.supervisor forKey: @"supervisor"];
    if (self.avaliacao.obra.gerente)
        [data setObject: self.avaliacao.obra.gerente forKey: @"gerente"];
    if (self.avaliacao.comentCriticos)
        [data setObject: self.avaliacao.comentCriticos forKey: @"ptscriticos"];
    if (self.avaliacao.comentMelhorar)
        [data setObject: self.avaliacao.comentMelhorar forKey: @"ptsamelhorar"];
    if (self.avaliacao.comentPositivos)
        [data setObject: self.avaliacao.comentPositivos forKey: @"ptspositivos"];
    if (self.avaliacao.data)
        [data setObject: [self.dateFormatter stringFromDate:self.avaliacao.data] forKey: @"data"];
    if (self.avaliacao.numero)
        [data setObject: self.avaliacao.numero forKey: @"numero"];
    if (self.avaliacao.notaGeral)
        [data setObject: [NSString stringWithFormat:@"%1.0f%%", self.avaliacao.notaGeral.doubleValue * 20] forKey: @"nota"];
    
    NSMutableArray* secoesData = [NSMutableArray arrayWithCapacity:1];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *secoes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (SecaoPerguntas *secao in secoes) {
        NSMutableDictionary* secaoData = [NSMutableDictionary dictionaryWithObjectsAndKeys: secao.titulo, @"snome", secao.titulo.uppercaseString, @"snomeupper", nil];
        NSMutableArray* respostasData = [NSMutableArray arrayWithCapacity:1];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pergunta.secao == %@ and avaliacao == %@", secao, self.avaliacao];
        [fetchRequest setPredicate:predicate];
        
        NSArray *respostas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        int respostasCount = 0;
        int respostasSum = 0;
        
        for (Resposta *resposta in respostas) {
            NSMutableDictionary* respostaData = [NSMutableDictionary dictionaryWithObjectsAndKeys: resposta.pergunta.titulo, @"rtitulo", resposta.valor, @"rvalor", resposta.pergunta.tipoSimNao, @"rtipoSimNao", resposta.implementado, @"rimplementado", resposta.requerido, @"rrequerido", nil];
            
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar1"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar2"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar3"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar4"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar5"];
            
            if (resposta.pergunta.tipoSimNao.intValue == 1) {
                if (resposta.implementado.intValue == 1) {
                    [respostaData setObject: @"[userImage:accepted.png]" forKey: @"rimplementado"];
                } else {
                    [respostaData setObject: @"[userImage:cancel.png]" forKey: @"rimplementado"];
                }
                
                if (resposta.requerido.intValue == 1) {
                    [respostaData setObject: @"[userImage:accepted.png]" forKey: @"rrequerido"];
                } else {
                    [respostaData setObject: @"[userImage:cancel.png]" forKey: @"rrequerido"];
                }
            }
            
            if (resposta.valor.intValue >= 1) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar1"];
            }
            if (resposta.valor.intValue >= 2) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar2"];
            }
            if (resposta.valor.intValue >= 3) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar3"];
            }
            if (resposta.valor.intValue >= 4) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar4"];
            }
            if (resposta.valor.intValue >= 5) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar5"];
            }
            
            [respostasData addObject:respostaData];
            
            if (resposta.valor.intValue >= 0) {
                respostasSum += resposta.valor.intValue;
                respostasCount++;
            }
        }
        
        float rating = 0;
        
        [secaoData setObject: respostasData forKey: @"respostas"];
        [secaoData setObject: @"N.A." forKey: @"snota"];
        [secaoData setObject: @"[userImage:circle_yellow.png]" forKey: @"ssinal"];
        [secaoData setObject: @"[userImage:arrow_right_gray.png]" forKey: @"ssituacao"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar1"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar2"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar3"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar4"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar5"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star1"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star2"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star3"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star4"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star5"];
        
        if (respostasCount > 0) {
            rating = (float) respostasSum / respostasCount;
            [secaoData setObject: [NSString stringWithFormat:@"%1.0f%%", rating * 20] forKey: @"snota"];
            if (rating * 20 < 50) {
                [secaoData setObject: @"[userImage:circle_red.png]" forKey: @"ssinal"];
                [secaoData setObject: @"[userImage:circle_red.png]" forKey: @"s2sinal"];
            } else if (rating * 20 < 75) {
                [secaoData setObject: @"[userImage:circle_yellow.png]" forKey: @"ssinal"];
                [secaoData setObject: @"[userImage:circle_yellow.png]" forKey: @"s2sinal"];
            } else {
                [secaoData setObject: @"[userImage:circle_green.png]" forKey: @"ssinal"];
                [secaoData setObject: @"[userImage:circle_green.png]" forKey: @"s2sinal"];
            }
            
            if (rating >= 1) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar1"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star1"];
            } else if (rating >= 0.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar1"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star1"];
            }
            
            if (rating >= 2) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar2"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star2"];
            } else if (rating >= 1.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar2"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star2"];
            }
            
            if (rating >= 3) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar3"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star3"];
            } else if (rating >= 2.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar3"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star3"];
            }
            
            if (rating >= 4) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar4"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star4"];
            } else if (rating >= 3.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar4"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star4"];
            }
            
            if (rating >= 5) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar5"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star5"];
            } else if (rating >= 4.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar5"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star5"];
            }
        }
        
        if (self.avaliacaoAnterior) {
            double notaAnterior = [self nota:secao avaliacaoAnterior:self.avaliacaoAnterior];        
            if (rating > notaAnterior) {
                [secaoData setObject: @"[userImage:arrow_up_green.png]" forKey: @"ssituacao"];
            } else if (rating < notaAnterior) {
                [secaoData setObject: @"[userImage:arrow_down_red.png]" forKey: @"ssituacao"];
            } else {
                [secaoData setObject: @"[userImage:arrow_right_gray.png]" forKey: @"ssituacao"];
            }
        }
        
        NSMutableArray* fotosData = [NSMutableArray arrayWithCapacity:1];
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"Foto" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        predicate = [NSPredicate predicateWithFormat:@"avaliacao == %@ and secao == %@", self.avaliacao, secao];
        [fetchRequest setPredicate:predicate];
        NSArray *fotos = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        for (Foto *foto in fotos) {
            UIImage *image = [foto.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(300, 440) interpolationQuality:kCGInterpolationMedium];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
            NSString *encodedString = [imageData stringInBase64FromData];
            NSMutableArray* row = [NSMutableDictionary dictionaryWithObjectsAndKeys: foto.legenda, @"flegenda", [@"image:base64:" stringByAppendingString:encodedString], @"fimage", nil];
            [fotosData addObject: row];    
        }
        [secaoData setObject: fotosData forKey: @"fotos"];

        
        [secoesData addObject: secaoData];    
    }
    [data setObject: secoesData forKey: @"secoes"];
        
    [data setObject: @"[userImage:circle_yellow.png]" forKey: @"sinal"];
    [data setObject: @"[userImage:arrow_right_gray.png]" forKey: @"situacao"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star1"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star2"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star3"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star4"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star5"];
    
    if (self.avaliacao.notaGeral.doubleValue * 20 < 50) {
        [data setObject: @"[userImage:circle_red.png]" forKey: @"sinal"];
    } else if (self.avaliacao.notaGeral.doubleValue * 20 < 75) {
        [data setObject: @"[userImage:circle_yellow.png]" forKey: @"sinal"];
    } else {
        [data setObject: @"[userImage:circle_green.png]" forKey: @"sinal"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 1) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star1"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 0.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star1"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 2) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star2"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 1.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star2"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 3) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star3"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 2.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star3"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 4) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star4"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 3.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star4"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 5) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star5"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 4.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star5"];
    }
    
    if (self.avaliacaoAnterior) {
        if (self.avaliacao.notaGeral.doubleValue > self.avaliacaoAnterior.notaGeral.doubleValue) {
            [data setObject: @"[userImage:arrow_up_green.png]" forKey: @"situacao"];
        } else if (self.avaliacao.notaGeral.doubleValue < self.avaliacaoAnterior.notaGeral.doubleValue) {
            [data setObject: @"[userImage:arrow_down_red.png]" forKey: @"situacao"];
        } else {
            [data setObject: @"[userImage:arrow_right_gray.png]" forKey: @"situacao"];
        }
    }
    
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"M2I4MzViZDItNzhhOS00MTMwLWFiOTEtMTc4ZjY1MjI5ZTM3OjI1MTUyMDU", @"accessKey", @"prime/template.odt", @"templateName", @"avaliacao.pdf", @"outputName", @"mailto:ziglee@gmail.com:pdf", @"storeTo", data, @"data", @"y", @"devMode", @"Prime avaliação", @"mailSubject", nil];
    
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonText = [[NSString alloc] initWithData:jsonData                                        encoding:NSUTF8StringEncoding];

    NSLog(@"Json: %@", jsonText);

    NSData* dataBody = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://dws.docmosis.com/services/rs/render"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dataBody];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        responseData = [NSMutableData data];
    } else {
        NSLog(@"Conexão nula");        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if (json != nil) {        
        NSLog(@"json: %@", json);
    } else {
        NSLog(@"error: %@", [error description]);
    }
}

@end
