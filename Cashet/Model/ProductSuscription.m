//
//  ProductSuscription.m
//  Cashet
//
//  Created by Daniel Rodríguez on 9/12/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "ProductSuscription.h"

@implementation ProductSuscription

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"suscription_id":@"suscriptionId"
                                                       }];
}

@end
