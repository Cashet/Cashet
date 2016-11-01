//
//  MainViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "MainViewController.h"
#import "Item.h"
#import "MovieDatabaseAPIProxy.h"
#import "ItemCollectionViewCell.h"
#import "Server.h"
#import "ServerResponse.h"
#import "ServerListResponse.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BuyProductViewController.h"

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSArray<Item*>* trendingItems;
@property(nonatomic, retain) NSArray<Item*>* wantedItems;
@property(nonatomic, retain) NSMutableArray *dropdownItems;
@property(nonatomic, retain) NSMutableArray *filteredContentList;
@property(nonatomic, assign) BOOL isSearching;

@property(nonatomic, retain) NSArray<Product*>* wantedProducts;
@property(nonatomic, retain) NSArray<Product*>* trendingProducts;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.title = @"Ca$het";
    
    [self.tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_doSearch)]];
    
    self.trendingItems = [NSArray new];
    self.wantedProducts = [NSArray new];
    self.trendingProducts = [NSArray new];
    
    [self.tableView setTableFooterView: [[UIView alloc] initWithFrame: CGRectZero]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.trendingProducts.count == 0 && self.wantedProducts.count == 0) {
        [self noResultsViewHidden:NO];
    }
        
    [[Server sharedInstance] getTrendingProductsWithCallback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (error) {
            
            [self showErrorDialogWithMessage:error.localizedDescription];
            
        } else {
            self.trendingProducts = ((ServerListResponse*)response).data;
            
            if (self.trendingProducts.count != 0 || self.wantedProducts.count != 0) {
                [self noResultsViewHidden:YES];
            }
            
            [self.tableView reloadData];
        }
    }];
    
    [[Server sharedInstance] getWantedProductsWithCallback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (error) {
            [self showErrorDialogWithMessage:error.localizedDescription];
            
        } else {
            self.wantedProducts = ((ServerListResponse*)response).data;
            
            if (self.trendingProducts.count != 0 || self.wantedProducts.count != 0) {
                [self noResultsViewHidden:YES];
            }
            
            [self.tableView reloadData];
        }
    }];
}

- (void)_doSearch
{
    [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.trendingProducts.count;
        
    } else {
        return self.wantedProducts.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product* item = nil;
    
    if (indexPath.section == 0) {
        item = self.trendingProducts[indexPath.row];
        
    } else {
        item = self.wantedProducts[indexPath.row];
    }
    
    ItemCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.productImageView setImageWithURL:[NSURL URLWithString:item.picture]];
    cell.movieLabel.text = item.movieName;
    cell.actorLabel.text = item.actorName;
    cell.viewCountLabel.text = item.views ? [item.views stringValue] : @"0";
    cell.itemLabel.text = item.category.name;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

// Note:
//            1) Must subclass UITableViewHeaderFooterView
//            1) [self.tableView registerNib:[UINib nibWithNibName:@"YourNibName" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SectionIdentifier"];
//
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"header"];
    
    UIImageView* imageView = [cell viewWithTag:100];
    [imageView setImage:[UIImage imageNamed:section == 0 ? @"star" : @"heart"]];
    
    UILabel* label = [cell viewWithTag:200];
    label.text = section == 0 ? @"Trending Items" : @"Wanted Items";
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product* item = nil;
    
    if (indexPath.section == 0) {
        item = self.trendingProducts[indexPath.row];
        
    } else {
        item = self.wantedProducts[indexPath.row];
    }
    
    if (item.amazonLink && ![item.amazonLink isEqualToString:@""]) {
        Product* item = self.trendingProducts[indexPath.row];
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BuyProductViewController* vc =[storyboard instantiateViewControllerWithIdentifier:@"BuyProductViewController"];
        vc.product = item;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


@end
