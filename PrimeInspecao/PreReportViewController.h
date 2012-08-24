//
//  PreReportViewController.h
//  PrimeInspecao
//
//  Created by Cassio Landim on 23/08/12.
//
//

#import <UIKit/UIKit.h>
#import "Avaliacao.h"

@interface PreReportViewController : UIViewController {
    NSMutableData *responseData;
    UIBackgroundTaskIdentifier bgTask;
    UIAlertView *alert;
}

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) Avaliacao *avaliacao;
@property (strong, nonatomic) Avaliacao *avaliacaoAnterior;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)onSendClicked:(id)sender;
- (IBAction)onCancelClicked:(id)sender;

@end
