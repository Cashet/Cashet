//
//  AmazonResponse.h
//  Cashet
//
//  Created by Daniel Rodríguez on 9/7/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmazonItem.h"

@interface AmazonResponse : NSObject

@property(nonatomic, assign) long totalPages;
@property(nonatomic, assign) long totalResults;
@property(nonatomic, retain) NSArray<AmazonItem*>* items;

- (id)initWithString:(NSString*)string;

@end
