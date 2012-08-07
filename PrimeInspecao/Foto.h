//
//  Foto.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Avaliacao, SecaoPerguntas;

@interface Foto : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * legenda;
@property (nonatomic, retain) Avaliacao *avaliacao;
@property (nonatomic, retain) SecaoPerguntas *secao;

@end
