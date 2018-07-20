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
#import "MovieActorDetailViewController.h"
#import "AmazonAPIProxy.h"

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
    
    [self _getTrendingProducts];
    [self _getWantedProducts];
}

- (void)_getTrendingProducts
{
    [[Server sharedInstance] getTrendingProductsWithCallback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (error) {
            if (error.code == NSURLErrorTimedOut) {
                [self showErrorDialogWithButtonWithMessage:error.localizedDescription callback:^{
                    [self _getTrendingProducts];
                }];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
            
        } else {
            self.trendingProducts = ((ServerListResponse*)response).data;
            
            [self.trendingCollectionView reloadData];
        }
    }];
}

- (void)_getWantedProducts
{
    [[Server sharedInstance] getWantedProductsWithCallback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (error) {
            if (error.code == NSURLErrorTimedOut) {
                [self showErrorDialogWithButtonWithMessage:error.localizedDescription callback:^{
                    [self _getWantedProducts];
                }];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
            
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
    [self showActivityIndicator];
    
    [[MovieDatabaseAPIProxy sharedInstance] getActor:product.moviedatabaseActorId.longValue callback:^(id response, NSError *error) {
        
        if (!error) {
            MoviedatabaseItem* item = (MoviedatabaseItem*)response;
            
            [[MovieDatabaseAPIProxy sharedInstance] getMoviesForActor:item.identifier.longValue callback:^(id response, NSError *error) {
                
                [self hideActivityIndicator];
                
                if (!error) {
                    item.mediaType = @"person";
                    
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MovieActorDetailViewController* vc =[storyboard instantiateViewControllerWithIdentifier:@"ItemDetailViewController"];
                    vc.mainItem = item;
                    vc.items = ((CastCollection*)response).cast;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    [self showErrorDialogWithMessage:error.localizedDescription];
                }
            }];
            
        } else {
            [self hideActivityIndicator];
            
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

- (void)movieTouched:(Product*)product
{
    if (product.moviedatabaseMovieId) {
        [self _showMovieForProduct:product];
        
    } else {
        [self _showTvForProduct:product];
    }
}

- (void)_showMovieForProduct:(Product*)product
{
    [self showActivityIndicator];
    
    [[MovieDatabaseAPIProxy sharedInstance] getMovie:product.moviedatabaseMovieId.longValue callback:^(id response, NSError *error) {
        
        if (!error) {
            MoviedatabaseItem* item = (MoviedatabaseItem*)response;
            
            [[MovieDatabaseAPIProxy sharedInstance] getCastForMovie:item.identifier.longValue callback:^(id response, NSError *error) {
                
                [self hideActivityIndicator];
                
                if (!error) {
                    item.mediaType = @"movie";
                    
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MovieActorDetailViewController* vc =[storyboard instantiateViewControllerWithIdentifier:@"ItemDetailViewController"];
                    vc.mainItem = item;
                    vc.items = ((CastCollection*)response).cast;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    [self showErrorDialogWithMessage:error.localizedDescription];
                }
            }];
            
        } else {
            [self hideActivityIndicator];
            
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

- (void)_showTvForProduct:(Product*)product
{
    [self showActivityIndicator];
    
    [[MovieDatabaseAPIProxy sharedInstance] getTv:product.moviedatabaseMovieId.longValue callback:^(id response, NSError *error) {
        
        if (!error) {
            MoviedatabaseItem* item = (MoviedatabaseItem*)response;
            
            [[MovieDatabaseAPIProxy sharedInstance] getCastForMovie:item.identifier.longValue callback:^(id response, NSError *error) {
                
                [self hideActivityIndicator];
                
                if (!error) {
                    item.mediaType = @"tv";
                    
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MovieActorDetailViewController* vc =[storyboard instantiateViewControllerWithIdentifier:@"ItemDetailViewController"];
                    vc.mainItem = item;
                    vc.items = ((CastCollection*)response).cast;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    [self showErrorDialogWithMessage:error.localizedDescription];
                }
            }];
            
        } else {
            [self hideActivityIndicator];
            
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

@end
