//
//  GIQueries.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/8/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GIRequest.h"

@interface GIQueries : JSONModel

@property(nonatomic, retain) NSArray<GIRequest>* request;
@property(nonatomic, retain) NSArray<GIRequest>* nextPage;

@end
