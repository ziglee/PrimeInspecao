//
//  FotoEditViewController.m
//  PrimeInspecao
//
//  Created by Cassio Landim on 11/10/12.
//
//

#import "FotoEditViewController.h"

@interface FotoEditViewController ()
- (void)configureView;
@end

@implementation FotoEditViewController

@synthesize foto = _foto;
@synthesize legendaTextField = _legendaTextField;
@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self configureView];
}

- (void)configureView
{
    if (self.foto) {
        self.legendaTextField.text = self.foto.legenda;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.foto.legenda = self.legendaTextField.text;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Erro ao salvar foto." delegate:nil cancelButtonTitle:@"Fechar" otherButtonTitles:nil];
        [alert show];
    }
}

@end
