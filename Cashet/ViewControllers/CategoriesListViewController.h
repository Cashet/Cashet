//
//  CategoriesListViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/29/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "BaseViewController.h"

@protocol CategoriesListViewControllerDelegate <NSObject>

- (void)selectedCategory:(Category*)category;

@end

@interface CategoriesListViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) NSArray<Category*> *categories;
@property (nonatomic, weak) id<CategoriesListViewControllerDelegate> delegate;

@end
