//
//  AvaliacaoTableViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Obra.h"
#import <UIKit/UIKit.h>

@interface AvaliacaoTableViewController : UITableViewController

@property (strong, nonatomic) Obra *obra;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UILabel *nomeLabel;

@end
