//
//  SearchViewTableViewCell.m
//  Cashet
//
//  Created by Daniel Rodríguez on 8/11/16.
//  Copyright © 2016 Cashet. All rights reserved.
//

#import "SearchViewTableViewCell.h"

@implementation SearchViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.checkButton.layer.cornerRadius = self.checkButton.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions
- (IBAction)checkButtonTapped:(id)sender
{
    self.checkButton.selected = !self.checkButton.selected;
    self.imageOverlay.hidden = !self.checkButton.selected;
    self.submitButton.selected = self.checkButton.selected;
    self.submitButton.userInteractionEnabled = self.checkButton.selected;
}

@end
