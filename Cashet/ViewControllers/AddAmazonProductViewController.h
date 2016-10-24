//
//  AddAmazonProductViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 10/21/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Product.h"

@interface AddAmazonProductViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UIView *selectCategoryContainerView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (nonatomic, retain) Product* product;

@end
