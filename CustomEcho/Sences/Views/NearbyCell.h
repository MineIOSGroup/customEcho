//
//  NearbyCell.h
//  CustomEcho
//
//  Created by Young on 1/22/16.
//  Copyright © 2016 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^chatButtonActionBlock) (NSString *);

@interface NearbyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *songName;
@property (strong, nonatomic) IBOutlet UIButton *chat;
@property (nonatomic, strong) chatButtonActionBlock chatBlock;


- (void)pushSessionVC:(chatButtonActionBlock)chatBlock;

@end
