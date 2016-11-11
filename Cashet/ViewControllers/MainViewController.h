//
//  MainViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MainViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *trendingCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *wantedCollectionView;
@property (weak, nonatomic) IBOutlet UIView *tapView;

@end
