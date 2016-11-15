
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
#import "AddAmazonProductViewController.h"

@interface ProductCategoryViewController() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSArray<Product*>* items;
@property (nonatomic, retain) NSMutableArray<Product*>* filteredItems;
@property (retain, nonatomic) UIImage* image;
@property (retain, nonatomic) Product* selectedProduct;

@end

@implementation ProductCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.image = [UIImage new];
    self.items = [NSArray new];
    self.filteredItems = [NSMutableArray new];

    [self.collectionView reloadData];
    
    self.titleLabel.text = self.movie.title;
    self.subtitleLabel.text = self.actor.name;
    
    [self _setupFilterButton:self.allButton];
    [self _setupFilterButton:self.buyButton];
    [self _setupFilterButton:self.identifyButton];
    
    [self _setButton:self.allButton selected:YES];
    
    [self _addGradientToBanner];
    [self _addBorderToRequestProductButton];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[MovieDatabaseAPIProxy fullpathForLargeImage:self.movie.posterPath]]];
}

- (void)_setupFilterButton:(UIButton*)button
{
    button.layer.cornerRadius = self.allButton.frame.size.height/2;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;
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
            [self noResultsViewHidden:NO];
            
            [self showErrorDialogWithMessage:error.localizedDescription];
            
        } else {
            self.items = ((ServerListResponse*)response).data;
            
            [self _filterItems];
            
            [self noResultsViewHidden:self.items.count != 0];
        }
    }];
}

- (void)_filterItems
{
    NSString* filter = self.allButton.selected ? nil : (self.buyButton.selected ? @"known" : @"unknowable");
    
    if (!filter) {
        self.filteredItems = [self.items mutableCopy];
        
    } else {
        [self.filteredItems removeAllObjects];
        
        for (Product* product in self.items) {
            if ([product.status isEqualToString:filter]) {
                [self.filteredItems addObject:product];
            }
        }
    }
    
    [self.collectionView reloadData];
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
    return self.filteredItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product* item = self.filteredItems[indexPath.row];
    
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
        vc.categories = @[self.category];
        
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
    self.selectedProduct = self.filteredItems[((UIView*)sender).tag];
    
    [self performSegueWithIdentifier:@"I want this" sender:self];
}

- (IBAction)bottomButtonClicked:(id)sender
{
    self.selectedProduct = self.filteredItems[((UIView*)sender).tag];
    
    [self performSegueWithIdentifier:[self.selectedProduct.status isEqualToString:@"unknowable"] ? @"I know what this is" : @"buy product" sender:self];
}

- (IBAction)allButtonClicked:(id)sender
{
    [self _setButton:self.allButton selected:YES];
    [self _setButton:self.buyButton selected:NO];
    [self _setButton:self.identifyButton selected:NO];
    
    [self _filterItems];
}

- (void)_setButton:(UIButton*)button selected:(BOOL)selected
{
    button.selected = selected;
    [button setBackgroundColor:button.selected ? [UIColor whiteColor] : [UIColor clearColor]];
}

- (IBAction)buyButtonClicked:(id)sender
{
    [self _setButton:self.allButton selected:NO];
    [self _setButton:self.buyButton selected:YES];
    [self _setButton:self.identifyButton selected:NO];
    
    [self _filterItems];
}

- (IBAction)identifyButtonClicked:(id)sender
{
    [self _setButton:self.allButton selected:NO];
    [self _setButton:self.buyButton selected:NO];
    [self _setButton:self.identifyButton selected:YES];
    
    [self _filterItems];
}

- (IBAction)addProduct:(id)sender
{
    Product* product = [Product new];
    product.actor = self.actor;
    product.movie = self.movie;
    product.category = self.category;
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddAmazonProductViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"AddAmazonProductViewController"];
    vc.product = product;
    vc.categories = @[self.category];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
