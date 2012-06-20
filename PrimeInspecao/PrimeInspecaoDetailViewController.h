//
//  PrimeInspecaoDetailViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Obra.h"
#import <UIKit/UIKit.h>

@interface PrimeInspecaoDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Obra *detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *nomeTextField;

- (IBAction) saveButton: (id)sender;

@end
