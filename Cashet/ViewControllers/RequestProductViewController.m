//
//  SelectGoogleImageViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/29/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "RequestProductViewController.h"
#import "GoogleImageCell.h"
#import "Server.h"
#import "GIImage.h"
#import <UIImageView+AFNetworking.h>
#import "NSString+URLEncode.h"
#import "GIResponse.h"
#import "GIItem.h"
#import "ServerListResponse.h"
#import "CategoriesListViewController.h"
#import "GoogleAPIProxy.h"

@interface RequestProductViewController() <UICollectionViewDelegate, UICollectionViewDataSource, CategoriesListViewControllerDelegate>

@property (nonatomic, retain) GIResponse* response;
@property (nonatomic, retain) NSMutableArray<GIItem*>* items;
@property (nonatomic, retain) Category* selectedCategory;
@property (nonatomic, retain) NSIndexPath* selectedIndexpath;
@property (nonatomic, assign) long totalResults;
@property (nonatomic, retain) NSArray<Category*>* categories;

@end

@implementation RequestProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.categoryLabel.text = self.category.name;
    self.selectedCategory = self.category;
    
    [self noResultsViewHidden:NO];

    self.continueButton.layer.cornerRadius = self.continueButton.frame.size.height/2;
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_selectCategory:)];
    [self.selectCategoryContainerView addGestureRecognizer:tapRecognizer];
    
    self.title = self.actor.name;
    
    self.totalResults = LONG_MAX;
    
    [self _getCategories];
}

- (void)_getCategories
{
    [self showActivityIndicator];
    
    [[Server sharedInstance] getCategoriesCallback:^(id response, NSError *error) {
        [self hideActivityIndicator];
        
        ServerListResponse* serverResponse = response;
        
        if (!error) {
            
            if (serverResponse.success) {
                    self.categories = serverResponse.data;
            } else {
                [self showErrorDialogWithMessage:serverResponse.message];
            }
        } else {
            if (error.code == NSURLErrorTimedOut) {
                [self showErrorDialogWithButtonWithMessage:error.localizedDescription callback:^{
                    [self _getCategories];
                }];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }
    }];
}

- (NSString*)_getQuery
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.actor.name, self.movie.title, self.searchBar.text];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CategoriesListViewController* vc = segue.destinationViewController;
    vc.categories = self.categories;
    vc.delegate = self;
}

- (IBAction)_selectCategory:(id)sender
{
    [self performSegueWithIdentifier:@"select category" sender:self];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(self.items.count + 1, self.totalResults);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.items.count) {
        return [self _collectionView:collectionView loadingViewRowForItemAtIndexPath:indexPath];
        
    } else {
        return [self _collectionView:collectionView normalViewRowForItemAtIndexPath:indexPath];
    }
}

- (UICollectionViewCell*)_collectionView:(UICollectionView *)collectionView loadingViewRowForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GIRequest* nextRequest = self.response.queries.nextPage[0];
    
    BOOL emptySearch = [self.searchBar.text isEqualToString:@""];
    
    [self noResultsViewHidden:!emptySearch];
    
    if (!emptySearch) {
#pragma mark - Search query?
        [[GoogleAPIProxy sharedInstance] getImagesForString:[self _getQuery] startIndex:nextRequest.startIndex.longValue callback:^(id response, NSError *error) {
            
            if (!error) {
                self.response = response;
                
                if (self.response.error) {
                    self.totalResults = self.items.count;
                    
                } else {
                    [self.items addObjectsFromArray:self.response.items];
                    
                    GIRequest* request = self.response.queries.nextPage[0];
                    self.totalResults = request.totalResults.longValue;
                }
                
                [self.collectionView reloadData];
                
                [self noResultsViewHidden:self.items.count != 0];
                
            } else {
                [self noResultsViewHidden:!emptySearch];
                
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }];
    }
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"activity indicator" forIndexPath:indexPath];
    [[cell subviews][0] viewWithTag:100].hidden = (indexPath.row == 0);
    
    return cell;
}

- (UICollectionViewCell*)_collectionView:(UICollectionView *)collectionView normalViewRowForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GIItem* item = self.items[indexPath.row];
    
    GoogleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.selected = (self.selectedIndexpath && indexPath.row == self.selectedIndexpath.row);
    cell.imageView.image = nil;
    [cell.imageView cancelImageDownloadTask];
    [self _imageView:cell.imageView setImageWithURL:[NSURL URLWithString:item.link]];
    
    return cell;
}

- (void)_imageView:(UIImageView*)imageView setImageWithURL:(NSURL*)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __block UIImageView* imageViewRef = imageView;
    
    [imageView setImageWithURLRequest:request placeholderImage:nil success:nil failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        imageViewRef.image = nil;
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.view.frame;
    NSInteger width = (frame.size.width - 18)/2;
    CGFloat scale = width / 151;
    
    return CGSizeMake(width, 100 * scale);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* array = [NSMutableArray new];
    [array addObject:indexPath];
    
    if (self.selectedIndexpath && self.selectedIndexpath.row == indexPath.row) {
        self.selectedIndexpath = nil;
        
    } else {
        if (self.selectedIndexpath && self.selectedIndexpath.row != indexPath.row) {
            [array addObject:self.selectedIndexpath];
        }
        
        self.selectedIndexpath = indexPath;
    }
    
    [self.collectionView reloadItemsAtIndexPaths:array];
}

#pragma mark - IBActions
- (IBAction)continueAction:(id)sender
{
    NSMutableString* message = [NSMutableString new];
    
    if (!self.selectedCategory) {
        [message appendString:@"\nSelect a category."];
    }
    
    if ([self.searchBar.text isEqualToString:@""]) {
        [message appendString:@"\nAdd a text for the search."];
    }
    
    if (message.length > 0) {
        [message stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
        
        [self showErrorDialogWithMessage:message];
        
    } else {
#pragma  mark - Continue
        [self showActivityIndicator];
        
        Product* product = [Product new];
        product.actor = self.actor;
        product.movie = self.movie;
        product.category = self.selectedCategory;
        product.productDescription = [NSString stringWithFormat:@"%@, %@ in %@", self.actor.name, self.searchBar.text, [self.movie.mediaType isEqualToString:@"movie"] ? self.movie.title : self.movie.name];
        product.name = self.searchBar.text;
        
        if (self.selectedIndexpath) {
            product.picture = self.items[_selectedIndexpath.row].link;
        }
        
        [self _postProduct:product];
    }
}

- (void)_postProduct:(Product*)product
{
    [[Server sharedInstance] postProduct:product callback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            if (error.code == NSURLErrorTimedOut) {
                [self showErrorDialogWithButtonWithMessage:error.localizedDescription callback:^{
                    [self _postProduct:product];
                }];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }
    }];
}

#pragma mark - CategoriesListViewControllerDelegate
- (void)selectedCategory:(Category*)category
{
    self.selectedCategory = category;
    
    self.categoryLabel.text = category.name;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    [self showActivityIndicator];
    
    BOOL emptySearch = [self.searchBar.text isEqualToString:@""];
    
    [self noResultsViewHidden:!emptySearch];
    
    if (!emptySearch) {
#pragma mark - Make search
        [[GoogleAPIProxy sharedInstance] getImagesForString:[self _getQuery] callback:^(id response, NSError *error) {
            [self hideActivityIndicator];
            
            if (!error) {
                self.response = response;
                self.items = self.response.items.mutableCopy;
                [self.collectionView reloadData];
                
                [self noResultsViewHidden:self.items.count != 0];
                
            } else  {
                [self noResultsViewHidden:NO];
                
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }];
    }
}

@end
