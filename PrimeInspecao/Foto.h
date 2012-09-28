//
//  Foto.h
//  PrimeInspecao
//
//  Created by Cassio Landim on 27/09/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Avaliacao, SecaoPerguntas;

@interface Foto : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * legenda;
@property (nonatomic, retain) Avaliacao *avaliacao;
@property (nonatomic, retain) SecaoPerguntas *secao;

@end
