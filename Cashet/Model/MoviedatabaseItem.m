//
//  MoviedatabaseItem.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/17/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "MoviedatabaseItem.h"

@implementation MoviedatabaseItem

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"known_for":@"knownFor",
                                                       @"profile_path":@"profilePath",
                                                       @"name":@"name",
                                                       @"media_type":@"mediaType",
                                                       @"title":@"title",
                                                       @"poster_path":@"posterPath",
                                                       @"id":@"identifier",
                                                       @"character":@"character"}];
}

@end
