//
//  GoogleImageCell.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/29/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "GoogleImageCell.h"

@implementation GoogleImageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapped:)];
//    tapGesture.cancelsTouchesInView = NO;
//    [self addGestureRecognizer:tapGesture];
}

- (IBAction)_tapped:(id)sender
{
    self.selected = !self.selected;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.overlayView.hidden = !self.selected;
    self.tickIconImageView.hidden = !self.selected;
}

@end
