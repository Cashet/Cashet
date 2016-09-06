//
//  GoogleAPIProxy.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/30/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAPIProxy : NSObject

+ (GoogleAPIProxy*)sharedInstance;

- (void)getImagesForString:(NSString*)string callback:(void(^)(id response, NSError* error))callback;
- (void)getImagesForString:(NSString*)string startIndex:(long)startIndex callback:(void(^)(id response, NSError* error))callback;

@end
