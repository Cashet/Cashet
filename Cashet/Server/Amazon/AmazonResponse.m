//
//  AmazonResponse.m
//  Cashet
//
//  Created by Daniel Rodríguez on 9/7/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "AmazonResponse.h"
#import "RXMLElement.h"

@implementation AmazonResponse

- (id)initWithString:(NSString*)string
{
    self = [super init];
    
    if (self) {
        RXMLElement *rootXML = [RXMLElement elementFromXMLString:string encoding:NSUTF8StringEncoding];
        //             [rootXML attribute:@"totalpages"];
        RXMLElement *itemsRoot = [rootXML child:@"Items"];
        self.totalPages = [itemsRoot child:@"TotalPages"].textAsInt;
        self.totalResults = [itemsRoot child:@"TotalResults"].textAsInt;
        NSArray *items = [itemsRoot children:@"Item"];
        
        NSMutableArray* parsedItems = [NSMutableArray new];
        
        for (RXMLElement* element in items) {
            [parsedItems addObject:[[AmazonItem alloc] initWithRXMLElement:element]];
        }
        
        self.items = parsedItems;
    }
    
    return self;
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"{\n\tTotalPages: %ld,\n\tTotalResults: %ld,\n\tItems: %@\n}", self.totalPages, self.totalResults, self.items];
}

- (NSString*)description
{
    return [self debugDescription];
}

@end
