//
//  PrimeInspecaoDetailViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObraDetalheViewController.h"
#import "MapViewAnnotation.h"

@interface ObraDetalheViewController ()
- (void)configureView;
@end

@implementation ObraDetalheViewController

@synthesize mapView = _mapView;
@synthesize detailItem = _detailItem;
@synthesize nomeTextField = _nomeTextField;
@synthesize latitudeTextField = _latitudeTextField;
@synthesize longitudeTextField = _longitudeTextField;
@synthesize engenheiroTextField = _engenheiroTextField;
@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;        
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        self.nomeTextField.text = self.detailItem.nome;
        self.engenheiroTextField.text = self.detailItem.engenheiro;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Salvar" style:UIBarButtonItemStyleDone target:self action:@selector(saveButton)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if (self.detailItem != nil) {
        CLLocationCoordinate2D location;
        location.latitude = self.detailItem.latitude.doubleValue;
        location.longitude = self.detailItem.longitude.doubleValue;
    
        MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
        newAnnotation.coordinate = location;
        newAnnotation.title = @"TESTE";
    
        [self.mapView addAnnotation:newAnnotation];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)saveButton
{
    self.detailItem.nome = self.nomeTextField.text;
    self.detailItem.engenheiro = self.engenheiroTextField.text;
    self.detailItem.latitude = [NSNumber numberWithFloat:[self.latitudeTextField.text floatValue]];
    self.detailItem.longitude = [NSNumber numberWithFloat:[self.longitudeTextField.text floatValue]];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sucesso" message:@"Obra salva com sucesso." delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - MapView delegate

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}

@end
