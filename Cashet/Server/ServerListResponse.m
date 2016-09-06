//
//  ServerListResponse.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "ServerListResponse.h"

@implementation ServerListResponse

- (id)initWithDictionary:(NSDictionary *)dict class:(Class)objectClass error:(NSError *__autoreleasing *)err
{
    self = [super init];
    
    if (self) {
        self.success = [dict[@"status"] isEqualToString:@"success"];
        
        if (self.success) {
            NSArray* array = dict[@"data"];
            
            NSMutableArray* data = [NSMutableArray new];
            
            for (NSDictionary* item in array) {
                [data addObject:[[objectClass alloc] initWithDictionary:item error:err]];
                
                if (*err) {
                    break;
                }
            }
            
            self.data = data;
            
        } else {
            self.message = dict[@"message"];
        }
    }
    
    return self;
}

@end
