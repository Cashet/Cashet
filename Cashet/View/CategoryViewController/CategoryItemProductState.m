//
//  CategoryItemProductState.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/24/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "CategoryItemProductState.h"
#import "CategoryItemCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface CategoryItemProductState()

@property(weak, nonatomic) Product* model;
@property(weak, nonatomic) CategoryItemCollectionViewCell* view;

@end

@implementation CategoryItemProductState

- (void)setModel:(Product *)model
{
    _model = model;
    
    if (self.view) {
        [self _updateView];
    }
}

- (void)setView:(CategoryItemCollectionViewCell *)view
{
    _view = view;
    
    if (self.model) {
        [self _updateView];
    }
}

- (void)_updateView
{
    self.view.heartButton.hidden = YES;
    self.view.priceLabel.hidden = NO;
    self.view.descriptionLabel.text = self.model.productDescription;
    self.view.priceLabel.attributedText = [self _priceText];
    [self.view.imageView setImageWithURL:[NSURL URLWithString:self.model.picture]];
    [self.view.bottomButton setTitle:@"BUY PRODUCT" forState:UIControlStateNormal];
    [self.view.bottomButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [self.view.bottomButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
}

- (NSAttributedString*)_priceText
{
    NSString* price = [NSString stringWithFormat:@"$%@", self.model.price];
    
    NSString* fullText = [NSString stringWithFormat:@"Price: %@", price];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:fullText];
    
    NSRange range = [fullText rangeOfString: price];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont boldSystemFontOfSize:11]
                   range: range];
    
    return string;
}

- (NSString*)segueIdentifier
{
    return @"buy product";
}

@end
