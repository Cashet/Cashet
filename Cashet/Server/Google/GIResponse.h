//
//  GoogleImagesResponse.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/8/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "GIQueries.h"
#import "GIItem.h"
#import "GIError.h"

@interface GIResponse : JSONModel

@property(nonatomic, retain) GIQueries<Optional>* queries;
@property(nonatomic, retain) NSArray<GIItem, Optional>* items;
@property(nonatomic, retain) GIError<Optional>* error;

@end
