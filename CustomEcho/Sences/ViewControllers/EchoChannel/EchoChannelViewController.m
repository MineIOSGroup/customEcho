//
//  EchoChannelViewController.m
//  CustomEcho
//
//  Created by Young on 1/20/16.
//  Copyright © 2016 Young. All rights reserved.
//

#import "EchoChannelViewController.h"
#import "EchoFindViewController.h"
#import "ClassificationCell.h"
#import "ChannelEchoCell.h"

@interface EchoChannelViewController ()
{
    NSInteger _currentIndex;
}
//存 频道 数据
@property (nonatomic, strong) NSMutableArray *dataArray;
//存请求链接
@property (nonatomic, strong) NSString *urlTypeString;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIButton *buttonHot;
@property (nonatomic, strong) IBOutlet UIButton *buttonNew;

@end

@implementation EchoChannelViewController

static NSString * const reuseIdentifier = @"ChannelEchoCell";
static NSString * const shufflingCellIdentifier = @"ShufflingCell";
static NSString * const classificationIdentifier = @"ClassificationCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //刷新
    [self refresh];
    //默认hot
    self.urlTypeString = HOT;
    //请求
    [self requstDataWithUrlstr:self.urlTypeString];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.buttonHot addTarget:self action:@selector(requestTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonNew addTarget:self action:@selector(requestTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectionView registerNib:[UINib nibWithNibName:classificationIdentifier bundle:nil] forCellWithReuseIdentifier:classificationIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void) requestTypeAction:(UIButton *) sender
{
    [self.buttonHot setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [self.buttonNew setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    
    if ([sender.titleLabel.text isEqualToString:@"最新"]) {
        [sender setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        self.urlTypeString = NEW;
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"最热"])
    {
        [sender setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        self.urlTypeString = HOT;
    }
    _currentIndex = 0;
    [self.dataArray removeAllObjects];
    [self requstDataWithUrlstr:self.urlTypeString];
}

#pragma mark - 刷新事件
- (void) refresh
{
//    MJRefreshLegendFooter *footer = [self.collectionView addLegendFooterWithRefreshingBlock:^{
//        [self requstDataWithUrlstr:self.urlTypeString];
//    }];
    
    //上拉刷新
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requstDataWithUrlstr:self.urlTypeString];
    }];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    footer.stateLabel.hidden = YES;
    self.collectionView.mj_footer = footer;
    
}

- (void) requstDataWithUrlstr:(NSString *)urlString
{
    
    NSString *url = [Channel_URL stringByAppendingFormat:@"%ld%@",++_currentIndex,urlString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *array = [[responseObject valueForKey:@"result"] valueForKey:@"data"];
        
        for (id obj in array) {
            Channel *channel = [Channel new];
            [channel setValuesForKeysWithDictionary:obj];
            [self.dataArray addObject:channel];
        }
        
        //刷新页面
        [self.collectionView reloadData];
        //结束刷新
//        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UICollectionView Delegate
//返回组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
//返回组中个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
            
        default:
        {
            return self.dataArray.count;
        }
            break;
    }
}
//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section) {
        case 0:
        {
            ClassificationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classificationIdentifier forIndexPath:indexPath];
            
            return cell;
        }
            break;
        default:
        {
            ChannelEchoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            Channel *channal = self.dataArray[indexPath.row];
            cell.celllabel.text = channal.name;
            [cell.cellimageView sd_setImageWithURL:[NSURL URLWithString:channal.pic_500]];
            
            return cell;
        }
            break;
    }
}
#pragma UICollectionViewDelegateFlowLayout

//item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            CGFloat width = [UIScreen mainScreen].bounds.size.width*5/6;
            return CGSizeMake(width, 110);
        }
            break;
            
        default:
        {
            CGFloat width = [UIScreen mainScreen].bounds.size.width-20;
            return CGSizeMake(width, 100);
        }
            break;
    }
}
//上左下右
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
            break;
            
        default:
        {
            return UIEdgeInsetsMake(44, 0, 0, 0);
        }
            break;
    }
}

//最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 0;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}
//最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 0;
        }
            break;
            
        default:
        {
            return 10;
        }
            break;
    }
}

//点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Channel *channel = self.dataArray[indexPath.row];
    //给dataManager 传值 让下一个控制器获得
    NSString *url = [NSString stringWithFormat:@"http://echosystem.kibey.com/channel/info?list_order=%@&id=%@page=",@"hot",channel.ID];
    if (![url isEqualToString:[DataManager shareDataManager].urlTypeString]) {
        [DataManager shareDataManager].urlTypeString = url;
        [DataManager shareDataManager].arrayData = nil;
        [DataManager shareDataManager].currentIndex = 0;
    }
    EchoFindViewController *echoFindVC = [self.storyboard instantiateViewControllerWithIdentifier:@"首页"];
    [self.navigationController pushViewController:echoFindVC animated:YES];
    
}

#pragma mark - lazy
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
