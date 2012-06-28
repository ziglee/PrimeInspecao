//
//  SecaoPerguntasHeaderView.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SecaoPerguntasHeaderView.h"

@implementation SecaoPerguntasHeaderView

@synthesize titleLabel=_titleLabel, notaLabel=_notaLabel;

+ (Class)layerClass {
    return [CAGradientLayer class];
}

-(void)initWithTitle:(NSString*)title nota:(NSNumber *)nota
{
    self.titleLabel.text = title;
    self.notaLabel.text = [NSString stringWithFormat:@"%1.1f", nota.doubleValue];
}

@end
