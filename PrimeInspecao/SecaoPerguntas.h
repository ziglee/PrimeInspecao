//
//  SecaoPerguntas.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pergunta;

@interface SecaoPerguntas : NSManagedObject

@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSNumber * posicao;
@property (nonatomic, retain) NSSet *perguntas;
@end

@interface SecaoPerguntas (CoreDataGeneratedAccessors)

- (void)addPerguntasObject:(Pergunta *)value;
- (void)removePerguntasObject:(Pergunta *)value;
- (void)addPerguntas:(NSSet *)values;
- (void)removePerguntas:(NSSet *)values;

@end
