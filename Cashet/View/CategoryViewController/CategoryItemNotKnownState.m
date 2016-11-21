//
//  CategoryItemNotKnownState.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/24/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "CategoryItemNotKnownState.h"
#import "CategoryItemCollectionViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface CategoryItemNotKnownState()

@property(weak, nonatomic) Product* model;
@property(weak, nonatomic) CategoryItemCollectionViewCell* view;

@end

@implementation CategoryItemNotKnownState

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
    self.view.heartButton.hidden = NO;
    self.view.descriptionLabel.attributedText = [self _descriptionText];
    self.view.priceLabel.hidden = YES;
    self.view.productNameContainerView.hidden = (self.model.picture != nil);
    if (self.model.picture) {
        [self.view.imageView setImageWithURL:[NSURL URLWithString:self.model.picture]];
        
    } else {
        self.view.productNameLabel.text = self.model.name;
    }
    
    [self.view.bottomButton setTitle:@"I KNOW WHAT THIS IS" forState:UIControlStateNormal];
    [self.view.bottomButton setImage:[UIImage imageNamed:@"aim"] forState:UIControlStateNormal];
    [self.view.bottomButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
}

//- (void)setView:(CategoryItemCollectionViewCell*)cell;
//- (void)setModel:(NSDictionary*)model;

- (NSAttributedString*)_descriptionText
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Sorry, we don't know\nwhich product is"];
    
    [text addAttribute:NSFontAttributeName
                   value:[UIFont italicSystemFontOfSize:11]
                   range: NSMakeRange(0, text.length)];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.5]
                 range: NSMakeRange(0, text.length)];
    
    return text;
}

- (NSString*)segueIdentifier
{
    return @"I know what this is";
}

@end
