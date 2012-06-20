//
//  Obra.h
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Obra : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * engenheiro;

@end
