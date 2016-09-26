//
//  CategoriesListViewController.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/29/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "CategoriesListViewController.h"

@interface CategoriesListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger selectedIndexPath;

@end

@implementation CategoriesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedIndexPath = -1;
    
    [self.tableView setTableFooterView: [[UIView alloc] initWithFrame: CGRectZero]];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBActions

- (IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{

        if (self.delegate) {
            [self.delegate selectedCategory:self.categories[self.selectedIndexPath]];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = self.view.frame.size.width / 320;
    
    return 44 * scale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* string = self.categories[indexPath.row].name;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel* label = [cell viewWithTag:100];
    label.text = string;
    
    cell.backgroundColor = self.selectedIndexPath == indexPath.row? [UIColor colorWithRed:130/255.0f green:25/255.0f blue:10/255.0f alpha:1] : [UIColor clearColor];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath.row;
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector : @selector (setSeparatorInset :)]) {
        [cell setSeparatorInset : UIEdgeInsetsZero ];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector : @selector (setPreservesSuperviewLayoutMargins :)]) {
        [cell setPreservesSuperviewLayoutMargins : NO ];
    }
    
    // Set Your explictly cell's layout margins
    if ([cell respondsToSelector : @selector (setLayoutMargins :)]) {
        [cell setLayoutMargins : UIEdgeInsetsZero ];
    }
}

@end
