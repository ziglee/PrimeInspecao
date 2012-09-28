//
//  PreviewPdfViewController.h
//  PrimeInspecao
//
//  Created by Cassio Landim on 27/09/12.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface PreviewPdfViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    IBOutlet UIWebView *webView;
}

@end
