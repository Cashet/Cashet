//
//  BuyProductViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 9/1/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "BuyProductViewController.h"

@implementation BuyProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.product.amazonPage]]];
}

@end
