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
    self.gradient.frame = CGRectMake(0, self.bounds.size.height* 2/3, self.bounds.size.width, self.bounds.size.height/3);
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.imageView.layer insertSublayer:self.gradient atIndex:0];
    //use startPoint and endPoint to change direction of gradient (http://stackoverflow.com/a/20387923/2057171)
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    [self.gradient removeFromSuperlayer];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = CGRectMake(0, self.bounds.size.height* 2/3, self.bounds.size.width, self.bounds.size.height/3);
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.imageView.layer insertSublayer:self.gradient atIndex:0];
}

@end
