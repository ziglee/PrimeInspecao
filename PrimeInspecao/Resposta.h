//
//  Resposta.h
//  PrimeInspecao
//
//  Created by Cassio Landim on 10/10/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Avaliacao, Pergunta;

@interface Resposta : NSManagedObject

@property (nonatomic, retain) NSNumber * implementado;
@property (nonatomic, retain) NSNumber * requerido;
@property (nonatomic, retain) NSNumber * valor;
@property (nonatomic, retain) Avaliacao *avaliacao;
@property (nonatomic, retain) Pergunta *pergunta;

@end
