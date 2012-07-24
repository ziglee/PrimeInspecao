//
//  Foto.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Avaliacao;

@interface Foto : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * legenda;
@property (nonatomic, retain) Avaliacao *avaliacao;

@end
