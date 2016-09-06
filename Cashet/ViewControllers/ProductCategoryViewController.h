//
//  CategoryViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "MoviedatabaseItem.h"
#import "BaseViewController.h"

@interface ProductCategoryViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIView *requestProductContainerView;
@property (weak, nonatomic) IBOutlet UIButton *requestProductButton;

@property (weak, nonatomic) Category *category;
@property (weak, nonatomic) MoviedatabaseItem *movie;
@property (weak, nonatomic) MoviedatabaseItem *actor;

@end
