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
#import "SecaoPerguntasHeaderInfo.h"
#import "SecaoPerguntasHeaderView.h"
#import "UIImagePickerViewController.h"

@interface AvaliacaoTableViewController ()
    @property (nonatomic, strong) NSMutableArray* sectionInfoArray;
    - (void)configureView;
@end

#define HEADER_HEIGHT 45

@implementation AvaliacaoTableViewController

@synthesize dateFormatter;
@synthesize sectionInfoArray = sectionInfoArray_;
@synthesize fotoButton = _fotoButton;
@synthesize avaliacao = _avaliacao;
@synthesize nomeLabel = _nomeLabel;
@synthesize numeroField = _numeroField;
@synthesize dataLabel = _dataLabel;
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
        self.numeroField.text = self.avaliacao.numero;
        self.dataLabel.text = [self.dateFormatter stringFromDate:self.avaliacao.data];
        self.comentCriticosTextView.text = self.avaliacao.comentCriticos;
        self.comentMelhorarTextView.text = self.avaliacao.comentMelhorar;
        self.comentPositivosTextView.text = self.avaliacao.comentPositivos;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self configureView];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posicao" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.secoesPerguntas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (SecaoPerguntas *secaoPerguntas in self.secoesPerguntas) {
		SecaoPerguntasHeaderInfo *sectionInfo = [[SecaoPerguntasHeaderInfo alloc] init];
        sectionInfo.secaoPerguntas = secaoPerguntas;
        [infoArray addObject:sectionInfo];
    }
    self.sectionInfoArray = infoArray;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self save];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"tirarFoto"]) 
    {
        UIImagePickerViewController *destination = [segue destinationViewController];
        destination.managedObjectContext = self.managedObjectContext;
        destination.avaliacao = self.avaliacao;
    } 
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
    Pergunta *pergunta = [secaoPerguntas.perguntas objectAtIndex:indexPath.row];
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

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SecaoPerguntasHeaderView" owner:self options:nil];
    SecaoPerguntasHeaderInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    //if (!sectionInfo.headerView) {
        SecaoPerguntasHeaderView *tableHeaderView = nil;
        for (id currentObject in nib) {
            if ([currentObject isKindOfClass:[UIView class]]) {
                NSString *titulo = sectionInfo.secaoPerguntas.titulo;
                NSNumber *nota;
                
                int respostasCount = 0;
                int respostasSum = 0;
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pergunta.secao == %@ and avaliacao == %@", sectionInfo.secaoPerguntas, self.avaliacao];
                [fetchRequest setPredicate:predicate];
                
                NSArray *respostas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
                for (Resposta *resposta in respostas) 
                {
                    if (resposta.valor.intValue >= 0)
                    {
                        respostasSum += resposta.valor.intValue;
                        respostasCount++;
                    }
                }
                
                if (respostasCount > 0)
                {
                    double notaGeral = (double) respostasSum / respostasCount;
                    nota = [NSNumber numberWithDouble:notaGeral];
                } 
                else 
                {
                    nota = [NSNumber numberWithInt:0];
                }
                
                tableHeaderView = (SecaoPerguntasHeaderView *)currentObject;
                [tableHeaderView initWithTitle:titulo nota:nota];
                break;
            }
        }
		
        sectionInfo.headerView = tableHeaderView;    
    //}
    
    return sectionInfo.headerView;
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
    if (cell.perguntaObj.tipoSimNao.intValue == 0) {
        resposta.valor = [NSNumber numberWithInt:cell.segmentedControl.selectedSegmentIndex - 1];
    } else {
        if (cell.requiredSwitch.isOn) {
            resposta.valor = [NSNumber numberWithInt:cell.implementedSwitch.isOn ? 5 : 0];
        } else {
            resposta.valor = [NSNumber numberWithInt:cell.implementedSwitch.isOn ? 0 : -1];
        }
        resposta.requerido = [NSNumber numberWithInt: cell.requiredSwitch.isOn ? 1 : 0];
        resposta.implementado = [NSNumber numberWithInt: cell.implementedSwitch.isOn ? 1 : 0];
    }
    
    [cell setResposta:resposta];
    
    NSError *error = nil;
	if (![self.managedObjectContext save:&error]) 
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    [self.tableView reloadData];
}

- (void)save
{
    self.avaliacao.comentCriticos = self.comentCriticosTextView.text;
    self.avaliacao.comentMelhorar = self.comentMelhorarTextView.text;
    self.avaliacao.comentPositivos = self.comentPositivosTextView.text;
    self.avaliacao.numero = self.numeroField.text;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"avaliacao == %@", self.avaliacao];
    [fetchRequest setPredicate:predicate];
    
    int respostasCount = 0;
    int respostasSum = 0;
    
    NSArray *respostas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (Resposta *resposta in respostas) {
        if (resposta.valor.intValue >= 0)
        {
            respostasSum += resposta.valor.intValue;
            respostasCount++;
        }
    }
    
    if (respostasCount > 0)
    {
        double notaGeral = (double) respostasSum / respostasCount;
        self.avaliacao.notaGeral = [NSNumber numberWithDouble:notaGeral];
    } 
    else 
    {
        self.avaliacao.notaGeral = [NSNumber numberWithInt:0];
    }
    
    NSError *error = nil;
	if (![self.managedObjectContext save:&error]) 
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

@end