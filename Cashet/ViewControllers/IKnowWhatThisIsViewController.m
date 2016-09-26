//
//  SearchProductViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/10/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "IKnowWhatThisIsViewController.h"
#import "IKnowWhatThisIsCell.h"
#import "AmazonAPIProxy.h"
#import "AmazonResponse.h"
#import "AmazonItem.h"
#import <UIImageView+AFNetworking.h>
#import "Server.h"
#import "BuyProductViewController.h"

#define MAX_PAGES 5 // Defined by Amazon's API

@interface IKnowWhatThisIsViewController () <UITableViewDelegate, UITableViewDataSource, IKnowWhatThisIsCellDelegate>

@property(nonatomic, retain) NSMutableArray<AmazonItem*> *items;
@property(nonatomic, retain) AmazonResponse* response;
@property(nonatomic, assign) long currentPage;
@property(nonatomic, assign) NSInteger selectedItemRow;

@end

@implementation IKnowWhatThisIsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = @"I Know What This Is";
    
    self.selectedItemRow = -1;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [[AmazonAPIProxy sharedInstance] getProductsMatchingString:self.product.name category:self.product.category.name callback:^(AmazonResponse* response, NSError *error) {
        
        self.currentPage = 0;
        self.response = response;
        
        self.items = self.response.items.mutableCopy;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"amazon product detail"]) {
        BuyProductViewController* vc = segue.destinationViewController;
        vc.product = self.product;
    }
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
    
    [[AmazonAPIProxy sharedInstance] getProductsMatchingString:self.searchBar.text category:self.product.category.name callback:^(AmazonResponse* response, NSError *error) {
        
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
    
    [[AmazonAPIProxy sharedInstance] getProductsMatchingString:self.product.name category:self.product.category.name page:self.currentPage callback:^(AmazonResponse* response, NSError *error) {
        
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
    
    [self performSegueWithIdentifier:@"amazon product detail" sender:self];
}

- (void)_updateProductWithAmazonItem:(AmazonItem*)item
{
    self.product.amazonLink = item.detailPageURL;
    self.product.amazonId = item.ASIN;
    self.product.productDescription = item.title;
    self.product.price = @([item.lowestNewPriceFormatted stringByReplacingOccurrencesOfString:@"$" withString:@""].doubleValue);
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
    
    [[Server sharedInstance] updateProduct:self.product callback:^(id response, NSError *error) {
        [self hideActivityIndicator];
        
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

@end
