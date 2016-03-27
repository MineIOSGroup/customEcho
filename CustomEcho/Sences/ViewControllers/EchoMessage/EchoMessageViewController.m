//
//  EchoMessageViewController.m
//  CustomEcho
//
//  Created by Young on 1/21/16.
//  Copyright © 2016 Young. All rights reserved.
//

#import "EchoMessageViewController.h"
#import "SessionListViewController.h"
#import "SessionViewController.h"

@interface EchoMessageViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *followTableView;
@property (nonatomic, strong) UITableView *nearbyTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (nonatomic, strong) NSMutableArray *currentCommentArray;

@end

@implementation EchoMessageViewController


- (NSMutableArray *)currentCommentArray
{
    if (!_currentCommentArray) {
        _currentCommentArray = [NSMutableArray array];
    }
    return _currentCommentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    // Do any additional setup after loading the view.
    //登陆网易云信
    [[NIMSDK sharedSDK].loginManager login:@"user" token:@"123456" completion:^(NSError *error) {
        if (!error) {
            NSString *userID = [NIMSDK sharedSDK].loginManager.currentAccount;
//            NSLog(@"%@",userID);
        }
    }];
    
    [self lodingComments];
}



- (void)initLayout
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, [UIScreen mainScreen].bounds.size.height - 64);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    self.followTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49) style:UITableViewStylePlain];
    self.nearbyTableView = [[UITableView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49) style:UITableViewStylePlain];
   
    self.followTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nearbyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.followTableView.delegate = self;
    self.followTableView.dataSource = self;
    self.nearbyTableView.dataSource = self;
    self.nearbyTableView.delegate = self;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.segControl addTarget:self action:@selector(segControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.followTableView];
    [self.scrollView addSubview:self.nearbyTableView];
}

- (void) lodingComments
{
    //从一个公用的数组中获取数据，来请求sound，与外界的接口是 index datamanager中的allData
    
    
    NSString *urlWithComments = [Comments_URL stringByAppendingFormat:@"123"];
    
    AFHTTPRequestOperationManager *manager_2 = [AFHTTPRequestOperationManager manager];
    [manager_2 GET:urlWithComments parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        self.currentCommentArray = nil;
        NSArray *array =[[responseObject valueForKey:@"result"] valueForKey:@"data"];
        for (id obj in array) {
            Comments *comments = [Comments new];
            [comments setValuesForKeysWithDictionary:obj];
            
            User *user = [User new];
            [user setValuesForKeysWithDictionary:[obj valueForKey:@"user"]];
            comments.user = user;
            
            [self.currentCommentArray addObject:comments];
            
        }

        [self.nearbyTableView reloadData];
//        NSLog(@"%lu",(unsigned long)self.currentCommentArray.count);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - segmentControl Delegate
- (void)segControlAction:(UISegmentedControl *)Seg
{
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width * Seg.selectedSegmentIndex, 0);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        self.segControl.selectedSegmentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
   
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.followTableView) {
        return [DataManager shareDataManager].arrayData.count;
    }
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.followTableView) {
        return 229;
    }
    if (tableView == self.nearbyTableView) {
        return 72;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.followTableView) {
        FollowCell *followCell = [tableView dequeueReusableCellWithIdentifier:@"FollowCell"];
        if (followCell == nil) {
            followCell = [[NSBundle mainBundle] loadNibNamed:@"FollowCell" owner:self options:nil].lastObject;
        }
        
        NSURL *url = [NSURL URLWithString:[[DataManager shareDataManager].arrayData[indexPath.row] pic_500]];
        
        [followCell.playerAvatar sd_setImageWithURL:url];
        
        [followCell.avatar sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                followCell.channel.text = (NSString *)[[DataManager shareDataManager].arrayData[indexPath.row] user_id];
                followCell.playerDesc.text = (NSString *)[[DataManager shareDataManager].arrayData[indexPath.row] name];
            }
        }];
        
        
        return followCell;
    }
    if (tableView == self.nearbyTableView) {
        NearbyCell *nearCell = [tableView dequeueReusableCellWithIdentifier:@"NearbyCell"];
        if (nearCell == nil) {
            nearCell = [[NSBundle mainBundle] loadNibNamed:@"NearbyCell" owner:self options:nil].lastObject;
        }
//        if (self.currentCommentArray.count) {
//            Comments *commet = self.currentCommentArray[indexPath.row];
//            NSURL *url = [NSURL URLWithString:commet.user.avatar];
//            [nearCell.avatar sd_setImageWithURL: url];
//            nearCell.nickName.text = commet.user.name;
//            nearCell.songName.text = commet.content;
//        }

        
        
        NSURL *url = [NSURL URLWithString:[[DataManager shareDataManager].arrayData[indexPath.row] pic_500]];
        [nearCell.avatar sd_setImageWithURL:url];
        nearCell.nickName.text = (NSString *)[[DataManager shareDataManager].arrayData[indexPath.row] user_id];
        nearCell.songName.text = [(NSString *)[[DataManager shareDataManager].arrayData[indexPath.row] name] substringToIndex:6];
        
        [nearCell pushSessionVC:^(NSString *nickname) {
            NIMSession *session = [NIMSession session:nickname type:NIMSessionTypeP2P];
            SessionViewController *vc = [[SessionViewController alloc] initWithSession:session];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
//        [nearCell.chat addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return nearCell;
    }
    return nil;
    
}


- (void)chatButtonAction:(UIButton *)sender
{
    NearbyCell *cell = (NearbyCell *)sender.superview.superview;
    
    NSString *uid = cell.nickName.text;
    NIMSession *session = [NIMSession session:uid type:NIMSessionTypeP2P];
    SessionViewController *vc = [[SessionViewController alloc] initWithSession:session];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
