//
//  GIItem.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/8/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GIImage.h"

@protocol GIItem <NSObject>

@end

@interface GIItem : JSONModel

@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* mime;
@property(nonatomic, retain) NSString* link;

@end
