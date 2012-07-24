//
//  UIImagePickerViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Avaliacao.h"

@interface UIImagePickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *legendaField;

@property (strong, nonatomic) Avaliacao *avaliacao;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)savePhoto:(id)sender;
- (IBAction)discardPhoto:(id)sender;

@end
