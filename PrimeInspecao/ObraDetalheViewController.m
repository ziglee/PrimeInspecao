//
//  PrimeInspecaoDetailViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObraDetalheViewController.h"
#import "AvaliacaoTableViewController.h"
#import "AvaliacoesTableViewController.h"
#import "MapViewAnnotation.h"

@interface ObraDetalheViewController ()
- (void)configureView;
@end

@implementation ObraDetalheViewController

@synthesize mapView = _mapView;
@synthesize detailItem = _detailItem;
@synthesize nomeTextField = _nomeTextField;
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
        self.navigationItem.title = self.detailItem.nome;
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
        newAnnotation.title = self.detailItem.nome;
    
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
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Erro ao salvar obra." delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - MapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    [view setDraggable:YES];
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        self.detailItem.latitude = [NSNumber numberWithDouble:droppedAt.latitude];
        self.detailItem.longitude = [NSNumber numberWithDouble:droppedAt.longitude];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"avaliacao"]) 
    {
        Avaliacao *avaliacao = [NSEntityDescription insertNewObjectForEntityForName:@"Avaliacao" inManagedObjectContext:self.managedObjectContext];
        avaliacao.data = [[NSDate alloc] init];
        //avaliacao.obra = self.detailItem;
        [self.detailItem addAvaliacoesObject:avaliacao];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) 
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        AvaliacaoTableViewController *destination = [segue destinationViewController];
        destination.managedObjectContext = self.managedObjectContext;
        destination.avaliacao = avaliacao;
    } 
    else if ([identifier isEqualToString:@"avaliacoes"]) 
    {
        AvaliacoesTableViewController *destination = [segue destinationViewController];
        destination.managedObjectContext = self.managedObjectContext;
        destination.obra = self.detailItem;
    }
}

@end
