//
//  Pergunta.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Resposta, SecaoPerguntas;

@interface Pergunta : NSManagedObject

@property (nonatomic, retain) NSNumber * obrigatoria;
@property (nonatomic, retain) NSNumber * posicao;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) SecaoPerguntas *secao;
@property (nonatomic, retain) NSSet *respostas;
@end

@interface Pergunta (CoreDataGeneratedAccessors)

- (void)addRespostasObject:(Resposta *)value;
- (void)removeRespostasObject:(Resposta *)value;
- (void)addRespostas:(NSSet *)values;
- (void)removeRespostas:(NSSet *)values;

@end
