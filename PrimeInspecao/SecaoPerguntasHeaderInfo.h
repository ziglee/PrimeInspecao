//
//  SecaoPerguntasHeaderInfo.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecaoPerguntasHeaderView.h"
#import "SecaoPerguntas.h"

@interface SecaoPerguntasHeaderInfo : NSObject

@property (strong) SecaoPerguntas* secaoPerguntas;
@property (strong) SecaoPerguntasHeaderView* headerView;

@end
