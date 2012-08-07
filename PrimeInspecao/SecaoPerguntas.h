//
//  SecaoPerguntas.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Foto, Pergunta;

@interface SecaoPerguntas : NSManagedObject

@property (nonatomic, retain) NSNumber * posicao;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSOrderedSet *perguntas;
@property (nonatomic, retain) NSSet *fotos;
@end

@interface SecaoPerguntas (CoreDataGeneratedAccessors)

- (void)insertObject:(Pergunta *)value inPerguntasAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPerguntasAtIndex:(NSUInteger)idx;
- (void)insertPerguntas:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePerguntasAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPerguntasAtIndex:(NSUInteger)idx withObject:(Pergunta *)value;
- (void)replacePerguntasAtIndexes:(NSIndexSet *)indexes withPerguntas:(NSArray *)values;
- (void)addPerguntasObject:(Pergunta *)value;
- (void)removePerguntasObject:(Pergunta *)value;
- (void)addPerguntas:(NSOrderedSet *)values;
- (void)removePerguntas:(NSOrderedSet *)values;
- (void)addFotosObject:(Foto *)value;
- (void)removeFotosObject:(Foto *)value;
- (void)addFotos:(NSSet *)values;
- (void)removeFotos:(NSSet *)values;

@end
