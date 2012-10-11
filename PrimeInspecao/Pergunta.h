//
//  Pergunta.h
//  PrimeInspecao
//
//  Created by Cassio Landim on 10/10/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Resposta, SecaoPerguntas;

@interface Pergunta : NSManagedObject

@property (nonatomic, retain) NSNumber * posicao;
@property (nonatomic, retain) NSNumber * tipoSimNao;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSSet *respostas;
@property (nonatomic, retain) SecaoPerguntas *secao;
@end

@interface Pergunta (CoreDataGeneratedAccessors)

- (void)addRespostasObject:(Resposta *)value;
- (void)removeRespostasObject:(Resposta *)value;
- (void)addRespostas:(NSSet *)values;
- (void)removeRespostas:(NSSet *)values;

@end
