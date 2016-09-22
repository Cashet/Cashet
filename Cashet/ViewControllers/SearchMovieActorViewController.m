//
//  SearchMoviewActorViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "SearchMovieActorViewController.h"
#import "MovieActorSearchTableViewCell.h"
#import "MovieDatabaseAPIProxy.h"
#import <UIImageView+AFNetworking.h>
#import "MoviedatabaseItem.h"
#import "MoviedatabasePage.h"
#import "ColorHelper.h"
#import "MovieActorDetailViewController.h"

@interface SearchMovieActorViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSArray<MoviedatabaseItem*>* items;
@property(nonatomic, retain) MoviedatabasePage* page;
@property(nonatomic, retain) MoviedatabaseItem* selectedItem;
@property(nonatomic, retain) CastCollection* selectedItemCast;

@end

@implementation SearchMovieActorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Ca$het";
    
    [self noResultsViewHidden:NO];
    
    [self.searchBar becomeFirstResponder];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setSeparatorColor:[ColorHelper dividerLineColor]];
    
    self.items = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MovieActorDetailViewController* vc = segue.destinationViewController;
    vc.mainItem = self.selectedItem;
    vc.items = self.selectedItemCast.cast;
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
    
    [[MovieDatabaseAPIProxy sharedInstance] getActorsAndMoviesForString:self.searchBar.text callback:^(id response, NSError *error) {
        [self hideActivityIndicator];
        
        if (!error) {
            self.page = response;
            self.items = self.page.results;
            [self.tableView reloadData];
            
            [self noResultsViewHidden:self.items.count != 0];
            
        } else  {
            [self noResultsViewHidden:NO];
            
            [self showErrorDialogWithMessage:error.localizedDescription];
        }
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = self.view.frame.size.width / 320;
    
    return 58 * scale;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoviedatabaseItem* item = self.items[indexPath.row];
    
    MovieActorSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.pictureImageView.image = nil;
    
    if ([item.mediaType isEqualToString:@"movie"]) {
        cell.titleLabel.text = item.title;
        cell.subtitleLabel.text = @"MOVIE";
        [cell.pictureImageView setImageWithURL:[NSURL URLWithString:[MovieDatabaseAPIProxy fullpathForThumbnailImage:item.posterPath]] placeholderImage:nil];
        
    } else if ([item.mediaType isEqualToString:@"person"]){
        cell.titleLabel.text = item.name;
        cell.subtitleLabel.text = @"ACTOR";
        [cell.pictureImageView setImageWithURL:[NSURL URLWithString:[MovieDatabaseAPIProxy fullpathForThumbnailImage:item.profilePath]] placeholderImage:nil];
        
    } else {
        cell.titleLabel.text = item.name;
        cell.subtitleLabel.text = @"TV";
        [cell.pictureImageView setImageWithURL:[NSURL URLWithString:[MovieDatabaseAPIProxy fullpathForThumbnailImage:item.posterPath]] placeholderImage:nil];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = self.items[indexPath.row];
    
    [self showActivityIndicator];
    
    if ([self.selectedItem.mediaType isEqualToString:@"movie"]) {
        
        [[MovieDatabaseAPIProxy sharedInstance] getCastForMovie:self.selectedItem.identifier.longValue callback:^(id response, NSError *error) {
        
            [self hideActivityIndicator];
            
            if (!error) {
                
                self.selectedItemCast = response;
                
                [self performSegueWithIdentifier:@"item detail" sender:self];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }];
        
    } else if ([self.selectedItem.mediaType isEqualToString:@"tv"]) {
        
        [[MovieDatabaseAPIProxy sharedInstance] getCastForTv:self.selectedItem.identifier.longValue callback:^(id response, NSError *error) {
            
            [self hideActivityIndicator];
            
            if (!error) {
                
                self.selectedItemCast = response;
                
                [self performSegueWithIdentifier:@"item detail" sender:self];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }];
        
    } else {
        [[MovieDatabaseAPIProxy sharedInstance] getMoviesForActor:self.selectedItem.identifier.longValue callback:^(id response, NSError *error) {
            
            [self hideActivityIndicator];
            
            if (!error) {
                self.selectedItemCast = response;
                
                [self performSegueWithIdentifier:@"item detail" sender:self];
                
            } else {
                [self showErrorDialogWithMessage:error.localizedDescription];
            }
        }];
    }
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

@end
