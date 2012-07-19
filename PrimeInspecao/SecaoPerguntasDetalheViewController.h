//
//  SecaoPerguntasDetalheViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecaoPerguntas.h"

@interface SecaoPerguntasDetalheViewController : UITableViewController <UITextFieldDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) SecaoPerguntas *secaoPerguntas;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UITextField *tituloTextField;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
