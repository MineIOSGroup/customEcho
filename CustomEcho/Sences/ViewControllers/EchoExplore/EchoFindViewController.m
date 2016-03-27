//
//  EchoFindViewController.m
//  CustomEcho
//
//  Created by Young on 1/18/16.
//  Copyright © 2016 Young. All rights reserved.
//

#import "EchoFindViewController.h"
#import "HeaderCollectionReusableView.h"

@interface EchoFindViewController ()

@property (nonatomic, assign) BOOL isPush;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation EchoFindViewController

#pragma mark - 单例方法
+ (instancetype) shareEchoViewController
{
    static EchoFindViewController *echo = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        echo = [EchoFindViewController new];
    });
    return echo;
}

//初始化数据
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //初始化解析数据！
        [DataManager shareDataManager].currentIndex ++;
        NSLog(@"%ld",[DataManager shareDataManager].currentIndex);
        
        self.urlString = [DataManager shareDataManager].urlTypeString;
        
        NSData *data = nil;
        NSArray *array = nil;
        
        if ([self.urlString isEqualToString:HomePage_URL]) {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.urlString stringByAppendingFormat:@"%ld",[DataManager shareDataManager].currentIndex]]];
            if (!data) {
                return self;
            }
            array = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"result"] valueForKey:@"data"];
        }
        else
        {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.urlString stringByAppendingFormat:@"%ld&limit=20",[DataManager shareDataManager].currentIndex]]];
            if (!data) {
                return self;
            }
            array = [[[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"sounds"];
        }
        
        if (data == nil) {
            return self;
        }
        
        for (id obj in array) {
            Music *music = [Music new];
            [music setValuesForKeysWithDictionary:obj];
            [[DataManager shareDataManager].arrayData addObject:music];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShufflingCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ShufflingCell"];
        
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyEchoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CellID"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.collectionViewLayout = layout;
    [self refresh];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.isPush = YES;
    [self.collectionView reloadData];
}

- (void) requestDataWithUrlString:(NSString *)string
{
    [DataManager shareDataManager].currentIndex ++;
    NSString *url = nil;
    if ([string isEqualToString:HomePage_URL]) {
        url = [string stringByAppendingFormat:@"%ld",[DataManager shareDataManager].currentIndex];
    }
    else{
        url = [string stringByAppendingFormat:@"%ld&limit=20",[DataManager shareDataManager].currentIndex];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //这里解析方式不同！！要统一需要判断
        NSArray *array = nil;
        if ([string isEqualToString:HomePage_URL]) {
            array = [[responseObject valueForKey:@"result"] valueForKey:@"data"];
        }
        else{
            array = [[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"sounds"];
        }
        for (id obj in array) {
            Music *music = [Music new];
            [music setValuesForKeysWithDictionary:obj];
            [[DataManager shareDataManager].arrayData addObject:music];
            //            [self.allDataArray addObject:music];
        }
        
        //        NSLog(@"%ld",self.allDataArray.count);
        NSLog(@"%ld",[DataManager shareDataManager].arrayData.count);
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 刷新事件
- (void) refresh
{
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        _currentIndex = 0;
        [DataManager shareDataManager].currentIndex = 0;
        
        [DataManager shareDataManager].arrayData = nil;
        
        [self requestDataWithUrlString:self.urlString];
    }];
    
    //上拉刷新
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithUrlString:self.urlString];
    }];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    footer.stateLabel.hidden = YES;
    
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = footer;
}

#pragma mark - collection Delegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 4);
    }
    return CGSizeMake(160, 200);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 6;
    }
    if (section == 2) {
        return 4;
    }
    if (section == 3) {
        return 6;
    }

    return [DataManager shareDataManager].arrayData.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellID = @"ShufflingCell";
        ShufflingCollectionCell *cell = (ShufflingCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        return cell;
    }
    else{
    
        static NSString *cellID = @"CellID";
        MyEchoCollectionCell *cell = (MyEchoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        if ([DataManager shareDataManager].arrayData.count == 0) {
            return cell;
        }
        
        NSURL *url = [NSURL URLWithString:[[DataManager shareDataManager].arrayData[indexPath.row] pic_500]];
        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];

                cell.label.text = [[DataManager shareDataManager].arrayData[indexPath.row] name];
            }
        }];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView = nil;
        }
        if (indexPath.section == 1) {
            headerView.title.text = @"推荐歌单";
        }
        if (indexPath.section == 2) {
            headerView.title.text = @"独家放送";
        }
        if (indexPath.section == 3) {
            headerView.title.text = @"最新音乐";
        }
        reuseableView = headerView;
    }
    return reuseableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EchoViewController *echoTBC =[EchoViewController shareEchoViewController];
    echoTBC.index = indexPath.row;
    echoTBC.hidesBottomBarWhenPushed = YES;
    echoTBC.isLocal = NO;
    
    if( self.isPush == YES ) {
        self.isPush = NO;
        [self.navigationController pushViewController:echoTBC animated:YES];
    }
}



#pragma mark - CHTCollectionDelegate


@end
