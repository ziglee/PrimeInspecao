//
//  PrimeInspecaoMasterViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class ObraDetalheViewController;

@interface PrimeInspecaoMasterViewController : UIViewController < CLLocationManagerDelegate, MKMapViewDelegate >

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
