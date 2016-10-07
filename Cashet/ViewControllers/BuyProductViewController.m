//
//  BuyProductViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 9/1/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "BuyProductViewController.h"

@interface BuyProductViewController() <UIWebViewDelegate>

@property (retain, nonatomic) UIImage* image;

@end

@implementation BuyProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.image = [UIImage new];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.product.amazonLink]]];
    
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:self.image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = self.image;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:35/255.0f green:47/255.0f blue:62/255.0f alpha:1];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self showActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self hideActivityIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self hideActivityIndicator];
}

@end
