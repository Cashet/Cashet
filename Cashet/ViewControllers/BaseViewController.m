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
@property (nonatomic, retain) UILabel* noResultsView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *originalImage = [UIImage imageNamed:@"navigation bar background"];
    // scaling set to 2.0 makes the image 1/2 the size.
    self.navigationBarBackgroundImage =
    [UIImage imageWithCGImage:[originalImage CGImage]
                        scale:(originalImage.scale *  originalImage.size.width / self.view.frame.size.width)
                  orientation:(originalImage.imageOrientation)];
    
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
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
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

- (void)showErrorDialogWithButtonWithMessage:(NSString*)message callback:(void(^)())callback
{
    // Create the alert controller
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Timeout error" message:message preferredStyle:UIAlertControllerStyleAlert];

    // Create the actions
    UIAlertAction* close = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        callback();
    }];
    
    // Add the actions
    [alertController addAction:retry];
    [alertController addAction:close];
        
    // Present the controller
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}

- (void)noResultsViewHidden:(BOOL)hidden
{
    if (!self.noResultsView) {
        [self _createNoResultsView];
    }
    
    self.noResultsView.hidden = hidden;
}

- (void)_createNoResultsView
{
    NSString* text = @"No results";
    
    CGSize size = [text sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    double x = (self.view.frame.size.width - adjustedSize.width) / 2;
    double y = self.view.frame.origin.y + (self.view.frame.size.height - adjustedSize.height) / 2;
    
    self.noResultsView = [[UILabel alloc]initWithFrame:CGRectMake(x, y, adjustedSize.width, adjustedSize.height)];
    self.noResultsView.text = text;
    self.noResultsView.font = [UIFont systemFontOfSize:15];
    self.noResultsView.numberOfLines = 1;
    self.noResultsView.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    self.noResultsView.adjustsFontSizeToFitWidth = YES;
    self.noResultsView.minimumScaleFactor = 10.0f/12.0f;
    self.noResultsView.clipsToBounds = YES;
    self.noResultsView.backgroundColor = [UIColor clearColor];
    self.noResultsView.textColor = [UIColor whiteColor];
    self.noResultsView.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.noResultsView];
}

@end
