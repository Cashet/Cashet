//
//  ProductTableViewCell.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/18/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    self.labelContainerView.layer.cornerRadius = self.labelContainerView.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
