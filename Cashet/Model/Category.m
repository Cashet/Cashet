//
//  Category.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "Category.h"

@implementation Category

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"category_id":@"categoryId",
                                                       @"name":@"name",
                                                       @"parent_id":@"parentId"
                                                       }];
}

@end
