//
//  FotoEditViewController.h
//  PrimeInspecao
//
//  Created by Cassio Landim on 11/10/12.
//
//

#import <UIKit/UIKit.h>
#import "Foto.h"

@interface FotoEditViewController : UIViewController

@property (strong, nonatomic) Foto *foto;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *legendaTextField;


@end
