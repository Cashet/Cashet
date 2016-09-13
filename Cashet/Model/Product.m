//
//  Product.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/24/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "Product.h"

@implementation Product

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
#pragma mark - TEST
    self = [super initWithDictionary:dict error:err];
    
    return self;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"product_id":@"productId",
                                                       @"movie_token":@"movieToken",
                                                       @"actor_token":@"actorToken",
                                                       @"name":@"name",
                                                       @"description":@"productDescription",
                                                       @"price":@"price",
                                                       @"picture":@"picture",
                                                       @"status":@"status",
                                                       @"wants":@"wants",
                                                       @"known":@"known",
                                                       @"created":@"created",
                                                       @"updated":@"updated",
                                                       @"category":@"category",
                                                       @"amazon_link":@"amazonLink",
                                                       @"amazon_id":@"amazonId"
                                                       }];
}

@end
