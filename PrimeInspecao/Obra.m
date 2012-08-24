//
//  Obra.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Obra.h"
#import "Avaliacao.h"
#import "UIImageToDataTransformer.h"

@implementation Obra

@dynamic engenheiro;
@dynamic gerente;
@dynamic latitude;
@dynamic longitude;
@dynamic nome;
@dynamic supervisor;
@dynamic avaliacoes;

+ (void)initialize {
    if (self == [Obra class]) {
        UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
        [NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
    }
}

@end
