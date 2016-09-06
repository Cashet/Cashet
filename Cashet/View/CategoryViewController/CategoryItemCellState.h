//
//  CategoryItemCellState.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/24/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryItemCollectionViewCell.h"
#import "Product.h"

@class CategoryItemCollectionViewCell;

@protocol CategoryItemCellState <NSObject>

- (void)setView:(CategoryItemCollectionViewCell*)cell;
- (void)setModel:(Product*)model;
- (NSString*)segueIdentifier;

@end
