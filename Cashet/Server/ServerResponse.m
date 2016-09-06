//
//  ServerResponse.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "ServerResponse.h"

@implementation ServerResponse

- (id)initWithDictionary:(NSDictionary *)dict class:(Class)objectClass error:(NSError *__autoreleasing *)err
{
    self = [super init];
    
    if (self) {
        self.success = [dict[@"status"] isEqualToString:@"success"];
        
        if (self.success) {
            self.data = [[objectClass alloc] initWithDictionary:dict[@"data"] error:err];
            
        } else {
            self.message = dict[@"message"];
        }
    }
    
    return self;
}

@end
