//
//  ResumoAvaliacaoViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResumoAvaliacaoViewController.h"
#import "AvaliacaoTableViewController.h"
#import "PreviewPdfViewController.h"
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
- (void)drawPageNumber:(NSInteger)pageNum;
- (void)drawPrimeLogo;
- (void)drawObraInfo;
- (void)drawQuadroResumo;
- (void)drawRespostas;
- (void)drawFotos;
- (void)drawObservacoes;
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
@synthesize label1 = _label1;
@synthesize label2 = _label2;
@synthesize label3 = _label3;
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
        self.label1.text = [NSString stringWithFormat:@"%@:", self.avaliacao.obra.label1];
        self.label2.text = [NSString stringWithFormat:@"%@:", self.avaliacao.obra.label2];
        self.label3.text = [NSString stringWithFormat:@"%@:", self.avaliacao.obra.label3];
        self.numeroLabel.text = [NSString stringWithFormat:@"%@", self.avaliacao.numero];
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
    alert = [[UIAlertView alloc] initWithTitle:@"Prime Inspeção" message:@"Gerando relatório..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    if(alert != nil) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        indicator.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height-45);
        [indicator startAnimating];
        [alert addSubview:indicator];
    }
    
    currentPage = 1;
    
    pageSize = CGSizeMake(612, 792);
    NSString *fileName = @"report.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    // Primeira pagina (dados da obra)
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    [self drawPrimeLogo];
    [self drawPageNumber:currentPage];
    [self drawObraInfo];
    
    // Segunda pagina (Resumo da avaliacao)
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    [self drawPageNumber:++currentPage];    
    [self drawQuadroResumo];    
    
    // Terceira pagina (Detalhes das respostas)
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    [self drawPageNumber:++currentPage];
    [self drawRespostas];
    
    // Observacoes
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    [self drawPageNumber:++currentPage];
    [self drawObservacoes];
    
    // Fotos da avaliacao
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    [self drawPageNumber:++currentPage];
    [self drawFotos];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    PreviewPdfViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewPdf"]; 
    [self.navigationController pushViewController:controller animated:YES];
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

#pragma mark - PDF Generation

- (void)drawPrimeLogo
{
    UIImage * bgImage = [UIImage imageNamed:@"bg-01.png"];
    [bgImage drawInRect:CGRectMake(0, 0, kWidth, kHeight)];
    
    UIImage * demoImage = [UIImage imageNamed:@"prime.jpeg"];
    [demoImage drawInRect:CGRectMake((pageSize.width/2 - demoImage.size.width/3), kBorderInset, demoImage.size.width/1.5, demoImage.size.height/1.5)];
}

- (void)drawPageNumber:(NSInteger)pageNumber
{
    NSString* pageNumberString = [NSString stringWithFormat:@"- Página %d -", pageNumber];
    UIFont* theFont = [UIFont systemFontOfSize:12];
    
    CGSize pageNumberStringSize = [pageNumberString sizeWithFont:theFont
                                               constrainedToSize:pageSize
                                                   lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect stringRenderingRect = CGRectMake(kBorderInset,
                                            pageSize.height - 40.0,
                                            pageSize.width - 2*kBorderInset,
                                            pageNumberStringSize.height);
    
    [pageNumberString drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
}

- (void)drawObraInfo{
    UIFont* theFont = [UIFont boldSystemFontOfSize:14];
    
    // Nome
    NSString* obraNomeString = [NSString stringWithFormat:@"Obra: %@", self.avaliacao.obra.nome];
    
    CGSize pageNumberStringSize = [obraNomeString sizeWithFont:theFont
                                             constrainedToSize:pageSize
                                                 lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect stringRenderingRect = CGRectMake(kBorderInset,
                                            kBorderInset + 600,
                                            300,
                                            pageNumberStringSize.height);
    
    [obraNomeString drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    
    // Label1
    NSString* label1String = [NSString stringWithFormat:@"%@: %@", self.avaliacao.obra.label1, self.avaliacao.obra.engenheiro];
    
    pageNumberStringSize = [label1String sizeWithFont:theFont
                                             constrainedToSize:pageSize
                                                 lineBreakMode:UILineBreakModeWordWrap];
    
    stringRenderingRect = CGRectMake(kBorderInset,
                                            kBorderInset + 620,
                                            300,
                                            pageNumberStringSize.height);
    
    [label1String drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    
    // Label2
    NSString* label2String = [NSString stringWithFormat:@"%@: %@", self.avaliacao.obra.label2, self.avaliacao.obra.supervisor];
    
    pageNumberStringSize = [label2String sizeWithFont:theFont
                                    constrainedToSize:pageSize
                                        lineBreakMode:UILineBreakModeWordWrap];
    
    stringRenderingRect = CGRectMake(kBorderInset,
                                     kBorderInset + 640,
                                     300,
                                     pageNumberStringSize.height);
    
    [label2String drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    
    // Label3
    NSString* label3String = [NSString stringWithFormat:@"%@: %@", self.avaliacao.obra.label3, self.avaliacao.obra.gerente];
    
    pageNumberStringSize = [label2String sizeWithFont:theFont
                                    constrainedToSize:pageSize
                                        lineBreakMode:UILineBreakModeWordWrap];
    
    stringRenderingRect = CGRectMake(kBorderInset,
                                     kBorderInset + 660,
                                     300,
                                     pageNumberStringSize.height);
    
    [label3String drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];

    // Data
    NSString* dataString = [NSString stringWithFormat:@"Data: %@", [self.dateFormatter stringFromDate: self.avaliacao.data]];
    
    pageNumberStringSize = [dataString sizeWithFont:theFont
                                    constrainedToSize:pageSize
                                        lineBreakMode:UILineBreakModeWordWrap];
    
    stringRenderingRect = CGRectMake(kBorderInset,
                                     kBorderInset + 680,
                                     300,
                                     pageNumberStringSize.height);
    
    [dataString drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    
    // Visita
    NSString* visitaString = [NSString stringWithFormat:@"Visita: #%@", self.avaliacao.numero];
    
    pageNumberStringSize = [visitaString sizeWithFont:theFont
                                    constrainedToSize:pageSize
                                        lineBreakMode:UILineBreakModeWordWrap];
    
    stringRenderingRect = CGRectMake(kBorderInset,
                                     kBorderInset + 700,
                                     300,
                                     pageNumberStringSize.height);
    
    [visitaString drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
}

- (void)drawQuadroResumo
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.15, 1);
    CGContextFillRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset), 30));
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset), 30));
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset) - 60, 30));
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset) - 120, 30));
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset) - 180, 30));
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset) - 290, 30));
    
    UIFont* theFont = [UIFont boldSystemFontOfSize:12];

    CGContextSetRGBFillColor(currentContext, 1, 1, 1, 1);
    
    NSString* str = @"QUADRO RESUMO";
    CGSize stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect stringRenderingRect = CGRectMake(kBorderInset + 15,
                                            kBorderInset + 8,
                                            stringSize.width,
                                            stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont];
    
    theFont = [UIFont systemFontOfSize:9];
    
    str = @"Avaliação";
    stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    stringRenderingRect = CGRectMake(kBorderInset + 318,
                                            kBorderInset + 9,
                                            stringSize.width,
                                            stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont];
    
    str = @"Sinalização";
    stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    stringRenderingRect = CGRectMake(kBorderInset + 400,
                                     kBorderInset + 9,
                                     stringSize.width,
                                     stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont];
    
    str = @"Situação";
    stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    stringRenderingRect = CGRectMake(kBorderInset + 464,
                                     kBorderInset + 9,
                                     stringSize.width,
                                     stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont];
    
    UIFont* normalFont = [UIFont systemFontOfSize:12];
    
    int rowHeightOffset = 0;
    int rowHeight = 30;
    
    int rowY = kBorderInset + rowHeight * (++rowHeightOffset);
    
    CGContextSetRGBFillColor(currentContext, 0.85, 0.85, 0.85, 1);
    CGContextFillRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), rowHeight));
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), rowHeight));
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 60, rowHeight));
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 120, rowHeight));
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 180, rowHeight));
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 290, rowHeight));

    UIImage * starOnImage = [UIImage imageNamed:@"rate_star_on_yellow.png"];
    UIImage * starHalfImage = [UIImage imageNamed:@"rate_star_half_yellow.png"];
    UIImage * starOffImage = [UIImage imageNamed:@"rate_star_off_yellow.png"];
    
    CGSize starSize = starOnImage.size;
    
    if (self.avaliacao.notaGeral.doubleValue <= 4) {
        [starOffImage drawInRect:CGRectMake(390, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    if (self.avaliacao.notaGeral.doubleValue <= 3) {
        [starOffImage drawInRect:CGRectMake(370, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    if (self.avaliacao.notaGeral.doubleValue <= 2) {
        [starOffImage drawInRect:CGRectMake(350, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    if (self.avaliacao.notaGeral.doubleValue <= 1) {
        [starOffImage drawInRect:CGRectMake(330, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    if (self.avaliacao.notaGeral.doubleValue == 0) {
        [starOffImage drawInRect:CGRectMake(310, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 1) {
        [starOnImage drawInRect:CGRectMake(310, rowY + 7, starSize.width/2, starSize.height/2)];
    } else if (self.avaliacao.notaGeral.doubleValue > 0 && self.avaliacao.notaGeral.doubleValue < 1) {
        [starHalfImage drawInRect:CGRectMake(310, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 2) {
        [starOnImage drawInRect:CGRectMake(330, rowY + 7, starSize.width/2, starSize.height/2)];
    } else if (self.avaliacao.notaGeral.doubleValue > 1 && self.avaliacao.notaGeral.doubleValue < 2) {
        [starHalfImage drawInRect:CGRectMake(330, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 3) {
        [starOnImage drawInRect:CGRectMake(350, rowY + 7, starSize.width/2, starSize.height/2)];
    } else if (self.avaliacao.notaGeral.doubleValue > 2 && self.avaliacao.notaGeral.doubleValue < 3) {
        [starHalfImage drawInRect:CGRectMake(350, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 4) {
        [starOnImage drawInRect:CGRectMake(370, rowY + 7, starSize.width/2, starSize.height/2)];
    } else if (self.avaliacao.notaGeral.doubleValue > 3 && self.avaliacao.notaGeral.doubleValue < 4) {
        [starHalfImage drawInRect:CGRectMake(370, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 5) {
        [starOnImage drawInRect:CGRectMake(390, rowY + 7, starSize.width/2, starSize.height/2)];
    } else if (self.avaliacao.notaGeral.doubleValue > 4 && self.avaliacao.notaGeral.doubleValue < 5) {
        [starHalfImage drawInRect:CGRectMake(390, rowY + 7, starSize.width/2, starSize.height/2)];
    }
    
    if (self.avaliacao.notaGeral.doubleValue * 20 < 50) {
        UIImage * image = [UIImage imageNamed:@"circle_red.png"];
        CGSize imageSize = image.size;
        [image drawInRect:CGRectMake(431, rowY + 5, imageSize.width/3, imageSize.height/3)];
    } else if (self.avaliacao.notaGeral.doubleValue * 20 < 75) {
        UIImage * image = [UIImage imageNamed:@"circle_yellow.png"];
        CGSize imageSize = image.size;
        [image drawInRect:CGRectMake(431, rowY + 5, imageSize.width/3, imageSize.height/3)];
    } else {
        UIImage * image = [UIImage imageNamed:@"circle_green.png"];
        CGSize imageSize = image.size;
        [image drawInRect:CGRectMake(431, rowY + 5, imageSize.width/3, imageSize.height/3)];
    }
    
    if (self.avaliacaoAnterior) {
        if (self.avaliacao.notaGeral.doubleValue > self.avaliacaoAnterior.notaGeral.doubleValue) {
            UIImage * image = [UIImage imageNamed:@"arrow_up_green.png"];
            CGSize imageSize = image.size;
            [image drawInRect:CGRectMake(492, rowY + 6, imageSize.width/2.5, imageSize.height/2.5)];
        } else if (self.avaliacao.notaGeral.doubleValue < self.avaliacaoAnterior.notaGeral.doubleValue) {
            UIImage * image = [UIImage imageNamed:@"arrow_down_red.png"];
            CGSize imageSize = image.size;
            [image drawInRect:CGRectMake(492, rowY + 6, imageSize.width/2.5, imageSize.height/2.5)];
        } else {
            UIImage * image = [UIImage imageNamed:@"arrow_right_gray.png"];
            CGSize imageSize = image.size;
            [image drawInRect:CGRectMake(492, rowY + 6, imageSize.width/3.3, imageSize.height/3.3)];
        }
    }
    
    str = @"Nota Geral";
    stringSize = [str sizeWithFont:normalFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    stringRenderingRect = CGRectMake(kBorderInset + 15,
                                     rowY + 8,
                                     stringSize.width,
                                     stringSize.height);
    [str drawInRect:stringRenderingRect withFont:normalFont];
    
    str = [NSString stringWithFormat:@"%1.0f%%", self.avaliacao.notaGeral.doubleValue * 20];
    stringSize = [str sizeWithFont:normalFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    stringRenderingRect = CGRectMake(527,
                                     rowY + 8,
                                     50,
                                     stringSize.height);
    [str drawInRect:stringRenderingRect withFont:normalFont lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentRight];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *secoes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (SecaoPerguntas *secao in secoes) {
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
        
        rowY = kBorderInset + rowHeight * (++rowHeightOffset);
        
        CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), rowHeight));
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 60, rowHeight));
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 120, rowHeight));
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 180, rowHeight));
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 290, rowHeight));
        
        str = secao.titulo;
        stringSize = [str sizeWithFont:normalFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
        stringRenderingRect = CGRectMake(kBorderInset + 25,
                                         rowY + 8,
                                         250,
                                         25);
        [str drawInRect:stringRenderingRect withFont:normalFont lineBreakMode:UILineBreakModeTailTruncation];
        
        float rating = 0;
        
        if (respostasCount > 0) {
            rating = (float) respostasSum / respostasCount;
            
            if (rating * 20 < 50) {
                UIImage * image = [UIImage imageNamed:@"circle_red.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(431, rowY + 5, imageSize.width/3, imageSize.height/3)];
            } else if (rating * 20 < 75) {
                UIImage * image = [UIImage imageNamed:@"circle_yellow.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(431, rowY + 5, imageSize.width/3, imageSize.height/3)];
            } else {
                UIImage * image = [UIImage imageNamed:@"circle_green.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(431, rowY + 5, imageSize.width/3, imageSize.height/3)];
            }
            
            if (rating <= 4) {
                [starOffImage drawInRect:CGRectMake(390, rowY + 7, starSize.width/2, starSize.height/2)];
            }
            if (rating <= 3) {
                [starOffImage drawInRect:CGRectMake(370, rowY + 7, starSize.width/2, starSize.height/2)];
            }
            if (rating <= 2) {
                [starOffImage drawInRect:CGRectMake(350, rowY + 7, starSize.width/2, starSize.height/2)];
            }
            if (rating <= 1) {
                [starOffImage drawInRect:CGRectMake(330, rowY + 7, starSize.width/2, starSize.height/2)];
            }
            if (rating == 0) {
                [starOffImage drawInRect:CGRectMake(310, rowY + 7, starSize.width/2, starSize.height/2)];
            }
            
            if (rating >= 1) {
                [starOnImage drawInRect:CGRectMake(310, rowY + 7, starSize.width/2, starSize.height/2)];
            } else if (rating > 0 && rating < 1) {
                [starHalfImage drawInRect:CGRectMake(310, rowY + 7, starSize.width/2, starSize.height/2)];
            }
            
            if (rating >= 2) {
                [starOnImage drawInRect:CGRectMake(330, rowY + 7, starSize.width/2, starSize.height/2)];
            } else if (rating > 1 && rating < 2) {
                [starHalfImage drawInRect:CGRectMake(330, rowY + 7, starSize.width/2, starSize.height/2)];
            }
            
            if (rating >= 3) {
                [starOnImage drawInRect:CGRectMake(350, rowY + 7, starSize.width/2, starSize.height/2)];
            } else if (rating > 2 && rating < 3) {
                [starHalfImage drawInRect:CGRectMake(350, rowY + 7, starSize.width/2, starSize.height/2)];
            }

            if (rating >= 4) {
                [starOnImage drawInRect:CGRectMake(370, rowY + 7, starSize.width/2, starSize.height/2)];
            } else if (rating > 3 && rating < 4) {
                [starHalfImage drawInRect:CGRectMake(370, rowY + 7, starSize.width/2, starSize.height/2)];
            }

            if (rating >= 5) {
                [starOnImage drawInRect:CGRectMake(390, rowY + 7, starSize.width/2, starSize.height/2)];
            } else if (rating > 4 && rating < 5) {
                [starHalfImage drawInRect:CGRectMake(390, rowY + 7, starSize.width/2, starSize.height/2)];
            }
        }
        
        if (self.avaliacaoAnterior) {
            double notaAnterior = [self nota:secao avaliacaoAnterior:self.avaliacaoAnterior];
            if (rating > notaAnterior) {
                UIImage * image = [UIImage imageNamed:@"arrow_up_green.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(492, rowY + 6, imageSize.width/2.5, imageSize.height/2.5)];
            } else if (rating < notaAnterior) {
                UIImage * image = [UIImage imageNamed:@"arrow_down_red.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(492, rowY + 6, imageSize.width/2.5, imageSize.height/2.5)];
            } else {
                UIImage * image = [UIImage imageNamed:@"arrow_right_gray.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(492, rowY + 6, imageSize.width/3.3, imageSize.height/3.3)];
            }
        }
        
        str = [NSString stringWithFormat:@"%1.0f%%", rating * 20];
        stringSize = [str sizeWithFont:normalFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
        stringRenderingRect = CGRectMake(527,
                                         rowY + 8,
                                         50,
                                         stringSize.height);
        [str drawInRect:stringRenderingRect withFont:normalFont lineBreakMode:UILineBreakModeWordWrap alignment:NSTextAlignmentRight];
    }
}

- (void)drawRespostas
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.15, 1);
    CGContextFillRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset), 30));
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset), 30));
    
    UIFont* theFont = [UIFont boldSystemFontOfSize:12];
    
    CGContextSetRGBFillColor(currentContext, 1, 1, 1, 1);
    
    NSString* str = @"DETALHES DA AVALIACAO";
    CGSize stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect stringRenderingRect = CGRectMake(kBorderInset,
                                            kBorderInset + 8,
                                            kWidth - (2*kBorderInset),
                                            stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    
    UIImage *starOnImage = [UIImage imageNamed:@"rate_star_on_yellow.png"];
    UIImage *starOffImage = [UIImage imageNamed:@"rate_star_off_yellow.png"];
    
    CGSize starSize = starOnImage.size;
    
    UIFont *secaoFont = [UIFont italicSystemFontOfSize:12];
    UIFont *perguntaFont = [UIFont systemFontOfSize:11];
    UIFont *simNaoFont = [UIFont systemFontOfSize:9];
    
    int rowHeightOffset = 0;
    int rowHeight = 30;
    int rowY = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *secoes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (SecaoPerguntas *secao in secoes) {
        if (rowY + 3*rowHeight > kHeight) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
            [self drawPageNumber:++currentPage];
            rowHeightOffset = -1;
        }
        
        rowY = kBorderInset + rowHeight * (++rowHeightOffset);
        
        CGContextSetRGBFillColor(currentContext, 0.85, 0.85, 0.85, 1);
        CGContextFillRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), 30));
        
        CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), 30));
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 172, 30));
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY+1, kWidth - (2 * kBorderInset), 28));
        
        str = [secao.titulo uppercaseString];
        stringSize = [str sizeWithFont:secaoFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
        stringRenderingRect = CGRectMake(kBorderInset + 15,
                                         rowY + 8,
                                         370,
                                         25);
        [str drawInRect:stringRenderingRect withFont:secaoFont lineBreakMode:UILineBreakModeTailTruncation];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pergunta.secao == %@ and avaliacao == %@", secao, self.avaliacao];
        [fetchRequest setPredicate:predicate];
        
        NSArray *respostas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        for (Resposta *resposta in respostas) {
            if (rowY + 3*rowHeight > kHeight) {
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
                [self drawPageNumber:++currentPage];
                rowHeightOffset = -1;
            }
            
            rowY = kBorderInset + rowHeight * (++rowHeightOffset);
            
            CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
            CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), 30));
            CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset) - 172, 30));
            
            str = resposta.pergunta.titulo;
            stringSize = [str sizeWithFont:perguntaFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
            stringRenderingRect = CGRectMake(kBorderInset + 30,
                                             rowY + 8,
                                             350,
                                             20);
            [str drawInRect:stringRenderingRect withFont:perguntaFont lineBreakMode:UILineBreakModeTailTruncation];
            
            if (resposta.pergunta.tipoSimNao.intValue == 1) {
                str = @"Necessário";
                stringSize = [str sizeWithFont:simNaoFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
                stringRenderingRect = CGRectMake(430,
                                                 rowY + 9,
                                                 50,
                                                 stringSize.height);
                [str drawInRect:stringRenderingRect withFont:simNaoFont];
                
                str = @"Requerido";
                stringSize = [str sizeWithFont:simNaoFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
                stringRenderingRect = CGRectMake(511,
                                                 rowY + 9,
                                                 50,
                                                 stringSize.height);
                [str drawInRect:stringRenderingRect withFont:simNaoFont];
                
                UIImage * imageAccepted = [UIImage imageNamed:@"accepted.png"];
                UIImage * imageCancel = [UIImage imageNamed:@"cancel.png"];
                
                CGSize imageAcceptedSize = imageAccepted.size;
                CGSize imageCancelSize = imageCancel.size;
                
                if (resposta.implementado.intValue == 1) {
                    [imageAccepted drawInRect:CGRectMake(480, rowY + 5, imageAcceptedSize.width/2.5, imageAcceptedSize.height/2.5)];
                } else {
                    [imageCancel drawInRect:CGRectMake(480, rowY + 5, imageCancelSize.width/2.5, imageCancelSize.height/2.5)];
                }
                
                if (resposta.requerido.intValue == 1) {
                    [imageAccepted drawInRect:CGRectMake(560, rowY + 5, imageAcceptedSize.width/2.5, imageAcceptedSize.height/2.5)];
                } else {
                    [imageCancel drawInRect:CGRectMake(560, rowY + 5, imageCancelSize.width/2.5, imageCancelSize.height/2.5)];
                }
            } else {
                if (resposta.valor.intValue >= 1) {
                    [starOnImage drawInRect:CGRectMake(458, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                if (resposta.valor.intValue >= 2) {
                    [starOnImage drawInRect:CGRectMake(478, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                if (resposta.valor.intValue >= 3) {
                    [starOnImage drawInRect:CGRectMake(498, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                if (resposta.valor.intValue >= 4) {
                    [starOnImage drawInRect:CGRectMake(518, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                if (resposta.valor.intValue >= 5) {
                    [starOnImage drawInRect:CGRectMake(538, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                
                if (resposta.valor.intValue <= 4) {
                    [starOffImage drawInRect:CGRectMake(538, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                if (resposta.valor.intValue <= 3) {
                    [starOffImage drawInRect:CGRectMake(518, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                if (resposta.valor.intValue <= 2) {
                    [starOffImage drawInRect:CGRectMake(498, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                if (resposta.valor.intValue <= 1) {
                    [starOffImage drawInRect:CGRectMake(478, rowY + 7, starSize.width/2, starSize.height/2)];
                }
                if (resposta.valor.intValue == 0) {
                    [starOffImage drawInRect:CGRectMake(458, rowY + 7, starSize.width/2, starSize.height/2)];
                }
            }
            
            if (resposta.valor.intValue < 2.5) {
                UIImage * image = [UIImage imageNamed:@"circle_red.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(27, rowY + 7, imageSize.width/4, imageSize.height/4)];
            } else if (resposta.valor.intValue < 3.75) {
                UIImage * image = [UIImage imageNamed:@"circle_yellow.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(27, rowY + 7, imageSize.width/4, imageSize.height/4)];
            } else {
                UIImage * image = [UIImage imageNamed:@"circle_green.png"];
                CGSize imageSize = image.size;
                [image drawInRect:CGRectMake(27, rowY + 7, imageSize.width/4, imageSize.height/4)];
            }
        }
    }
}

- (void) drawFotos
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.15, 1);
    CGContextFillRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset), 30));
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset), 30));
    
    UIFont *theFont = [UIFont boldSystemFontOfSize:12];
    UIFont *secaoFont = [UIFont italicSystemFontOfSize:12];
    UIFont *legendaFont = [UIFont systemFontOfSize:11];
    
    CGContextSetRGBFillColor(currentContext, 1, 1, 1, 1);
    
    NSString* str = @"FOTOS DA AVALIACAO";
    CGSize stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect stringRenderingRect = CGRectMake(kBorderInset,
                                            kBorderInset + 8,
                                            kWidth - (2*kBorderInset),
                                            stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];

    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    
    int rowHeight = 300;
    int rowY = kBorderInset + 30;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *secoes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (SecaoPerguntas *secao in secoes) {
        
        NSFetchRequest *fotosFetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"Foto" inManagedObjectContext:self.managedObjectContext];
        [fotosFetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"avaliacao == %@ and secao == %@", self.avaliacao, secao];
        [fotosFetchRequest setPredicate:predicate];
        NSArray *fotos = [self.managedObjectContext executeFetchRequest:fotosFetchRequest error:nil];
        
        if (fotos.count == 0)
            continue;
        
        if (rowY + 60 > kHeight) {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
            [self drawPageNumber:++currentPage];
            rowY = kBorderInset;
        }
        
        CGContextSetRGBFillColor(currentContext, 0.85, 0.85, 0.85, 1);
        CGContextFillRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), 30));
        
        CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), 30));
        
        CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
        
        NSString *str = [secao.titulo uppercaseString];
        stringSize = [str sizeWithFont:secaoFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
        stringRenderingRect = CGRectMake(kBorderInset + 15,
                                         rowY + 8,
                                         kWidth - 3 * kBorderInset,
                                         20);
        [str drawInRect:stringRenderingRect withFont:secaoFont lineBreakMode:UILineBreakModeTailTruncation];
        
        rowY += 30;
        
        NSInteger fotosCount = fotos.count;
        NSInteger index = 0;
        
        while (index < fotosCount) {
            if (rowY + rowHeight + 30 > kHeight) {
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
                [self drawPageNumber:++currentPage];
                rowY = kBorderInset;
            }
            
            CGContextSetRGBFillColor(currentContext, 0.95, 0.95, 0.95, 1);
            CGContextFillRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), 182));
            
            CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
            CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth - (2 * kBorderInset), 300));
            
            CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, rowY, kWidth/2 - kBorderInset, 300));
            
            Foto *foto = [fotos objectAtIndex:index++];
            UIImage *image = [foto.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(700, 700) interpolationQuality:kCGInterpolationNone];
            CGSize imageSize = image.size;
            [image drawInRect:CGRectMake(kBorderInset + 1 + (284-imageSize.width/4)/2, rowY + 1 + (180-imageSize.height/4)/2, imageSize.width/4, imageSize.height/4)];
            
            str = foto.legenda;
            stringSize = [str sizeWithFont:legendaFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
            stringRenderingRect = CGRectMake(kBorderInset * 2,
                                             rowY + kBorderInset + 180,
                                             240,
                                             150);
            [str drawInRect:stringRenderingRect withFont:legendaFont lineBreakMode:UILineBreakModeTailTruncation];
            
            if (index < fotosCount) {
                Foto *foto = [fotos objectAtIndex:index++];
                UIImage *image = [foto.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(700, 700) interpolationQuality:kCGInterpolationHigh];
                CGSize imageSize = image.size;
                
                [image drawInRect:CGRectMake(kWidth/2 + 1 + (284-imageSize.width/4)/2, rowY + 1 + (180-imageSize.height/4)/2, imageSize.width/4, imageSize.height/4)];
                
                str = foto.legenda;
                stringSize = [str sizeWithFont:legendaFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
                stringRenderingRect = CGRectMake(kBorderInset * 2 + 286,
                                                 rowY + kBorderInset + 180,
                                                 240,
                                                 150);
                [str drawInRect:stringRenderingRect withFont:legendaFont lineBreakMode:UILineBreakModeTailTruncation];
            }
            
            rowY += rowHeight;
        }
    }
}

- (void)drawObservacoes
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.9, 0.9, 0.9, 1);
    CGContextFillRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset), 30));
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset, kWidth - (2 * kBorderInset), 30));
    
    UIImage *image = [UIImage imageNamed:@"positive.gif"];
    CGSize imageSize = image.size;
    [image drawInRect:CGRectMake(kBorderInset + 6 , kBorderInset + 7, imageSize.width/1.3, imageSize.height/1.3)];
    
    UIFont *theFont = [UIFont boldSystemFontOfSize:12];
    UIFont *textoFont = [UIFont systemFontOfSize:12];
    
    NSString* str = @"PONTOS POSITIVOS";
    CGSize stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect stringRenderingRect = CGRectMake(kBorderInset,
                                            kBorderInset + 8,
                                            kWidth - (2*kBorderInset),
                                            stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset + 30, kWidth - (2 * kBorderInset), 200));
    
    str = self.avaliacao.comentPositivos;
    stringSize = [str sizeWithFont:textoFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
    stringRenderingRect = CGRectMake(kBorderInset * 2,
                                     kBorderInset * 2 + 30,
                                     kWidth - 4 * kBorderInset,
                                     160);
    [str drawInRect:stringRenderingRect withFont:textoFont lineBreakMode:UILineBreakModeTailTruncation];
    
    CGContextSetRGBFillColor(currentContext, 0.9, 0.9, 0.9, 1);
    CGContextFillRect(currentContext, CGRectMake (kBorderInset, kBorderInset * 2 + 230, kWidth - (2 * kBorderInset), 30));
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset * 2 + 230, kWidth - (2 * kBorderInset), 30));
    
    image = [UIImage imageNamed:@"negative.gif"];
    imageSize = image.size;
    [image drawInRect:CGRectMake(kBorderInset + 6 , kBorderInset * 2 + 230 + 7, imageSize.width/1.3, imageSize.height/1.3)];
    
    str = @"PONTOS CRÍTICOS";
    stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    stringRenderingRect = CGRectMake(kBorderInset,
                                            kBorderInset*2 + 38 + 200,
                                            kWidth - (2*kBorderInset),
                                            stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset*2 + 230, kWidth - (2 * kBorderInset), 200));
    
    str = self.avaliacao.comentCriticos;
    stringSize = [str sizeWithFont:textoFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
    stringRenderingRect = CGRectMake(kBorderInset * 2,
                                     kBorderInset * 3 + 260,
                                     kWidth - 4 * kBorderInset,
                                     160);
    [str drawInRect:stringRenderingRect withFont:textoFont lineBreakMode:UILineBreakModeTailTruncation];
    
    CGContextSetRGBFillColor(currentContext, 0.9, 0.9, 0.9, 1);
    CGContextFillRect(currentContext, CGRectMake (kBorderInset, kBorderInset * 3 + 430, kWidth - (2 * kBorderInset), 30));
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1);
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset * 3 + 430, kWidth - (2 * kBorderInset), 30));
    
    image = [UIImage imageNamed:@"alert.gif"];
    imageSize = image.size;
    [image drawInRect:CGRectMake(kBorderInset + 6 , kBorderInset * 3 + 430 + 7, imageSize.width/1.3, imageSize.height/1.3)];
    
    str = @"PONTOS A MELHORAR";
    stringSize = [str sizeWithFont:theFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeWordWrap];
    stringRenderingRect = CGRectMake(kBorderInset,
                                     kBorderInset*3 + 438,
                                     kWidth - (2*kBorderInset),
                                     stringSize.height);
    [str drawInRect:stringRenderingRect withFont:theFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
    
    CGContextStrokeRect(currentContext, CGRectMake (kBorderInset, kBorderInset*3 + 430, kWidth - (2 * kBorderInset), 200));
    
    str = self.avaliacao.comentMelhorar;
    stringSize = [str sizeWithFont:textoFont constrainedToSize:pageSize lineBreakMode:UILineBreakModeTailTruncation];
    stringRenderingRect = CGRectMake(kBorderInset * 2,
                                     kBorderInset * 4 + 460,
                                     kWidth - 4 * kBorderInset,
                                     160);
    [str drawInRect:stringRenderingRect withFont:textoFont lineBreakMode:UILineBreakModeTailTruncation];
}

@end
