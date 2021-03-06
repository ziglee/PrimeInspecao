//
//  Avaliacao.h
//  PrimeInspecao
//
//  Created by Cassio Landim on 10/10/12.
//
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
@property (nonatomic, retain) NSNumber * numero;
@property (nonatomic, retain) NSSet *fotos;
@property (nonatomic, retain) Obra *obra;
@property (nonatomic, retain) NSSet *respostas;
@end

@interface Avaliacao (CoreDataGeneratedAccessors)

- (void)addFotosObject:(Foto *)value;
- (void)removeFotosObject:(Foto *)value;
- (void)addFotos:(NSSet *)values;
- (void)removeFotos:(NSSet *)values;

- (void)addRespostasObject:(Resposta *)value;
- (void)removeRespostasObject:(Resposta *)value;
- (void)addRespostas:(NSSet *)values;
- (void)removeRespostas:(NSSet *)values;

@end
