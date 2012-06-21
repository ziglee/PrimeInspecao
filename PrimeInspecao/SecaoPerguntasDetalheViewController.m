//
//  SecaoPerguntasDetalheViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecaoPerguntasDetalheViewController.h"

@interface SecaoPerguntasDetalheViewController ()
- (void)configureView;
@end

@implementation SecaoPerguntasDetalheViewController

@synthesize detailItem = _detailItem;
@synthesize tituloTextField = _tituloTextField;
@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)configureView
{
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem.titulo;
        self.tituloTextField.text = self.detailItem.titulo;
    }
}

@end
