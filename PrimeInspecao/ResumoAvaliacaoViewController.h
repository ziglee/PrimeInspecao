//
//  ResumoAvaliacaoViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Avaliacao.h"
#import "Obra.h"
#import "PerguntaRespostaCell.h"
#import <UIKit/UIKit.h>

@interface ResumoAvaliacaoViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) Avaliacao *avaliacao;
@property (strong, nonatomic) IBOutlet UILabel *nomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *engenheiroLabel;
@property (strong, nonatomic) IBOutlet UILabel *supervisorLabel;
@property (strong, nonatomic) IBOutlet UILabel *gerenteLabel;
@property (strong, nonatomic) IBOutlet UILabel *numeroLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UITextView *comentCriticosTextView;
@property (strong, nonatomic) IBOutlet UITextView *comentMelhorarTextView;
@property (strong, nonatomic) IBOutlet UITextView *comentPositivosTextView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
