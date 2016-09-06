//
//  ActorsPage.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MoviedatabaseItem.h"

@interface MoviedatabasePage : JSONModel

@property(nonatomic, retain) NSNumber* page;
@property(nonatomic, retain) NSArray<MoviedatabaseItem>* results;
@property(nonatomic, retain) NSNumber* totalResults;
@property(nonatomic, retain) NSNumber* totalPages;


@end
