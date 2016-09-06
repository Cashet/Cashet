//
//  CastCollection.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/19/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MoviedatabaseItem.h"

@interface CastCollection : JSONModel

@property(nonatomic, retain) NSNumber<Optional>* movieId;
@property(nonatomic, retain) NSArray<MoviedatabaseItem ,Optional>* cast;

@end
