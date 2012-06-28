//
//  SecaoPerguntasHeaderView.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecaoPerguntasHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *notaLabel;

-(void)initWithTitle:(NSString*)title nota:(NSNumber*)nota;

@end
