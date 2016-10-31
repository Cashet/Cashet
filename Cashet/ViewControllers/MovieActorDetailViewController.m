//
//  ItemDetailViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/18/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "MovieActorDetailViewController.h"
#import "MoviedatabaseItem.h"
#import "ProductCategoryTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "MovieDatabaseAPIProxy.h"
#import "Server.h"
#import "ServerListResponse.h"
#import "Category.h"
#import "ProductCategoryViewController.h"
#import "CastCollection.h"
#import "AddAmazonProductViewController.h"

@interface MovieActorDetailViewController() <ProductCategoryTableViewCellDelegate>

@property (retain, nonatomic) UIImage* image;
@property (retain, nonatomic) NSArray<Category*>* categories;
@property (retain, nonatomic) Category* selectedCategory;
@property (retain, nonatomic) NSIndexPath* selectedIndexPath;

@end

@implementation MovieActorDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.image = [UIImage new];
    
    [self _setImage];
    
    self.titleLabel.text = [self _title];
    self.subtitleLabel.text = [self _subtitle];
}

- (void)_setImage
{
    NSString* posterPath = [self.mainItem.mediaType isEqualToString:@"person"] ? self.mainItem.profilePath : self.mainItem.posterPath;

    [self.imageView setImageWithURL:[NSURL URLWithString:[MovieDatabaseAPIProxy fullpathForLargeImage:posterPath]]];
}

- (NSString*)_title
{
    if([self.mainItem.mediaType isEqualToString:@"movie"]) {
        return self.mainItem.title;
        
    } else {
        return self.mainItem.name;
    }
}

- (NSString*)_subtitle
{
    if([self.mainItem.mediaType isEqualToString:@"person"]) {
        return [NSString stringWithFormat:@"%ld Movie%@", self.items.count, self.items.count > 0 ? @"s" : @""];
        
    } else {
        return [NSString stringWithFormat:@"%ld Actor%@", self.items.count, self.items.count > 0 ? @"s" : @""];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:self.image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = self.image;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = self.view.frame.size.width / 320;
    
    return 110 * scale;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.moviedatabaseItem = self.items[indexPath.section];
    
    MoviedatabaseItem* actor;
    MoviedatabaseItem* movie;
    
    if ([self.mainItem.mediaType isEqualToString:@"person"]) {
        actor = self.mainItem;
        movie = self.items[indexPath.section];
        
    } else {
        actor = self.items[indexPath.section];
        movie = self.mainItem;
    }
    
    [[Server sharedInstance] getCategoriesForActor:actor.identifier movie:movie.identifier callback:^(id response, NSError *error) {
        
        ServerListResponse* serverResponse = response;
        
        if (!error) {
            if (serverResponse.success) {
                cell.items = serverResponse.data;
                
            } else {
                cell.items = [NSArray new];
                
                [self showErrorDialogWithMessage:serverResponse.message];
            }
            
        } else {
            cell.items = [NSArray new];
            
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell* header = [tableView dequeueReusableCellWithIdentifier:@"header"];
    UILabel* label = [header viewWithTag:100];
    label.text = [self _sectionTitleForSectionIndex:section];
    
    return header;
}

- (NSString*)_sectionTitleForSectionIndex:(NSInteger)index
{
    MoviedatabaseItem* item = self.items[index];
    
    if ([item.mediaType isEqualToString:@"movie"]) {
        return item.title;
        
    } else if ([item.mediaType isEqualToString:@"tv"]) {
        return item.name;
        
    } else {
        return [NSString stringWithFormat:@"%@ as %@", item.name, item.character];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProductCategoryViewController* vc = segue.destinationViewController;
    vc.category = self.selectedCategory;
    
    if ([self.mainItem.mediaType isEqualToString:@"person"]) {
        vc.actor = self.mainItem;
        vc.movie = self.items[self.selectedIndexPath.section];
        
    } else {
        vc.actor = self.items[self.selectedIndexPath.section];
        vc.movie = self.mainItem;
    }
}

#pragma mark - ProductCategoryTableViewCellDelegate
- (void)productCategoryTableViewCell:(ProductCategoryTableViewCell*)cell didSelectCategory:(Category*)category
{
    self.selectedCategory = category;
    self.selectedIndexPath = cell.indexPath;
    
    [self performSegueWithIdentifier:@"showCategory" sender:self];
}

- (void)productCategoryTableViewCell:(ProductCategoryTableViewCell *)cell addAmazonProductForMoviedatabaseItem:(MoviedatabaseItem *)item
{
    Product* product = [Product new];

    if ([self.mainItem.mediaType isEqualToString:@"person"]) {
        product.actor = self.mainItem;
        product.movie = item;
        
    } else {
        product.actor = item;
        product.movie = self.mainItem;
    }
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAmazonProductViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"AddAmazonProductViewController"];
    vc.product = product;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)productCategoryTableViewCell:(ProductCategoryTableViewCell *)cell moviedatabaseItem:(MoviedatabaseItem *)item
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    MovieActorDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ItemDetailViewController"];
    vc.mainItem = item;
    
    [self showActivityIndicator];
    
    if ([item.mediaType isEqualToString:@"movie"]) {
        
        [[MovieDatabaseAPIProxy sharedInstance] getCastForMovie:item.identifier.longValue callback:^(id response, NSError *error) {
            
            [self hideActivityIndicator];
            
            if (!error) {
                vc.items = ((CastCollection*)response).cast;
                item.mediaType = @"movie";
                
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }];
        
    } else if ([item.mediaType isEqualToString:@"tv"]) {
        
        [[MovieDatabaseAPIProxy sharedInstance] getCastForTv:item.identifier.longValue callback:^(id response, NSError *error) {
            
            [self hideActivityIndicator];
            
            if (!error) {
                vc.items = ((CastCollection*)response).cast;
                item.mediaType = @"tv";
                
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }];
        
    } else {
        
        [[MovieDatabaseAPIProxy sharedInstance] getMoviesForActor:item.identifier.longValue callback:^(id response, NSError *error) {
            
            [self hideActivityIndicator];
            
            if (!error) {
                vc.items = ((CastCollection*)response).cast;
                item.mediaType = @"person";
                
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }];
    }
}

@end
