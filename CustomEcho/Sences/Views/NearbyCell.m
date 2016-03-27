//
//  NearbyCell.m
//  CustomEcho
//
//  Created by Young on 1/22/16.
//  Copyright © 2016 Young. All rights reserved.
//

#import "NearbyCell.h"
#import "SessionViewController.h"

@implementation NearbyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)chatButtonAction:(UIButton *)sender {
    
    if (self.chatBlock) {
        self.chatBlock(self.nickName.text);
    }
    
}

- (void)pushSessionVC:(chatButtonActionBlock)chatBlock
{
    self.chatBlock = chatBlock;
}
@end
