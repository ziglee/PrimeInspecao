//
//  PreviewPdfViewController.m
//  PrimeInspecao
//
//  Created by Cassio Landim on 27/09/12.
//
//

#import "PreviewPdfViewController.h"

@interface PreviewPdfViewController ()

@end

@implementation PreviewPdfViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStyleBordered target:self action:@selector(composeMail)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:editButton, nil];
    
    NSString *fileName = @"report.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];

    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [webView setScalesPageToFit:YES];
}

- (void) composeMail
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
    
    // Set the subject of email
    [picker setSubject:@"Prime - Relatório de Visita"];
    
    NSString *emailBody = @"Relatório de Visita em anexo.";
    
    // This is not an HTML formatted email
    [picker setMessageBody:emailBody isHTML:NO];
    
    NSString *fileName = @"report.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSData *exportFileData = [NSData dataWithContentsOfFile:pdfFileName];
    
    // Attach image data to the email
    [picker addAttachmentData:exportFileData mimeType:@"application/pdf" fileName:@"relatorio.pdf"];
    
    [self presentModalViewController:picker animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    /*
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
     */
    [self dismissModalViewControllerAnimated:YES];
}

@end
