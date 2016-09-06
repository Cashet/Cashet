//
//  IWantThisViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 9/1/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "IWantThisViewController.h"

@implementation IWantThisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"I want this";
    
    self.titleLabel.text = self.product.productDescription;
    
    self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height/2;
    
    [self _setupEmailTextField];
}

- (void)_setupEmailTextField
{
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 30)];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"envelope"]];
    icon.frame = CGRectMake(16, 10, 13, 10);
    
    [containerView addSubview:icon];
    
    self.emailTextField.leftView = containerView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - IBActions
- (IBAction)submitButtonClicked:(id)sender
{
#pragma mark - Submit
}

@end
