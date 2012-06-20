//
//  PrimeInspecaoMasterViewController.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrimeInspecaoMasterViewController.h"
#import "PrimeInspecaoDetailViewController.h"

@implementation PrimeInspecaoMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewController = (PrimeInspecaoDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.detailViewController.managedObjectContext = self.managedObjectContext;
    self.detailViewController.fetchedResultsController = self.fetchedResultsController;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if ([identifier isEqualToString:@"obras"]) {
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    } 
}

@end
