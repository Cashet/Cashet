//
//  ItemCollectionViewCell.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/17/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "ItemCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ItemCollectionViewCell() <UIGestureRecognizerDelegate>

@property(nonatomic, retain) CAGradientLayer* gradient;

@end

@implementation ItemCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
        
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = CGRectMake(0, self.bounds.size.height* 2/3, self.bounds.size.width, self.bounds.size.height/3);
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.gradientContainerView.layer insertSublayer:self.gradient atIndex:0];
    //use startPoint and endPoint to change direction of gradient (http://stackoverflow.com/a/20387923/2057171)
}

- (IBAction)topBarTouched:(id)sender
{
    if (self.delegate) {
        [self.delegate movieTouched:self.product];
    }
}

- (IBAction)touchedProduct:(id)sender
{
    if (self.delegate) {
        [self.delegate productTouched:self.product];
    }
}

- (IBAction)touchedActor:(id)sender
{
    if (self.delegate) {
        [self.delegate actorTouched:self.product];
    }
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    [self.gradient removeFromSuperlayer];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = CGRectMake(0, self.bounds.size.height* 2/3, self.bounds.size.width, self.bounds.size.height/3);
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.gradientContainerView.layer insertSublayer:self.gradient atIndex:0];
}

- (void)setProduct:(Product *)product
{
    _product = product;
    
    [self.productImageView setImageWithURL:[NSURL URLWithString:product.picture]];
    [self.actorImageView setImageWithURL:[NSURL URLWithString:product.actorImage]];
    self.movieLabel.text = product.movieName;
    self.actorLabel.text = product.actorName;
    self.viewCountLabel.text = product.views ? [product.views stringValue] : @"0";
    self.itemLabel.text = product.category.name;
}

@end
