//
//  IWantThisViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 9/1/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "BaseViewController.h"

@interface IWantThisViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (retain, nonatomic) Product *product;

@end
