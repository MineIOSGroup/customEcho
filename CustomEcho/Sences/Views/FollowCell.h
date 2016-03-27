//
//  FollowCell.h
//  CustomEcho
//
//  Created by Young on 1/22/16.
//  Copyright © 2016 Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerImageView.h"

@interface FollowCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet PlayerImageView *playerAvatar;
@property (strong, nonatomic) IBOutlet UILabel *channel;
@property (strong, nonatomic) IBOutlet UILabel *playerDesc;

@end
