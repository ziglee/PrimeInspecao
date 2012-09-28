//
//  Obra.h
//  PrimeInspecao
//
//  Created by Cassio Landim on 27/09/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Avaliacao;

@interface Obra : NSManagedObject

@property (nonatomic, retain) NSString * engenheiro;
@property (nonatomic, retain) NSString * gerente;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * supervisor;
@property (nonatomic, retain) NSString * label1;
@property (nonatomic, retain) NSString * label2;
@property (nonatomic, retain) NSString * label3;
@property (nonatomic, retain) NSString * label4;
@property (nonatomic, retain) NSSet *avaliacoes;
@end

@interface Obra (CoreDataGeneratedAccessors)

- (void)addAvaliacoesObject:(Avaliacao *)value;
- (void)removeAvaliacoesObject:(Avaliacao *)value;
- (void)addAvaliacoes:(NSSet *)values;
- (void)removeAvaliacoes:(NSSet *)values;

@end
