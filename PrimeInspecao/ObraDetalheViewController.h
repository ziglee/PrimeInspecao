//
//  PrimeInspecaoDetailViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Obra.h"
#import <UIKit/UIKit.h>

@interface ObraDetalheViewController : UIViewController <UISplitViewControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) Obra *detailItem;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *nomeTextField;
@property (strong, nonatomic) IBOutlet UITextField *engenheiroTextField;

@end
