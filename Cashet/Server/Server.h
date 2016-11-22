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

- (void)getCategoriesForActor:(NSNumber*)actorId movie:(NSNumber*)movieId callback:(void(^)(id response, NSError* error))callback;
- (void)getCategoriesCallback:(void(^)(id response, NSError* error))callback;
- (void)postProduct:(Product*)product callback:(void(^)(id response, NSError* error))callback;
- (void)updateProduct:(Product*)product callback:(void(^)(id response, NSError* error))callback;
- (void)getProductsForActor:(MoviedatabaseItem*)actor movie:(MoviedatabaseItem*)movie category:(Category*)category callback:(void(^)(id response, NSError* error))callback;
- (void)favoriteProduct:(Product*)product forUserWithEmail:(NSString*)email callback:(void(^)(id response, NSError* error))callback;
- (void)getTrendingProductsWithCallback:(void(^)(id response, NSError* error))callback;
- (void)getWantedProductsWithCallback:(void(^)(id response, NSError* error))callback;
- (void)setViewsForProduct:(Product*)product callback:(void(^)(id response, NSError* error))callback;

@end
