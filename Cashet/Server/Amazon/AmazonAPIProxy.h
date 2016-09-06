//
//  AmazonAPIProxy.h
//  Cashet
//
//  Created by Daniel Rodríguez on 9/6/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmazonAPIProxy : NSObject

+ (AmazonAPIProxy*)sharedInstance;

- (void)getProductsMatchingString:(NSString*)string callback:(void(^)(id response, NSError* error))callback;

@end
