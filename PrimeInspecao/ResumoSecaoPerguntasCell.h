//
//  ResumoSecaoPerguntasCell.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface ResumoSecaoPerguntasCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *tituloLabel;
@property (nonatomic, weak) IBOutlet UILabel *porcentagemLabel;
@property (nonatomic, weak) IBOutlet RateView *rateView;

@end
