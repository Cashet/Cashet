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

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, retain) NSArray<Item*>* trendingItems;
@property(nonatomic, retain) NSArray<Item*>* wantedItems;
@property(nonatomic, retain) NSMutableArray *dropdownItems;
@property(nonatomic, retain) NSMutableArray *filteredContentList;
@property(nonatomic, assign) BOOL isSearching;

@property(nonatomic, retain) NSMutableArray<NSDictionary*>* trendingItemsPlaceholders;
@property(nonatomic, retain) NSMutableArray<NSDictionary*>* wantedItemsPlaceholders;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.title = @"Ca$het";
    
    [self.tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_doSearch)]];
    
    self.trendingItemsPlaceholders = [NSMutableArray new];
    [self.trendingItemsPlaceholders addObject:@{@"movie":@"Terminator 2:\nJudgment Day", @"actor":@"Arnold Schwarzenegger", @"item":@"Glasses", @"image":@"terminator 2"}];
    [self.trendingItemsPlaceholders addObject:@{@"movie":@"Word War Z", @"actor":@"Brad Pitt", @"item":@"T-Shirt", @"image":@"world war z"}];
    [self.trendingItemsPlaceholders addObject:@{@"movie":@"Prometheus", @"actor":@"Noomi Rapace", @"item":@"Dress", @"image":@"prometheus"}];
    [self.trendingItemsPlaceholders addObject:@{@"movie":@"SecondHand\nLions", @"actor":@"Haley Joel Osment", @"item":@"Pants", @"image":@"secondhand lions"}];
    
    self.wantedItemsPlaceholders = self.trendingItemsPlaceholders;
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
        return self.trendingItemsPlaceholders.count;
        
    } else {
        return self.wantedItemsPlaceholders.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = self.trendingItemsPlaceholders[indexPath.row];
    
    ItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:item[@"image"]]];
    cell.movieLabel.text = item[@"movie"];
    cell.actorLabel.text = item[@"actor"];
    cell.viewCountLabel.text = @"500";
    cell.itemLabel.text = item[@"item"];
    
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
    CGRect frame = self.view.frame;
    CGFloat scale = (frame.size.width/2) / 160;
    
    return CGSizeMake(frame.size.width/2, 107 * scale);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
