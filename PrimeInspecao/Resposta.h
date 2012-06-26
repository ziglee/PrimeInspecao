//
//  Resposta.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Avaliacao, Pergunta;

@interface Resposta : NSManagedObject

@property (nonatomic, retain) NSNumber * valor;
@property (nonatomic, retain) Avaliacao *avaliacao;
@property (nonatomic, retain) Pergunta *pergunta;

@end
