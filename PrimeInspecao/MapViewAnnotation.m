//
//  MapViewAnnotation.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	self = [super init];
	self.title = ttl;
	self.coordinate = c2d;
	return self;
}

@end
