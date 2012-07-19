//
//  PrimeInspecaoDetailViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Obra.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface ObraDetalheViewController : UIViewController < MKMapViewDelegate >

@property (strong, nonatomic) Obra *detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *nomeTextField;
@property (strong, nonatomic) IBOutlet UITextField *engenheiroTextField;
@property (strong, nonatomic) IBOutlet UITextField *supervisorTextField;
@property (strong, nonatomic) IBOutlet UITextField *gerenteTextField;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
