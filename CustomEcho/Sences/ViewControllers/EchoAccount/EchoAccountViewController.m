//
//  EchoAccountViewController.m
//  CustomEcho
//
//  Created by Young on 1/26/16.
//  Copyright © 2016 Young. All rights reserved.
//

#import "EchoAccountViewController.h"
#import "AccountHeader.h"

@implementation EchoAccountViewController

- (void)viewDidLoad
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 3;
    }
    if (section == 3) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    static NSString *cellID = @"AccountHeader";
    AccountHeader *headerCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (headerCell == nil) {
        headerCell = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil].lastObject;
        headerCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        return headerCell;
    }

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_mail"];
            cell.textLabel.text = @"我的消息";
        }
        if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_lv"];
            cell.textLabel.text = @"我的等级";
        }
        if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_member"];
            cell.textLabel.text = @"付费音乐包";
        }
        return cell;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_skin"];
            cell.textLabel.text = @"主题换肤";
        }
        if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_night"];
            cell.textLabel.text = @"夜间模式";
        }
        if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"cm2_set_icn_alamclock"];
            cell.textLabel.text = @"定时关闭";
        }
        return cell;
    }
    if (indexPath.section == 3) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [cell addSubview:button];
    }
    return cell;
}


@end
