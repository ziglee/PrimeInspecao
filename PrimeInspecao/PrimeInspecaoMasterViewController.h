//
//  PrimeInspecaoMasterViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrimeInspecaoDetailViewController;

#import <CoreData/CoreData.h>

@interface PrimeInspecaoMasterViewController : UIViewController

@property (strong, nonatomic) PrimeInspecaoDetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
