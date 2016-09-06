//
//  SearchMoviewActorViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchMovieActorViewController : BaseViewController

@property(nonatomic, weak) IBOutlet UISearchBar* searchBar;
@property(nonatomic, weak) IBOutlet UITableView* tableView;

@end
