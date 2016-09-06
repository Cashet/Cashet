//
//  MovieActorSearchTableViewCell.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieActorSearchTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView* pictureImageView;
@property(nonatomic, weak) IBOutlet UILabel* titleLabel;
@property(nonatomic, weak) IBOutlet UILabel* subtitleLabel;

@end
