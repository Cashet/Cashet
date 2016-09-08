//
//  AmazonItem.m
//  Cashet
//
//  Created by Daniel Rodríguez on 9/7/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "AmazonItem.h"

@implementation AmazonItem

- (id)initWithRXMLElement:(RXMLElement*)element
{
    self = [super init];
    
    if (self) {
        self.detailPageURL = [element child:@"DetailPageURL"].text;
        self.imageURL = [[element child:@"LargeImage"] child:@"URL"].text;
        
        RXMLElement* attributes = [element child:@"ItemAttributes"];
        self.manufacturer = [attributes child:@"Manufacturer"].text;
        self.productGroup = [attributes child:@"ProductGroup"].text;
        self.title = [attributes child:@"Title"].text;
        
        self.lowestNewPriceFormatted = [[[element child:@"OfferSummary"] child:@"LowestNewPrice"] child:@"FormattedPrice"].text;
    }
    
    return self;
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"{\n\tTitle: %@\n\tManufacturer: %@\n\tProductGroup: %@\n\tLowest new price: %@\n\tImage URL: %@\n\tDetailPageURL: %@\n}", self.title, self.manufacturer, self.productGroup, self.lowestNewPriceFormatted, self.imageURL, self.detailPageURL];
}

- (NSString*)description
{
    return [self debugDescription];
}

@end
