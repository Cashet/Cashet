//
//  BaseViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property(nonatomic, assign) BOOL visible;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showDarkOverlay;
- (void)hideDarkOverlay;
- (void)showErrorDialogWithMessage:(NSString*)errorMessage;
- (void)noResultsViewHidden:(BOOL)hidden;

@end
