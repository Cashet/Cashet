//
//  Category.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "Category.h"

@implementation Category

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    
    return self;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"category_id":@"categoryId",
                                                       @"name":@"name",
                                                       @"parent_id":@"parentId",
                                                       @"picture":@"picture",
                                                       @"products":@"products"
                                                       }];
}

@end
