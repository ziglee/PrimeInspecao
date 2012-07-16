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
@synthesize respostaObj;
@synthesize tituloLabel;
@synthesize segmentedControl;
@synthesize requiredSwitch;
@synthesize implementedSwitch;
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
    if (newPergunta.tipoSimNao.intValue == 0)
    {
        [segmentedControl setHidden:NO];
        [requiredSwitch setHidden:YES];
        [implementedSwitch setHidden:YES];
        [requiredSwitch setUserInteractionEnabled:NO];
        [implementedSwitch setUserInteractionEnabled:NO];
    } 
    else 
    {
        [segmentedControl setHidden:YES];
        [requiredSwitch setHidden:NO];
        [implementedSwitch setHidden:NO];
        [requiredSwitch setUserInteractionEnabled:YES];
        [implementedSwitch setUserInteractionEnabled:YES];
    }
    self.tituloLabel.text = texto;
    self.perguntaObj = newPergunta;
}

- (void)setResposta:(Resposta *)newResposta
{
    NSInteger valor = newResposta.valor.intValue;
    if (perguntaObj.tipoSimNao.intValue == 0) {
        [segmentedControl setSelectedSegmentIndex:valor + 1];
    } else {
        [requiredSwitch setOn: newResposta.requerido.intValue == 1];
        [implementedSwitch setOn: newResposta.implementado.intValue == 1];
    }

    self.respostaObj = newResposta;
}

#pragma mark - SegmentedControl clicked

- (IBAction)onSegmentedControlClicked:(id)sender
{
    if (cellDelegate != nil && [cellDelegate conformsToProtocol:@protocol(PerguntaRespostaCellDelegate)])
    {
        if ([cellDelegate respondsToSelector:@selector(onRespostaButtonClicked:cell:)]) 
        {
            [cellDelegate onRespostaButtonClicked:sender cell:self];
        }
    }
}

@end
