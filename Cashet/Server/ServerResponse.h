//
//  ServerResponse.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ServerResponse : NSObject

@property(nonatomic, assign) BOOL success;
@property(nonatomic, retain) NSString* message;
@property(nonatomic, retain) id data;

- (id)initWithDictionary:(NSDictionary *)dict class:(Class)objectClass error:(NSError *__autoreleasing *)err;

@end
