//
//  AvaliacaoTableViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Avaliacao.h"
#import "Obra.h"
#import "PerguntaRespostaCell.h"
#import <UIKit/UIKit.h>

@interface AvaliacaoTableViewController : UITableViewController <PerguntaRespostaCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) Avaliacao *avaliacao;
@property (strong, nonatomic) NSArray *secoesPerguntas;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UILabel *nomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UITextField *numeroField;
@property (strong, nonatomic) IBOutlet UITextView *comentCriticosTextView;
@property (strong, nonatomic) IBOutlet UITextView *comentMelhorarTextView;
@property (strong, nonatomic) IBOutlet UITextView *comentPositivosTextView;

@end
