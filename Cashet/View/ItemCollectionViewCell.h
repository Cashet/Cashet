//
//  ItemCollectionViewCell.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/17/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCollectionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@end
