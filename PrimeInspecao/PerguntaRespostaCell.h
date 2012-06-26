//
//  PerguntaRespostaCell.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 25/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pergunta.h"

@protocol PerguntaRespostaCellDelegate;

@interface PerguntaRespostaCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *tituloLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet id cellDelegate;

@property (nonatomic, weak) Pergunta *perguntaObj;

- (void)setPergunta:(Pergunta *)pergunta;
- (IBAction)onSegmentedControlClicked:(id)sender;

@end

@protocol PerguntaRespostaCellDelegate

@optional

- (void) onRespostaButtonClicked:(id)sender cell:(PerguntaRespostaCell *)cell;

@end