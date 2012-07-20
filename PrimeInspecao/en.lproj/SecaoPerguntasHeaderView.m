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

@synthesize titleLabel=_titleLabel, rateView=_rateView;

+ (Class)layerClass {
    return [CAGradientLayer class];
}

-(void)initWithTitle:(NSString*)title nota:(NSNumber *)nota
{
    self.titleLabel.text = title;
    self.rateView.notSelectedImage = [UIImage imageNamed:@"rate_star_off_yellow.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"rate_star_half_yellow.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"rate_star_on_yellow.png"];
    self.rateView.maxRating = 5;
    self.rateView.rating = nota.doubleValue;
}

@end
