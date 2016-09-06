//
//  SearchProductViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/10/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Product.h"

@interface IKnowWhatThisIsViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UISearchBar* searchBar;

@property (retain, nonatomic) Product *product;

@end
