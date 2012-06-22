//
//  PerguntaDetalheViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecaoPerguntas.h"
#import "Pergunta.h"

@interface PerguntaDetalheViewController : UIViewController

@property (strong, nonatomic) SecaoPerguntas *secaoPerguntas;
@property (strong, nonatomic) Pergunta *pergunta;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *tituloTextField;
@property (strong, nonatomic) IBOutlet UISwitch *obrigatoriaSwitch;

@end
