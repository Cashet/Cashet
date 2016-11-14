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

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ItemCollectionViewCellDelegate>

@property(nonatomic, retain) NSArray<Product*>* wantedProducts;
@property(nonatomic, retain) NSArray<Product*>* trendingProducts;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.title = @"Ca$het";
    
    [self.tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_doSearch)]];
    
    self.trendingProducts = [NSArray new];
    self.wantedProducts = [NSArray new];
    
    self.trendingCollectionView.allowsSelection = NO;
    self.wantedCollectionView.allowsSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Server sharedInstance] getTrendingProductsWithCallback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (error) {
            [self showErrorDialogWithMessage:error.localizedDescription];
            
        } else {
            self.trendingProducts = ((ServerListResponse*)response).data;
            
            [self.trendingCollectionView reloadData];
        }
    }];
    
    [[Server sharedInstance] getWantedProductsWithCallback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (error) {
            [self showErrorDialogWithMessage:error.localizedDescription];
            
        } else {
            self.wantedProducts = ((ServerListResponse*)response).data;
                       
            [self.wantedCollectionView reloadData];
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
    if (collectionView == self.trendingCollectionView) {
        return self.trendingProducts.count;
        
    } else {
        return self.wantedProducts.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product* item = nil;
    
    if (collectionView == self.trendingCollectionView) {
        item = self.trendingProducts[indexPath.row];
        
    } else {
        item = self.wantedProducts[indexPath.row];
    }

    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.product = item;
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width*2/3 - 30, collectionView.frame.size.height);
}

#pragma mark - ItemCollectionViewCellDelegate
- (void)productTouched:(Product*)product
{
    if (product.amazonLink && ![product.amazonLink isEqualToString:@""]) {

        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BuyProductViewController* vc =[storyboard instantiateViewControllerWithIdentifier:@"BuyProductViewController"];
        vc.product = product;

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)actorTouched:(Product*)product
{
    
}

- (void)movieTouched:(Product*)product
{
    
}

@end
