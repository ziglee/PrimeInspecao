//
//  SecaoPerguntasDetalheViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecaoPerguntas.h"

@interface SecaoPerguntasDetalheViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) SecaoPerguntas *detailItem;
@property (nonatomic, retain) NSOrderedSet *perguntas;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *tituloTextField;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
