//
//  GoogleImagesResponse.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/8/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "GIQueries.h"
#import "GIItem.h"

@interface GIResponse : JSONModel

@property(nonatomic, retain) GIQueries* queries;
@property(nonatomic, retain) NSArray<GIItem>* items;

@end
