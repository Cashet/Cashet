//
//  CheckButton.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "CheckButton.h"

@implementation CheckButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor: [UIColor whiteColor]];
    
    self.layer.cornerRadius = self.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    [self setBackgroundColor:selected ? [UIColor colorWithRed:130/255.0f green:25/255.0f blue:10/255.0f alpha:1] : [UIColor whiteColor]];
}

@end
