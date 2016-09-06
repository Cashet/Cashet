//
//  MoviedatabaseItem.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/17/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>
#import "MoviedatabaseItem.h"

@protocol MoviedatabaseItem <NSObject>

@end

@interface MoviedatabaseItem : JSONModel

@property(nonatomic, retain) NSArray<MoviedatabaseItem, Optional>* knownFor;
@property(nonatomic, retain) NSString<Optional>* profilePath;
@property(nonatomic, retain) NSString<Optional>* posterPath;
@property(nonatomic, retain) NSString<Optional>* name;
@property(nonatomic, retain) NSString<Optional>* mediaType;
@property(nonatomic, retain) NSString<Optional>* title;
@property(nonatomic, retain) NSNumber<Optional>* identifier;
@property(nonatomic, retain) NSString<Optional>* character;

@end
