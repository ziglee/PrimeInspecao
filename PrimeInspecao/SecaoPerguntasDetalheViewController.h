//
//  SecaoPerguntasDetalheViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecaoPerguntas.h"

@interface SecaoPerguntasDetalheViewController : UIViewController

@property (strong, nonatomic) SecaoPerguntas *detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *tituloTextField;

@end
