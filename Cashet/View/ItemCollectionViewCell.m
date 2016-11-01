//
//  ItemCollectionViewCell.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/17/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@interface ItemCollectionViewCell()

@property(nonatomic, retain) CAGradientLayer* gradient;

@end

@implementation ItemCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
        
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75] CGColor], nil];
    [self.productImageView.layer insertSublayer:self.gradient atIndex:0];
    //use startPoint and endPoint to change direction of gradient (http://stackoverflow.com/a/20387923/2057171)
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
