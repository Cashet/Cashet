//
//  CastCollection.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/19/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "CastCollection.h"

@implementation CastCollection

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"movieId",
                                                       @"cast":@"cast"
                                                       }];
}

@end
