//
//  SearchProductViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/10/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "IKnowWhatThisIsViewController.h"
#import "SearchViewTableViewCell.h"
#import "AmazonAPIProxy.h"
#import "AmazonResponse.h"
#import "AmazonItem.h"
#import <UIImageView+AFNetworking.h>

#define MAX_PAGES 5 // Defined by Amazon's API

@interface IKnowWhatThisIsViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSMutableArray<AmazonItem*> *items;
@property(nonatomic, assign) BOOL isSearching;
@property(nonatomic, assign) AmazonResponse* response;
@property(nonatomic, assign) long currentPage;

@end

@implementation IKnowWhatThisIsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = @"I Know What This Is";
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.allowsSelection = NO;
    
    [[AmazonAPIProxy sharedInstance] getProductsMatchingString:self.product.name category:self.product.category.name callback:^(AmazonResponse* response, NSError *error) {
        
        self.currentPage = 0;
        self.response = response;
        
        self.items = self.response.items.mutableCopy;
    }];
}

- (void)didReceiveMemoryWarning
{
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

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.isSearching = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Text change - %d", self.isSearching);
    
    [self _search];
}

- (void)_search
{
    [self.items removeAllObjects];
    
    [self showActivityIndicator];
    
    [[AmazonAPIProxy sharedInstance] getProductsMatchingString:self.product.name category:self.product.category.name callback:^(AmazonResponse* response, NSError *error) {
        
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Loading"];
        UIActivityIndicatorView* activityIndicator = [[cell subviews][0] viewWithTag:100];
        [activityIndicator startAnimating];
        
        if (self.currentPage < MAX_PAGES) {
            [self _loadMoreResults];
        }
        
        return cell;
        
    } else {
        SearchViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        AmazonItem* item = self.items[indexPath.row];
   
        cell.productName.text = item.title;
        cell.descriptionLabel.attributedText = [self _attributedTextForText: item.lowestNewPriceFormatted];
        [cell.productImage setImageWithURL:[NSURL URLWithString:item.imageURL]];
        cell.submitButton.tag = indexPath.row;
        
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
    NSString* fulltext = [NSString stringWithFormat:@"Price %@", text];
    
    NSRange range = [fulltext rangeOfString:text];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:fulltext];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor whiteColor]
                   range:range];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range];
    
    return string;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [UIColor colorWithRed:22/225.0f green:22/225.0f blue:22/225.0f alpha:1];
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

#pragma mark - IBActions
- (IBAction)submitButtonClicked:(id)sender
{
    NSLog(@"Submit");
}

@end
