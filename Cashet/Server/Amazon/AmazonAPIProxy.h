//
//  AmazonAPIProxy.h
//  Cashet
//
//  Created by Daniel Rodríguez on 9/6/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmazonResponse.h"

@interface AmazonAPIProxy : NSObject

+ (AmazonAPIProxy*)sharedInstance;

- (void)getProductsMatchingString:(NSString*)string category:(NSString*)category callback:(void(^)(AmazonResponse* response, NSError* error))callback;

- (void)getProductsMatchingString:(NSString*)string category:(NSString*)category page:(long)page callback:(void(^)(AmazonResponse* response, NSError* error))callback;

@end
