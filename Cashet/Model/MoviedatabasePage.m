//
//  ActorsPage.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "MoviedatabasePage.h"

@implementation MoviedatabasePage

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"page":@"page",
                                                       @"results":@"results",
                                                       @"total_results":@"totalResults",
                                                       @"total_pages":@"totalPages"
                                                       }];
}

@end
