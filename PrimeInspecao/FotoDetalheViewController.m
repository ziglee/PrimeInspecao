//
//  FotoDetalheViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FotoDetalheViewController.h"

@implementation FotoDetalheViewController

@synthesize imageView;
@synthesize foto;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.foto.legenda];
    self.imageView.image = foto.image;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

@end
