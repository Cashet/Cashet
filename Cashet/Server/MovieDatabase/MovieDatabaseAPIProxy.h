//
//  DatabaseAPIProxy.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieDatabaseAPIProxy : NSObject

+ (MovieDatabaseAPIProxy*)sharedInstance;

+ (NSString*)fullpathForLargeImage:(NSString*)relativePath;
+ (NSString*)fullpathForThumbnailImage:(NSString*)relativePath;

- (void)getActorsAndMoviesForString:(NSString*)string callback:(void(^)(id response, NSError* error))callback;
- (void)getCastForMovie:(long)movieId callback:(void(^)(id response, NSError* error))callback;
- (void)getCastForTv:(long)tvId callback:(void(^)(id response, NSError* error))callback;
- (void)getMoviesForActor:(long)actorId callback:(void(^)(id response, NSError* error))callback;

@end
