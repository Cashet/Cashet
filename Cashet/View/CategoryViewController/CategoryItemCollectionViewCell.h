//
//  CategoryItemCollectionViewCell.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/23/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryItemCellState.h"
#import "Product.h"

@protocol CategoryItemCellState;

@interface CategoryItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *heartButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIImageView *bottomButtonIcon;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomButtonLabel;

@property (retain, nonatomic) id<CategoryItemCellState> state;
@property (retain, nonatomic) Product* model;

@end
