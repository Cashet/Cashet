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
    
    self.amazonPage = @"http://www.amazon.com/Japanese-Crafts-Sakura-Asymmetry-Butterfly/dp/B019I9LLSS%3FSubscriptionId%3DAKIAIEQ667UNZWS76SXQ%26tag%3Dcashet-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB019I9LLSS";
    
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
                                                       @"category":@"category"
                                                       }];
}

@end
