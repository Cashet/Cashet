//
//  SelectGoogleImageViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/29/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviedatabaseItem.h"
#import "BaseViewController.h"
#import "Category.h"

@interface RequestProductViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *selectCategoryContainerView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (nonatomic, retain) MoviedatabaseItem* actor;
@property (nonatomic, retain) MoviedatabaseItem* movie;
@property (nonatomic, retain) Category* category;

@end
