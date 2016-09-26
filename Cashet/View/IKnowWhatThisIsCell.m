//
//  SearchViewTableViewCell.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "IKnowWhatThisIsCell.h"

@implementation IKnowWhatThisIsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkButton.layer.cornerRadius = self.checkButton.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self _setCheckButtonSelected:selected];
}

- (void)_setCheckButtonSelected:(BOOL)selected
{
    self.checkButton.selected = selected;
    self.imageOverlay.hidden = !selected;
    self.submitButton.selected = selected;
    self.submitButton.userInteractionEnabled = selected;
}

#pragma mark - IBActions
- (IBAction)checkButtonTapped:(id)sender
{
    [self _setCheckButtonSelected:!self.checkButton.selected];
    
    if (self.delegate) {
        [self.delegate IKnowWhatThisIsCell:self checkButtonCheckedStatusChanged:self.checkButton.selected];
    }
}

@end
