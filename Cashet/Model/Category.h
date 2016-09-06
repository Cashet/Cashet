//
//  Category.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Category : JSONModel

@property(nonatomic, retain) NSNumber* categoryId;
@property(nonatomic, retain) NSNumber* parentId;
@property(nonatomic, retain) NSString* name;

@end
