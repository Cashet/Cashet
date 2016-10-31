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

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

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
            
            [self.collectionView reloadData];
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
            
            [self.collectionView reloadData];
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.trendingProducts.count;
        
    } else {
        return self.wantedProducts.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product* item = nil;
    
    if (indexPath.section == 0) {
        item = self.trendingProducts[indexPath.row];
        
    } else {
        item = self.wantedProducts[indexPath.row];
    }

    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL:[NSURL URLWithString:item.picture]];
    cell.movieLabel.text = item.movieName;
    cell.actorLabel.text = item.actorName;
    cell.viewCountLabel.text = item.views ? [item.views stringValue] : @"0";
    cell.itemLabel.text = item.category.name;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:@"header"
                                                                               forIndexPath:indexPath];
    
    UIImageView* imageView = [cell viewWithTag:100];
    [imageView setImage:[UIImage imageNamed:indexPath.section == 0 ? @"star" : @"heart"]];
    
    UILabel* label = [cell viewWithTag:200];
    label.text = indexPath.section == 0 ? @"Trending Items" : @"Wanted Items";
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGSize size = CGSizeMake(screenWidth, screenWidth * 107 / 160);
    
    return size;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
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

@end
