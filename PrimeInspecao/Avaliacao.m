//
//  Avaliacao.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Avaliacao.h"
#import "Foto.h"
#import "Obra.h"
#import "Resposta.h"
#import "UIImageToDataTransformer.h"

@implementation Avaliacao

@dynamic comentCriticos;
@dynamic comentMelhorar;
@dynamic comentPositivos;
@dynamic data;
@dynamic notaGeral;
@dynamic numero;
@dynamic fotos;
@dynamic obra;
@dynamic respostas;

+ (void)initialize {
	if (self == [Avaliacao class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
