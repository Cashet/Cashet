//
//  RequestProductContainerView.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/25/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "RequestProductContainerView.h"

@interface RequestProductContainerView()

@property (nonatomic, retain) CAGradientLayer* gradient;

@end

@implementation RequestProductContainerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    self.gradient.startPoint = CGPointMake(0.5, 1);
    //    CGFloat percentage = self.navigationController.navigationBar.frame.size.height / self.overlayView.frame.size.height * 0.75;
    self.gradient.endPoint = CGPointMake(0.5, 0);
    
    [self.layer insertSublayer:self.gradient atIndex:0];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    return hitView;
}

@end
