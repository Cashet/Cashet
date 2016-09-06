//
//  ServerListResponse.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ServerListResponse : JSONModel

@property(nonatomic, assign) BOOL success;
@property(nonatomic, retain) NSString* message;
@property(nonatomic, retain) NSArray* data;

- (id)initWithDictionary:(NSDictionary *)dict class:(Class)objectClass error:(NSError *__autoreleasing *)err;

@end
