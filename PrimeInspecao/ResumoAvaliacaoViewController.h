//
//  ResumoAvaliacaoViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Avaliacao.h"
#import "Obra.h"
#import "PerguntaRespostaCell.h"
#import "RateView.h"

#define kBorderInset            20.0
#define kBorderWidth            1.0
#define kMarginInset            10.0
#define kWidth                  612.0
#define kHeight                 792.0

//Line drawing
#define kLineWidth              1.0

@interface ResumoAvaliacaoViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSMutableData *responseData;
    CGSize pageSize;
    UIAlertView *alert;
    NSInteger currentPage;
}

@property (strong, nonatomic) IBOutlet UILabel *nomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *engenheiroLabel;
@property (strong, nonatomic) IBOutlet UILabel *supervisorLabel;
@property (strong, nonatomic) IBOutlet UILabel *gerenteLabel;
@property (strong, nonatomic) IBOutlet UILabel *numeroLabel;
@property (strong, nonatomic) IBOutlet UILabel *notaGeralLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UITextView *comentCriticosTextView;
@property (strong, nonatomic) IBOutlet UITextView *comentMelhorarTextView;
@property (strong, nonatomic) IBOutlet UITextView *comentPositivosTextView;
@property (strong, nonatomic) IBOutlet UIImageView *sinalizacaoImage;
@property (strong, nonatomic) IBOutlet UIImageView *situacaoImage;
@property (strong, nonatomic) IBOutlet RateView *rateView;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) Avaliacao *avaliacao;
@property (strong, nonatomic) Avaliacao *avaliacaoAnterior;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
