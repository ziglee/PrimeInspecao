//
//  Avaliacao.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 21/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Obra;

@interface Avaliacao : NSManagedObject

@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) NSString * numero;
@property (nonatomic, retain) NSString * comentPositivos;
@property (nonatomic, retain) NSString * comentCriticos;
@property (nonatomic, retain) NSString * comentMelhorar;
@property (nonatomic, retain) Obra *obra;
@property (nonatomic, retain) NSSet *respostas;
@end

@interface Avaliacao (CoreDataGeneratedAccessors)

- (void)addRespostasObject:(NSManagedObject *)value;
- (void)removeRespostasObject:(NSManagedObject *)value;
- (void)addRespostas:(NSSet *)values;
- (void)removeRespostas:(NSSet *)values;

@end
