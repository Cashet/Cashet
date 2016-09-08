
//
//  CategoryViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "ProductCategoryViewController.h"
#import "CategoryItemCollectionViewCell.h"
#import "MovieDatabaseAPIProxy.h"
#import <UIImageView+AFNetworking.h>
#import "CategoryItemProductState.h"
#import "CategoryItemNotKnownState.h"
#import "RequestProductViewController.h"
#import "Server.h"
#import "ServerListResponse.h"
#import "IWantThisViewController.h"
#import "BuyProductViewController.h"
#import "IKnowWhatThisIsViewController.h"

@interface ProductCategoryViewController() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSArray<Product*>* items;
@property (retain, nonatomic) UIImage* image;
@property (retain, nonatomic) Product* selectedProduct;

@end

@implementation ProductCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.image = [UIImage new];

    self.items = [NSMutableArray new];

    [self.collectionView reloadData];
    
    self.titleLabel.text = self.movie.title;
    self.subtitleLabel.text = self.actor.name;
    
    [self _addGradientToBanner];
    [self _addBorderToRequestProductButton];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[MovieDatabaseAPIProxy fullpathForLargeImage:self.movie.posterPath]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:self.image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = self.image;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    [self showActivityIndicator];
    
    [[Server sharedInstance] getProductsForActor:self.actor movie:self.movie category:self.category callback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
       
        if (error) {
            [self showErrorDialogWithMessage:error.localizedDescription];
            
        } else {
            self.items = ((ServerListResponse*)response).data;
            [self.collectionView reloadData];
        }
    }];
}

- (void)_addGradientToBanner
{
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = self.overlayView.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.50] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    gradient.startPoint = CGPointMake(0.5, 0);
    CGFloat percentage = self.navigationController.navigationBar.frame.size.height / self.overlayView.frame.size.height * 0.75;
    gradient.endPoint = CGPointMake(0.5, percentage);
    
    [self.imageView.layer insertSublayer:gradient atIndex:0];
}

- (void)_addBorderToRequestProductButton
{
    self.requestProductButton.layer.cornerRadius = self.requestProductButton.frame.size.height/2;
    self.requestProductButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.requestProductButton.layer.borderWidth = 1;    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product* item = self.items[indexPath.row];
    
    CategoryItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.state = [item.status isEqualToString:@"unknowable"] ? [CategoryItemNotKnownState new] : [CategoryItemProductState new];
    cell.model = item;
    cell.bottomButton.tag = indexPath.row;
    cell.heartButton.tag = indexPath.row;
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:@"header"
                                                                               forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.view.frame;
    NSInteger width = (frame.size.width - 18)/2;
    CGFloat scale = width / 151;
    
    return CGSizeMake(width, 226 * scale);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"request product"]) {
        RequestProductViewController* vc = segue.destinationViewController;
        vc.actor = self.actor;
        vc.movie = self.movie;
        vc.category = self.category;
        
    } else if ([segue.identifier isEqualToString:@"I know what this is"]) {
        IKnowWhatThisIsViewController* vc = segue.destinationViewController;
        vc.product = self.selectedProduct;
        
    } else if ([segue.identifier isEqualToString:@"buy product"]) {
        BuyProductViewController* vc = segue.destinationViewController;
        vc.product = self.selectedProduct;
        
    } else if ([segue.identifier isEqualToString:@"I want this"]) {
        IWantThisViewController* vc = segue.destinationViewController;
        vc.product = self.selectedProduct;
    }
}

#pragma mark - IBActions
- (IBAction)requestProduct:(id)sender
{
    [self performSegueWithIdentifier:@"request product" sender:self];
}

- (IBAction)IWantThisClicked:(id)sender
{
    self.selectedProduct = self.items[((UIView*)sender).tag];
    
    [self performSegueWithIdentifier:@"I want this" sender:self];
}

- (IBAction)bottomButtonClicked:(id)sender
{
    self.selectedProduct = self.items[((UIView*)sender).tag];
    
    [self performSegueWithIdentifier:[self.selectedProduct.status isEqualToString:@"unknowable"] ? @"I know what this is" : @"buy product" sender:self];
}

@end
