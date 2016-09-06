//
//  BaseViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "BaseViewController.h"
#import <JGProgressHUD.h>

@interface BaseViewController () <UIGestureRecognizerDelegate>

@property(nonatomic, retain) JGProgressHUD *HUD;
@property(nonatomic, retain) UIView *darkOverlay;
@property(nonatomic, assign) int counter;
@property(nonatomic, retain) UIImage* navigationBarBackgroundImage;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarBackgroundImage = [UIImage imageNamed:@"navigation bar background"];
    
    _darkOverlay = [[UIView alloc] initWithFrame:self.view.frame];
    [_darkOverlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    
    CGRect frame = self.view.frame;
    CGRect anotherFrame = [UIApplication sharedApplication].keyWindow.frame;
    CGFloat scaleX = anotherFrame.size.width / frame.size.width;
    CGFloat scaleY = anotherFrame.size.height / frame.size.height;
    
    if(scaleX > 1 && scaleY > 1) {
        self.view.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    }
    
    [self _setCloseKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    [self.navigationController.navigationBar setBackgroundImage:self.navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)_setCloseKeyboard
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = NO;
    
    [self.navigationController.navigationBar addGestureRecognizer:tap];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self dismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showActivityIndicator
{
    @synchronized(self)
    {
        [self showDarkOverlay];
        
        _counter++;
        
        if (_counter == 1) {
            self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            _HUD.square = YES;
            [_HUD showInView:self.view animated:YES];
        }
    }
}

- (void)showDarkOverlay
{
    [self.view addSubview:_darkOverlay];
}

- (void)hideDarkOverlay
{
    [_darkOverlay removeFromSuperview];
}

- (void)hideActivityIndicator
{
    @synchronized(self)
    {
        _counter--;
        
        if (_counter <= 0) {
            [self hideDarkOverlay];
            [_HUD dismiss];
            _HUD = nil;
            _counter = 0;
        }
    }
}

- (void)showErrorDialogWithMessage:(NSString*)errorMessage
{
    if (self.HUD) {
        [self.HUD dismiss];
    }
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = errorMessage;
    self.HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
    [self.HUD showInView:self.view];
    self.HUD.userInteractionEnabled = NO;
    [self.HUD dismissAfterDelay:2.0];
}


@end
