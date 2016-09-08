//
//  BuyProductViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 9/1/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Product.h"

@interface BuyProductViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (retain, nonatomic) Product *product;

@end
