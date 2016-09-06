//
//  SearchProductViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/10/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "IKnowWhatThisIsViewController.h"
#import "SearchViewTableViewCell.h"

@interface IKnowWhatThisIsViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSMutableArray *contentList;
@property(nonatomic, retain) NSMutableArray *filteredContentList;
@property(nonatomic, assign) BOOL isSearching;

@end

@implementation IKnowWhatThisIsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"I Know What This Is";
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.allowsSelection = NO;
    
    self.contentList = [NSMutableArray new];
    [self.contentList addObject:@{@"title": @"Outray Unisex Retro Way…", @"subtitle": @"Price $8.00 & Free Shipping", @"image":@"one"}];
    [self.contentList addObject:@{@"title": @"Outray Vintage Retro…", @"subtitle": @"Price $6.40 & Free Shipping", @"image":@"two"}];
    [self.contentList addObject:@{@"title": @"Outray Half Frame Wayfa…", @"subtitle": @"Price $7.50 & Free Shipping", @"image":@"three"}];
    [self.contentList addObject:@{@"title": @"Outray Unisex Frame Wayfa…", @"subtitle": @"Price $6.50 & Free Shipping", @"image":@"four"}];
    
    self.filteredContentList = [[NSMutableArray alloc] init];
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

- (void)searchTableList
{
    NSString *searchString = self.searchBar.text;
    
    for (NSDictionary *item in self.contentList) {
        NSString* title = item[@"title"];
        
        if ([[title uppercaseString] containsString:[searchString uppercaseString]]) {
            [self.filteredContentList addObject:item];
        }
    }
    
    [self.tableView reloadData];
}

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
    
    //Remove all objects first.
    [self.filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        self.isSearching = YES;
        [self searchTableList];
    }
    else {
        self.isSearching = NO;
        
        [self.filteredContentList addObjectsFromArray:self.contentList];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Search Clicked");
    [self searchTableList];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = self.view.frame.size.width / 320;
    
    return 100 * scale;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearching) {
        return [self.filteredContentList count];
    }
    else {
        return [self.contentList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary* item = nil;
    
    // Configure the cell...
    if (self.isSearching) {
        item = [self.filteredContentList objectAtIndex:indexPath.row];
    } else {
        item = [self.contentList objectAtIndex:indexPath.row];
    }
    
    cell.productName.text = item[@"title"];
    cell.descriptionLabel.attributedText = [self _attributedTextForText: item[@"subtitle"]];
    [cell.productImage setImage:[UIImage imageNamed:item[@"image"]]];
    cell.submitButton.tag = indexPath.row;
    
    return cell;
    
}

- (NSAttributedString*)_attributedTextForText:(NSString*)text
{
#pragma mark - Hardcoded
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];
    
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor whiteColor]
                   range:NSMakeRange(6, 5)];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(6, 5)];
    
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
