//
//  CategoryItemCollectionViewCell.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "CategoryItemCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "MovieDatabaseAPIProxy.h"

@implementation CategoryItemCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bottomButton.layer.cornerRadius = self.bottomButton.frame.size.height/2;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.productNameContainerView.layer.cornerRadius = self.productNameContainerView.frame.size.height / 2;
}

- (void)setState:(id<CategoryItemCellState>)state
{
    _state = state;
    [_state setView:self];
    
    if (self.model) {
        [_state setModel:self.model];
    }
}

- (void)setModel:(Product *)model
{
    _model = model;
    
    if (self.state) {
        [self.state setModel:_model];
    }
}

@end
