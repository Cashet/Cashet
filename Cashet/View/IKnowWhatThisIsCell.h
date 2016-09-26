//
//  SearchViewTableViewCell.h
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitButton.h"

@class IKnowWhatThisIsCell;

@protocol IKnowWhatThisIsCellDelegate <NSObject>

- (void)IKnowWhatThisIsCell:(IKnowWhatThisIsCell*)cell checkButtonCheckedStatusChanged:(BOOL)checked;

@end

@interface IKnowWhatThisIsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIView *imageOverlay;
@property (weak, nonatomic) IBOutlet SubmitButton *submitButton;

@property (weak, nonatomic) id<IKnowWhatThisIsCellDelegate> delegate;

@end
