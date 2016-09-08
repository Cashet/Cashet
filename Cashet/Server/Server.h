//
//  Server.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/7/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "MoviedatabaseItem.h"

@interface Server : NSObject

+ (Server*)sharedInstance;

- (void)getTrendingItems:(void(^)(id response, NSError* error))callback;
- (void)getWantedItems:(void(^)(id response, NSError* error))callback;
- (void)getCategoriesCallback:(void(^)(id response, NSError* error))callback;
- (void)postProduct:(Product*)product callback:(void(^)(id response, NSError* error))callback;
- (void)getProductsForActor:(MoviedatabaseItem*)actor movie:(MoviedatabaseItem*)movie category:(Category*)category callback:(void(^)(id response, NSError* error))callback;

@end
