//
//  Pergunta.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SecaoPerguntas;

@interface Pergunta : NSManagedObject

@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSNumber * obrigatoria;
@property (nonatomic, retain) NSNumber * posicao;
@property (nonatomic, retain) SecaoPerguntas *secao;

@end
