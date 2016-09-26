//
//  Category.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Category : JSONModel

@property(nonatomic, retain) NSNumber<Optional>* categoryId;
@property(nonatomic, retain) NSNumber<Optional>* parentId;
@property(nonatomic, retain) NSString<Optional>* name;
@property(nonatomic, retain) NSString<Optional>* picture;
@property(nonatomic, retain) NSNumber<Optional>* products;

@end
