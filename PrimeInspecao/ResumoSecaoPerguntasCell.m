//
//  ResumoSecaoPerguntasCell.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResumoSecaoPerguntasCell.h"

@implementation ResumoSecaoPerguntasCell

@synthesize tituloLabel=_tituloLabel;
@synthesize rateView=_rateView;
@synthesize porcentagemLabel=_porcentagemLabel;
@synthesize situacaoImage=_situacaoImage;
@synthesize sinalizacaoImage=_sinalizacaoImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
@end
