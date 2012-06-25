//
//  PerguntaRespostaCell.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 25/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PerguntaRespostaCell.h"

@implementation PerguntaRespostaCell

@synthesize perguntaObj;
@synthesize tituloLabel;
@synthesize segmentedControl;
@synthesize cellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setPergunta:(Pergunta *)newPergunta
{
    NSString *texto = newPergunta.titulo;
    if (newPergunta.obrigatoria.intValue == 1)
    {
        texto = [texto stringByAppendingString: @" *"];
    }
    self.tituloLabel.text = texto;
    self.perguntaObj = newPergunta;
}

#pragma mark - Button clicked
- (IBAction)onButtonClicked:(id)sender
{
    if (cellDelegate != nil && [cellDelegate conformsToProtocol:@protocol(PerguntaRespostaCellDelegate)])
        {
            if ([cellDelegate respondsToSelector:@selector(onRespostaButtonClicked:cell:)]) 
            {
                [cellDelegate onRespostaButtonClicked:sender cell:self];
            }
        }
    
    segmentedControl.selectedSegmentIndex = -1;
}

@end
