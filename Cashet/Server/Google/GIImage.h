//
//  GIImage.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/8/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GIImage : JSONModel

@property(nonatomic, retain) NSString* thumbnailLink;
@property(nonatomic, retain) NSString* thumbnailHeight;
@property(nonatomic, retain) NSString* thumbnailWidth;

@end
