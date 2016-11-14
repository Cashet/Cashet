//
//  ItemCollectionViewCell.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/17/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@protocol ItemCollectionViewCellDelegate <NSObject>

- (void)productTouched:(Product*)product;
- (void)actorTouched:(Product*)product;
- (void)movieTouched:(Product*)product;

@end

@interface ItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *actorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *gradientContainerView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;

@property (weak, nonatomic) id<ItemCollectionViewCellDelegate> delegate;
@property (retain, nonatomic) Product* product;

@end
