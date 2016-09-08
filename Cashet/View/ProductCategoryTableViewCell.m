
//
//  ProductCategoryTableViewCell.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/18/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "ProductCategoryTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "MovieDatabaseAPIProxy.h"
#import "ProductTableViewCell.h"

@interface ProductCategoryTableViewCell() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProductCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect frame = [UIApplication sharedApplication].keyWindow.frame;
    
    CGFloat scale = frame.size.width / 320;
    
    if (scale != 1) {
        for (NSLayoutConstraint* constraint in self.tableView.constraints) {
            if ([constraint.identifier isEqualToString:@"width"] ||
                [constraint.identifier isEqualToString:@"height"]) {
                constraint.constant = constraint.constant * scale;
            }
        }
        
        [self updateConstraints];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = self.frame.size.width / 320;
    
    return 110 * scale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.productView.image = nil;
    
    if (indexPath.row == 0) {
        cell.labelContainerView.hidden = YES;
        
        NSString* posterPath = self.moviedatabaseItem.profilePath ? self.moviedatabaseItem.profilePath : self.moviedatabaseItem.posterPath;
        [cell.productView setImageWithURL:[NSURL URLWithString:[MovieDatabaseAPIProxy fullpathForLargeImage:posterPath]]];
        
    } else {
        Category* category = self.items[indexPath.row - 1];
        
        //    [imageView setImageWithURL:[NSURL URLWithString:path]];
        cell.labelContainerView.hidden = NO;
        cell.productLabel.text = category.name;
    }
    
    return cell;
}

- (void)setItems:(NSArray<Category *> *)items
{
    _items = items;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        if (indexPath.row == 0) {
            [self.delegate productCategoryTableViewCell:self moviedatabaseItem:self.moviedatabaseItem];
            
        } else {
            [self.delegate productCategoryTableViewCell:self didSelectCategory:self.items[indexPath.row-1]];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
