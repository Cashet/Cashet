//
//  AddAmazonProductViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 10/21/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "AddAmazonProductViewController.h"
#import "IKnowWhatThisIsCell.h"
#import "AmazonItem.h"
#import "AmazonResponse.h"
#import "AmazonAPIProxy.h"
#import "BuyProductViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Server.h"
#import "CategoriesListViewController.h"
#import "ServerListResponse.h"

#define MAX_PAGES 5 // Defined by Amazon's API

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AddAmazonProductViewController () <UITableViewDelegate, UITableViewDataSource, IKnowWhatThisIsCellDelegate, CategoriesListViewControllerDelegate>

@property(nonatomic, retain) NSMutableArray<AmazonItem*> *items;
@property(nonatomic, retain) AmazonResponse* response;
@property(nonatomic, assign) long currentPage;
@property(nonatomic, assign) NSInteger selectedItemRow;
@property (nonatomic, retain) NSArray<Category*>* categories;
@property (nonatomic, retain) Category* selectedCategory;

@end

@implementation AddAmazonProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"I Know What This Is";
    
    self.selectedItemRow = -1;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
//    [[AmazonAPIProxy sharedInstance] getProductsMatchingString:@"" category:self.product.category.name callback:^(AmazonResponse* response, NSError *error) {
//        
//        self.currentPage = 0;
//        self.response = response;
//        
//        self.items = self.response.items.mutableCopy;
//    }];
    
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
                
                self.selectedCategory = self.categories[0];
                
                self.categoryLabel.text = self.categories[0].name;
                
            } else {
                [self showErrorDialogWithMessage:serverResponse.message];
            }
            
        } else {
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_selectCategory:)];
    [self.selectCategoryContainerView addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CategoriesListViewController* vc = segue.destinationViewController;
    vc.categories = self.categories;
    vc.delegate = self;
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

- (void)_search
{
    [self.items removeAllObjects];
    
    [self showActivityIndicator];
    
    [[AmazonAPIProxy sharedInstance] getProductsMatchingString:self.searchBar.text category:self.categoryLabel.text callback:^(AmazonResponse* response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (!error) {
            self.currentPage = 0;
            self.response = response;
            
            self.items = self.response.items.mutableCopy;
            
            [self.tableView reloadData];
            
        } else {
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search Clicked");
    [self _search];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = self.view.frame.size.width / 320;
    
    if (indexPath.row == self.items.count) {
        return 44 * scale;
        
    } else {
        return 100 * scale;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.items.count) {
        if (self.currentPage < MAX_PAGES) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Loading"];
            UIActivityIndicatorView* activityIndicator = [[cell subviews][0] viewWithTag:100];
            [activityIndicator startAnimating];
            
            [self _loadMoreResults];
            
            return cell;
        } else {
            return [tableView dequeueReusableCellWithIdentifier:@"Last"];
        }
    } else {
        AmazonItem* item = self.items[indexPath.row];
        
        IKnowWhatThisIsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.productName.text = item.title;
        cell.descriptionLabel.attributedText = [self _attributedTextForText: item.lowestNewPriceFormatted];
        [cell.productImage setImageWithURL:[NSURL URLWithString:item.imageURL]];
        cell.submitButton.tag = indexPath.row;
        cell.delegate = self;
        cell.tag = indexPath.row;
        
        return cell;
    }
}

- (void)_loadMoreResults
{
    self.currentPage++;
    
    [[AmazonAPIProxy sharedInstance] getProductsMatchingString:self.searchBar.text category:self.categoryLabel.text page:self.currentPage callback:^(AmazonResponse* response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (!error) {
            self.response = response;
            [self.items addObjectsFromArray:self.response.items];
            
            [self.tableView reloadData];
            
        } else {
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

- (NSAttributedString*)_attributedTextForText:(NSString*)text
{
    NSString* price = text;
    
    if (!price) {
        price = @"N/A";
    }
    
    NSString* fulltext = [NSString stringWithFormat:@"Price: %@", price];
    
    NSRange range = [fulltext rangeOfString:price];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:fulltext];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor whiteColor]
                   range:range];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range];
    
    return string;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector : @selector (setSeparatorInset :)]) {
        [cell setSeparatorInset : UIEdgeInsetsZero ];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self _updateProductWithAmazonItem:self.items[indexPath.row]];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BuyProductViewController* vc =[storyboard instantiateViewControllerWithIdentifier:@"BuyProductViewController"];
    vc.product = self.product;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_updateProductWithAmazonItem:(AmazonItem*)item
{
#pragma mark - Update product
    self.product.amazonLink = item.detailPageURL;
    self.product.amazonId = item.ASIN;
    self.product.productDescription = item.title;
    self.product.price = @([item.lowestNewPriceFormatted stringByReplacingOccurrencesOfString:@"$" withString:@""].doubleValue);
    self.product.picture = item.imageURL;
    self.product.category = self.selectedCategory;
    self.product.name = item.title;
    self.product.actorName = self.product.actor.name;
    self.product.movieName = self.product.movie.name;
    self.product.status = @"known";
}

#pragma mark - IKnowWhatThisIsCellDelegate
- (void)IKnowWhatThisIsCell:(IKnowWhatThisIsCell*)cell checkButtonCheckedStatusChanged:(BOOL)checked
{
    if (self.selectedItemRow == -1) {
        self.selectedItemRow = cell.tag;
        return;
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.selectedItemRow inSection:0];
    
    self.selectedItemRow = cell.tag;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

#pragma mark - IBActions
- (IBAction)submitButtonClicked:(id)sender
{
    [self _updateProductWithAmazonItem:self.items[((UIView*)sender).tag]];
    
    [self showActivityIndicator];
    
    [[Server sharedInstance] postProduct:self.product callback:^(id response, NSError *error) {
        
        [self hideActivityIndicator];
        
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

- (IBAction)_selectCategory:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoriesListViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"CategoriesListViewController"];
    vc.categories = self.categories;
    vc.delegate = self;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    } else {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - CategoriesListViewControllerDelegate
- (void)selectedCategory:(Category*)category
{
    self.selectedCategory = category;
    
    self.categoryLabel.text = category.name;
}

@end
