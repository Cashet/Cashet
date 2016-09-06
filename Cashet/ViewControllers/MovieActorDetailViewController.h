//
//  ItemDetailViewController.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/18/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MoviedatabaseItem.h"
#import "CastCollection.h"
#import "MovieActorDetailViewController.h"

@interface MovieActorDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (retain, nonatomic) MoviedatabaseItem* mainItem;
@property (retain, nonatomic) NSArray* items;

@end
