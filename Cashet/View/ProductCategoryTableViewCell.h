//
//  ProductCategoryTableViewCell.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/18/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "MoviedatabaseItem.h"

@class ProductCategoryTableViewCell;

@protocol ProductCategoryTableViewCellDelegate <NSObject>

- (void)productCategoryTableViewCell:(ProductCategoryTableViewCell*)cell didSelectCategory:(Category*)category;
- (void)productCategoryTableViewCell:(ProductCategoryTableViewCell*)cell moviedatabaseItem:(MoviedatabaseItem*)item;

@end

@interface ProductCategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSArray<Category*>* items;

@property (retain, nonatomic) id<ProductCategoryTableViewCellDelegate> delegate;
@property (retain, nonatomic) NSIndexPath* indexPath;
@property (retain, nonatomic) MoviedatabaseItem* moviedatabaseItem;

@end
