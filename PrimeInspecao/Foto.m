//
//  Foto.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Foto.h"
#import "Avaliacao.h"


@implementation Foto

@dynamic image;
@dynamic avaliacao;

+ (void)initialize {
	if (self == [Foto class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
