//
//  PreReportViewController.m
//  PrimeInspecao
//
//  Created by Cassio Landim on 23/08/12.
//
//

#import "PreReportViewController.h"
#import "Obra.h"
#import "SecaoPerguntas.h"
#import "Pergunta.h"
#import "Resposta.h"
#import "Foto.h"
#import "NSData+CITBase64.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"

@interface PreReportViewController ()
- (float) nota: (SecaoPerguntas *)secao avaliacaoAnterior:(Avaliacao *) avaliacao;
@end

@implementation PreReportViewController

@synthesize dateFormatter;
@synthesize emailTextField = _emailTextField;
@synthesize avaliacao = _avaliacao;
@synthesize avaliacaoAnterior = _avaliacaoAnterior;
@synthesize managedObjectContext = __managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.emailTextField.text = [prefs stringForKey:@"report_email"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (IBAction)onCancelClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onSendClicked:(id)sender
{
    alert = [[UIAlertView alloc] initWithTitle:@"Prime Inspeção" message:@"Gerando e enviando o relatório..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    if(alert != nil) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        indicator.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height-45);
        [indicator startAnimating];
        [alert addSubview:indicator];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.emailTextField.text forKey:@"report_email"];

    [self generatePdfButtonPressed]; 
}

- (void) dismissAlertAndModal
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)generatePdfButtonPressed
{
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.avaliacao.obra.nome, @"obra", nil];
    
    if (self.avaliacao.obra.engenheiro)
        [data setObject: self.avaliacao.obra.engenheiro forKey: @"engenheiro"];
    if (self.avaliacao.obra.supervisor)
        [data setObject: self.avaliacao.obra.supervisor forKey: @"supervisor"];
    if (self.avaliacao.obra.gerente)
        [data setObject: self.avaliacao.obra.gerente forKey: @"gerente"];
    if (self.avaliacao.comentCriticos)
        [data setObject: self.avaliacao.comentCriticos forKey: @"ptscriticos"];
    if (self.avaliacao.comentMelhorar)
        [data setObject: self.avaliacao.comentMelhorar forKey: @"ptsamelhorar"];
    if (self.avaliacao.comentPositivos)
        [data setObject: self.avaliacao.comentPositivos forKey: @"ptspositivos"];
    if (self.avaliacao.data)
        [data setObject: [self.dateFormatter stringFromDate:self.avaliacao.data] forKey: @"data"];
    if (self.avaliacao.numero)
        [data setObject: self.avaliacao.numero forKey: @"numero"];
    if (self.avaliacao.notaGeral)
        [data setObject: [NSString stringWithFormat:@"%1.0f%%", self.avaliacao.notaGeral.doubleValue * 20] forKey: @"nota"];
    
    NSMutableArray* secoesData = [NSMutableArray arrayWithCapacity:1];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *secoes = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (SecaoPerguntas *secao in secoes) {
        NSMutableDictionary* secaoData = [NSMutableDictionary dictionaryWithObjectsAndKeys: secao.titulo, @"snome", secao.titulo.uppercaseString, @"snomeupper", nil];
        NSMutableArray* respostasData = [NSMutableArray arrayWithCapacity:1];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pergunta.secao == %@ and avaliacao == %@", secao, self.avaliacao];
        [fetchRequest setPredicate:predicate];
        
        NSArray *respostas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        int respostasCount = 0;
        int respostasSum = 0;
        
        for (Resposta *resposta in respostas) {
            NSMutableDictionary* respostaData = [NSMutableDictionary dictionaryWithObjectsAndKeys: resposta.pergunta.titulo, @"rtitulo", resposta.valor, @"rvalor", resposta.pergunta.tipoSimNao, @"rtipoSimNao", resposta.implementado, @"rimplementado", resposta.requerido, @"rrequerido", nil];
            
            [respostaData setObject: @"[userImage:circle_yellow.png]" forKey: @"rsinal"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar1"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar2"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar3"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar4"];
            [respostaData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"rstar5"];
            
            if (resposta.pergunta.tipoSimNao.intValue == 1) {
                [respostaData setObject: @"[userImage:cancel.png]" forKey: @"rsinal"];
                
                if (resposta.implementado.intValue == 1) {
                    [respostaData setObject: @"[userImage:accepted.png]" forKey: @"rimplementado"];
                } else {
                    [respostaData setObject: @"[userImage:cancel.png]" forKey: @"rimplementado"];
                }
                
                if (resposta.requerido.intValue == 1) {
                    [respostaData setObject: @"[userImage:accepted.png]" forKey: @"rrequerido"];
                } else {
                    [respostaData setObject: @"[userImage:cancel.png]" forKey: @"rrequerido"];
                }
                
                if (resposta.implementado.intValue == 1 && resposta.requerido.intValue == 1) {
                    [respostaData setObject: @"[userImage:accepted.png]" forKey: @"rsinal"];
                }
            } else {
                if (resposta.valor.intValue < 2.5) {
                    [respostaData setObject: @"[userImage:circle_red.png]" forKey: @"rsinal"];
                } else if (resposta.valor.intValue < 3.75) {
                    [respostaData setObject: @"[userImage:circle_yellow.png]" forKey: @"rsinal"];
                } else {
                    [respostaData setObject: @"[userImage:circle_green.png]" forKey: @"rsinal"];
                }
            }
            
            if (resposta.valor.intValue >= 1) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar1"];
            }
            if (resposta.valor.intValue >= 2) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar2"];
            }
            if (resposta.valor.intValue >= 3) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar3"];
            }
            if (resposta.valor.intValue >= 4) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar4"];
            }
            if (resposta.valor.intValue >= 5) {
                [respostaData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"rstar5"];
            }
            
            [respostasData addObject:respostaData];
            
            if (resposta.valor.intValue >= 0) {
                respostasSum += resposta.valor.intValue;
                respostasCount++;
            }
        }
        
        float rating = 0;
        
        [secaoData setObject: respostasData forKey: @"respostas"];
        [secaoData setObject: @"N.A." forKey: @"snota"];
        [secaoData setObject: @"[userImage:circle_yellow.png]" forKey: @"ssinal"];
        [secaoData setObject: @"[userImage:arrow_right_gray.png]" forKey: @"ssituacao"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar1"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar2"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar3"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar4"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"sstar5"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star1"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star2"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star3"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star4"];
        [secaoData setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"s2star5"];
        
        if (respostasCount > 0) {
            rating = (float) respostasSum / respostasCount;
            [secaoData setObject: [NSString stringWithFormat:@"%1.0f%%", rating * 20] forKey: @"snota"];
            if (rating * 20 < 50) {
                [secaoData setObject: @"[userImage:circle_red.png]" forKey: @"ssinal"];
                [secaoData setObject: @"[userImage:circle_red.png]" forKey: @"s2sinal"];
            } else if (rating * 20 < 75) {
                [secaoData setObject: @"[userImage:circle_yellow.png]" forKey: @"ssinal"];
                [secaoData setObject: @"[userImage:circle_yellow.png]" forKey: @"s2sinal"];
            } else {
                [secaoData setObject: @"[userImage:circle_green.png]" forKey: @"ssinal"];
                [secaoData setObject: @"[userImage:circle_green.png]" forKey: @"s2sinal"];
            }
            
            if (rating >= 1) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar1"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star1"];
            } else if (rating >= 0.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar1"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star1"];
            }
            
            if (rating >= 2) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar2"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star2"];
            } else if (rating >= 1.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar2"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star2"];
            }
            
            if (rating >= 3) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar3"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star3"];
            } else if (rating >= 2.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar3"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star3"];
            }
            
            if (rating >= 4) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar4"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star4"];
            } else if (rating >= 3.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar4"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star4"];
            }
            
            if (rating >= 5) {
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"sstar5"];
                [secaoData setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"s2star5"];
            } else if (rating >= 4.5) {
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"sstar5"];
                [secaoData setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"s2star5"];
            }
        }
        
        if (self.avaliacaoAnterior) {
            double notaAnterior = [self nota:secao avaliacaoAnterior:self.avaliacaoAnterior];
            if (rating > notaAnterior) {
                [secaoData setObject: @"[userImage:arrow_up_green.png]" forKey: @"ssituacao"];
            } else if (rating < notaAnterior) {
                [secaoData setObject: @"[userImage:arrow_down_red.png]" forKey: @"ssituacao"];
            } else {
                [secaoData setObject: @"[userImage:arrow_right_gray.png]" forKey: @"ssituacao"];
            }
        }
        
        NSMutableArray* fotosData = [NSMutableArray arrayWithCapacity:1];
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"Foto" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        predicate = [NSPredicate predicateWithFormat:@"avaliacao == %@ and secao == %@", self.avaliacao, secao];
        [fetchRequest setPredicate:predicate];
        NSArray *fotos = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        for (int i = 0; i < [fotos count]; i++) {
            Foto *foto = [fotos objectAtIndex:i];
            UIImage *image = [foto.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(300, 440) interpolationQuality:kCGInterpolationMedium];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
            NSString *encodedString = [imageData stringInBase64FromData];
            NSMutableArray* row = [NSMutableDictionary dictionaryWithObjectsAndKeys: foto.legenda, @"flegenda", [@"image:base64:" stringByAppendingString:encodedString], @"fimage", nil];
            
            [fotosData addObject: row];
        }
        [secaoData setObject: fotosData forKey: @"fotos"];
        
        
        [secoesData addObject: secaoData];
    }
    [data setObject: secoesData forKey: @"secoes"];
    
    [data setObject: @"[userImage:circle_yellow.png]" forKey: @"sinal"];
    [data setObject: @"[userImage:arrow_right_gray.png]" forKey: @"situacao"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star1"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star2"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star3"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star4"];
    [data setObject: @"[userImage:rate_star_off_yellow.png]" forKey: @"star5"];
    
    if (self.avaliacao.notaGeral.doubleValue * 20 < 50) {
        [data setObject: @"[userImage:circle_red.png]" forKey: @"sinal"];
    } else if (self.avaliacao.notaGeral.doubleValue * 20 < 75) {
        [data setObject: @"[userImage:circle_yellow.png]" forKey: @"sinal"];
    } else {
        [data setObject: @"[userImage:circle_green.png]" forKey: @"sinal"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 1) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star1"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 0.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star1"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 2) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star2"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 1.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star2"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 3) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star3"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 2.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star3"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 4) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star4"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 3.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star4"];
    }
    
    if (self.avaliacao.notaGeral.doubleValue >= 5) {
        [data setObject: @"[userImage:rate_star_on_yellow.png]" forKey: @"star5"];
    } else if (self.avaliacao.notaGeral.doubleValue >= 4.5) {
        [data setObject: @"[userImage:rate_star_half_yellow.png]" forKey: @"star5"];
    }
    
    if (self.avaliacaoAnterior) {
        if (self.avaliacao.notaGeral.doubleValue > self.avaliacaoAnterior.notaGeral.doubleValue) {
            [data setObject: @"[userImage:arrow_up_green.png]" forKey: @"situacao"];
        } else if (self.avaliacao.notaGeral.doubleValue < self.avaliacaoAnterior.notaGeral.doubleValue) {
            [data setObject: @"[userImage:arrow_down_red.png]" forKey: @"situacao"];
        } else {
            [data setObject: @"[userImage:arrow_right_gray.png]" forKey: @"situacao"];
        }
    }
    
    NSString *mailTo = [NSString stringWithFormat:@"mailto:%@:pdf", self.emailTextField.text];
    
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"M2I4MzViZDItNzhhOS00MTMwLWFiOTEtMTc4ZjY1MjI5ZTM3OjI1MTUyMDU", @"accessKey", @"prime/template.odt", @"templateName", @"avaliacao.pdf", @"outputName", mailTo, @"storeTo", data, @"data", @"Prime avaliação", @"mailSubject", nil];
    
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonText = [[NSString alloc] initWithData:jsonData                                        encoding:NSUTF8StringEncoding];
    
    NSLog(@"Json: %@", jsonText);
    
    NSData* dataBody = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://dws.docmosis.com/services/rs/render"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dataBody];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        responseData = [NSMutableData data];
    } else {
        NSLog(@"Conexão nula");
    }
}

- (float) nota: (SecaoPerguntas *)secao avaliacaoAnterior:(Avaliacao *) avaliacao {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Resposta" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pergunta.secao == %@ and avaliacao == %@", secao, avaliacao];
    [fetchRequest setPredicate:predicate];
    
    NSArray *respostas = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    int respostasCount = 0;
    int respostasSum = 0;
    
    for (Resposta *resposta in respostas) {
        if (resposta.valor.intValue >= 0) {
            respostasSum += resposta.valor.intValue;
            respostasCount++;
        }
    }
    
    if (respostas == 0)
        return 0;
    
    return (float) respostasSum / respostasCount;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if (json != nil) {
        NSLog(@"json: %@", json);
    } else {
        NSLog(@"error: %@", [error description]);
    }
    
    [self performSelectorOnMainThread:@selector(dismissAlertAndModal) withObject:nil waitUntilDone:YES];
}

@end
