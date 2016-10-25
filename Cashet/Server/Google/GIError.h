//
//  GIError.h
//  Cashet
//
//  Created by Daniel Rodríguez on 10/25/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GIError <NSObject>

@end

@interface GIError : JSONModel

@property(nonatomic, retain) NSNumber<Optional>* code;
@property(nonatomic, retain) NSString<Optional>* domain;
@property(nonatomic, retain) NSString<Optional>* message;
@property(nonatomic, retain) NSString<Optional>* reason;
@property(nonatomic, retain) NSArray<GIError, Optional>* errors;

@end
