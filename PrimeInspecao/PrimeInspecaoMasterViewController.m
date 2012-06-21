//
//  PrimeInspecaoMasterViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrimeInspecaoMasterViewController.h"
#import "ObrasTableViewController.h"

@implementation PrimeInspecaoMasterViewController

@synthesize managedObjectContext = __managedObjectContext;

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"obras"]) {
        ObrasTableViewController *destination = [segue destinationViewController];
        destination.managedObjectContext = self.managedObjectContext;
    } 
}

@end
