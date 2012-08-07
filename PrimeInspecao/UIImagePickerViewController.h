//
//  UIImagePickerViewController.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Avaliacao.h"

@interface UIImagePickerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *legendaField;
@property (weak, nonatomic) IBOutlet UIPickerView *secaoPickerView;

@property (strong, nonatomic) Avaliacao *avaliacao;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)takePicture:(id)sender;
- (IBAction)savePhoto:(id)sender;
- (IBAction)discardPhoto:(id)sender;

@end
