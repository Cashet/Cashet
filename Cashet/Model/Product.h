//
//  Product.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/24/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Category.h"
#import "MoviedatabaseItem.h"

@interface Product : JSONModel

@property (nonatomic, retain) MoviedatabaseItem<Ignore>* movie;
@property (nonatomic, retain) MoviedatabaseItem<Ignore>* actor;

@property (nonatomic, retain) NSNumber<Optional>* productId;
@property (nonatomic, retain) NSNumber<Optional>* movieToken;
@property (nonatomic, retain) NSNumber<Optional>* actorToken;
@property (nonatomic, retain) NSString<Optional>* name;
@property (nonatomic, retain) NSString<Optional>* productDescription;
@property (nonatomic, retain) NSNumber<Optional>* price;
@property (nonatomic, retain) NSString<Optional>* picture;
@property (nonatomic, retain) NSString<Optional>* status;
@property (nonatomic, retain) NSNumber<Optional>* wants;
@property (nonatomic, retain) NSNumber<Optional>* known;
@property (nonatomic, retain) NSNumber<Optional>* created;
@property (nonatomic, retain) NSNumber<Optional>* updated;
@property (nonatomic, retain) Category<Optional>* category;
@property (nonatomic, retain) NSString<Optional>* amazonLink;
@property (nonatomic, retain) NSString<Optional>* amazonId;
@property (nonatomic, retain) NSNumber<Optional>* views;
@property (nonatomic, retain) NSString<Optional>* movieName;
@property (nonatomic, retain) NSString<Optional>* actorName;
@end
