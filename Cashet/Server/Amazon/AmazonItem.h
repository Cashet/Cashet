//
//  AmazonItem.h
//  Cashet
//
//  Created by Daniel Rodríguez on 9/7/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXMLElement.h"

@interface AmazonItem : NSObject

@property(nonatomic, retain) NSString* detailPageURL;
@property(nonatomic, retain) NSString* manufacturer;
@property(nonatomic, retain) NSString* productGroup;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* lowestNewPriceFormatted;
@property(nonatomic, retain) NSString* imageURL;

- (id)initWithRXMLElement:(RXMLElement*)element;

@end
