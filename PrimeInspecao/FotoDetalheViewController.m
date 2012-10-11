//
//  FotoDetalheViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FotoDetalheViewController.h"
#import "FotoEditViewController.h"

@implementation FotoDetalheViewController

@synthesize imageView;
@synthesize foto;
@synthesize managedObjectContext = __managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Editar" style:UIBarButtonItemStyleBordered target:self action:@selector(fotoEdit)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:editButton, nil];

    self.navigationItem.title = @"Foto";
    self.imageView.image = foto.image;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (void)fotoEdit
{
    FotoEditViewController *editFoto = [self.storyboard instantiateViewControllerWithIdentifier:@"FotoEdit"];
    editFoto.managedObjectContext = self.managedObjectContext;
    editFoto.foto = self.foto;
    
    [self.navigationController pushViewController:editFoto animated:YES];
}

@end
