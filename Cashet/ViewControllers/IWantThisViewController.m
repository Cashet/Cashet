//
//  IWantThisViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 9/1/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "IWantThisViewController.h"
#import "Server.h"

@implementation IWantThisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"I want this";
    
    self.titleLabel.text = self.product.productDescription;
    
    self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height/2;
    
    self.emailTextField.layer.cornerRadius = self.emailTextField.frame.size.height/2;
    
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
    [self showActivityIndicator];
    
    [[Server sharedInstance] favoriteProduct:self.product forUserWithEmail:self.emailTextField.text callback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

@end
