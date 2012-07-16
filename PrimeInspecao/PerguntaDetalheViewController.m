//
//  PerguntaDetalheViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PerguntaDetalheViewController.h"

@interface PerguntaDetalheViewController ()
- (void)configureView;
@end

@implementation PerguntaDetalheViewController

@synthesize secaoPerguntas = _secaoPerguntas;
@synthesize pergunta = _pergunta;
@synthesize tituloTextField = _tituloTextField;
@synthesize obrigatoriaSwitch = _obrigatoriaSwitch;
@synthesize managedObjectContext = __managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)configureView
{
    if (self.pergunta) {
        self.navigationItem.title = self.pergunta.titulo;
        self.tituloTextField.text = self.pergunta.titulo;
        [self.obrigatoriaSwitch setOn:self.pergunta.tipoSimNao.intValue == 1];
    }
}

- (void)save
{
    if (!self.pergunta) {
        self.pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext:self.managedObjectContext];
        
        NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.secaoPerguntas.perguntas];
        [tempSet addObject:self.pergunta];
        self.secaoPerguntas.perguntas = tempSet;
		self.pergunta.posicao = [NSNumber numberWithInteger:[self.secaoPerguntas.perguntas count]];
    }
    
    self.pergunta.titulo = self.tituloTextField.text;
    self.pergunta.tipoSimNao = self.obrigatoriaSwitch.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    
    NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
    [self.navigationController popViewControllerAnimated:YES];
}

@end
