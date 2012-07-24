//
//  Avaliacao.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Foto, Obra, Resposta;

@interface Avaliacao : NSManagedObject

@property (nonatomic, retain) NSString * comentCriticos;
@property (nonatomic, retain) NSString * comentMelhorar;
@property (nonatomic, retain) NSString * comentPositivos;
@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) NSNumber * notaGeral;
@property (nonatomic, retain) NSString * numero;
@property (nonatomic, retain) Obra *obra;
@property (nonatomic, retain) NSSet *respostas;
@property (nonatomic, retain) Foto *fotos;
@end

@interface Avaliacao (CoreDataGeneratedAccessors)

- (void)addRespostasObject:(Resposta *)value;
- (void)removeRespostasObject:(Resposta *)value;
- (void)addRespostas:(NSSet *)values;
- (void)removeRespostas:(NSSet *)values;

@end
