//
//  FotoDetalheViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foto.h"

@interface FotoDetalheViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) Foto *foto;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
