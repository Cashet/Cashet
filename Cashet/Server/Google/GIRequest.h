//
//  GIRequest.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/8/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GIRequest <NSObject>

@end

@interface GIRequest : JSONModel

@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSNumber* totalResults;
@property(nonatomic, retain) NSString* searchTerms;
@property(nonatomic, retain) NSNumber* count;
@property(nonatomic, retain) NSNumber* startIndex;
@property(nonatomic, retain) NSString* cx;

@end
