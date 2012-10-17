//
//  PrimeInspecaoMasterViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrimeInspecaoMasterViewController.h"
#import "ObrasTableViewController.h"
#import "ObraDetalheViewController.h"
#import "SecaoPerguntasTableViewController.h"
#import "Obra.h"

@interface PrimeInspecaoMasterViewController()
    @property (nonatomic, strong) NSMutableArray* obrasAnnot;
    @property (nonatomic, strong) NSMutableArray* annotations;
@end

@implementation PrimeInspecaoMasterViewController

@synthesize annotations = _annotations;
@synthesize obrasAnnot = _obrasAnnot;
@synthesize mapView = _mapView;
@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Obra" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nome" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *obras = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    self.annotations = [NSMutableArray arrayWithCapacity:1];
    self.obrasAnnot = [NSMutableArray arrayWithCapacity:1];
    
    for (Obra *obra in obras) {
        CLLocationCoordinate2D location;
        location.latitude = obra.latitude.doubleValue;
        location.longitude = obra.longitude.doubleValue;
        
        MKPointAnnotation *newAnnotation = [[MKPointAnnotation alloc] init];
        newAnnotation.coordinate = location;
        newAnnotation.title = obra.nome;
    
        [self.obrasAnnot addObject: obra];
        [self.annotations addObject: newAnnotation];
    }
    [self.mapView addAnnotations:self.annotations];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.mapView removeAnnotations: self.annotations];
}

#pragma mark - MapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    
    view.draggable = NO;
    view.enabled = YES;
    view.canShowCallout = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    [view setRightCalloutAccessoryView:rightButton];
    
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
         nil;        
        for (int j = 0; j < self.obrasAnnot.count; j++) {
            Obra *selectedObject = [self.obrasAnnot objectAtIndex:j];
            NSLog(@"%@ - %@", selectedObject.nome, view.annotation.title);
            if ([selectedObject.nome isEqualToString:view.annotation.title]) {
                ObraDetalheViewController *detalheObra = [self.storyboard instantiateViewControllerWithIdentifier:@"ObraDetalhe"];
                detalheObra.managedObjectContext = self.managedObjectContext;
                detalheObra.detailItem = selectedObject;
                
                [self.navigationController pushViewController:detalheObra animated:YES];
                break;
            }
        }
    }
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"obras"]) 
    {
        ObrasTableViewController *destination = [segue destinationViewController];
        destination.managedObjectContext = self.managedObjectContext;
    } 
    else if ([identifier isEqualToString:@"secoes"]) 
    {
        SecaoPerguntasTableViewController *destination = [segue destinationViewController];
        destination.managedObjectContext = self.managedObjectContext;
    }
}

@end
