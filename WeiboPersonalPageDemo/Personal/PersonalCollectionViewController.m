//
//  PersonalCollectionViewController.m
//  WeiboPersonalPageDemo
//
//  Created by JasonYan on 2018/4/8.
//  Copyright © 2018年 JasonYan. All rights reserved.
//

#import "PersonalCollectionViewController.h"
#import "PersonalCustomNavigationBarView.h"
#import "PersonalHeaderView.h"
#import "PersonalCell.h"

static const CGFloat kTopHeaderViewHeight = 223.0f;


@interface PersonalCollectionViewController ()
@property (strong, nonatomic) PersonalCustomNavigationBarView *customNavigationBarView;
@property (strong, nonatomic) PersonalHeaderView *personalHeaderView;
@end

@implementation PersonalCollectionViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self setUpUI];
    [self setUpCollectionView];
    [self.collectionView reloadData];
}


- (void)setUpUI {
    [self.view addSubview:self.personalHeaderView];
    [self.view addSubview:self.customNavigationBarView];
    
    [self.view bringSubviewToFront:self.customNavigationBarView];
}

-(void)setUpCollectionView {
    [self setUpCollectionViewInsets];
    self.collectionView.alwaysBounceVertical = YES; //allow drag vertically
    [self.collectionView registerNib:[PersonalCell nib] forCellWithReuseIdentifier:[PersonalCell reuseIdentifier]];
}

- (void)setUpCollectionViewInsets {
    UIEdgeInsets insets = self.collectionView.contentInset;
    insets.top = kTopHeaderViewHeight;
    self.collectionView.contentInset = insets;
    self.collectionView.scrollIndicatorInsets = insets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///--------------------------------------
#pragma mark - UIScrollViewDelegate
///--------------------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = -(self.collectionView.contentOffset.y + kTopHeaderViewHeight);
    self.personalHeaderView.top = contentOffsetY;
    if (contentOffsetY <= -114.0f) {
        self.personalHeaderView.top = -114.0f;
    }
    if (contentOffsetY <= -113.55f) {
        self.personalHeaderView.vectorViewStyle = PersonalHeaderVectorViewStyleWhite;
    }
    else {
        self.personalHeaderView.vectorViewStyle = PersonalHeaderVectorViewStyleDefault;
    }
    
    
    // 处理向下滑动时头部背景的拉伸效果
    if (contentOffsetY >= 0) {
        // Y锁定在0，高度增加拉伸的数量
        self.personalHeaderView.top = 0;
        self.personalHeaderView.height = kTopHeaderViewHeight + contentOffsetY;
    }
    else {
        self.personalHeaderView.height = kTopHeaderViewHeight;
    }
    
    if (contentOffsetY >= 70) {
        if (!self.customNavigationBarView.isAnimating && !scrollView.isDragging) {
            [self.customNavigationBarView startAnimating];
            [self refreshData];
        }
    }
    
    CGFloat bgAlphaValue = (contentOffsetY / -114.0f);
    
    [self.customNavigationBarView setElementsAlpha:bgAlphaValue];
}


#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    PersonalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PersonalCell reuseIdentifier] forIndexPath:indexPath];
    NSString *imgName = [NSString stringWithFormat:@"0%ld",(row%5)];
    cell.imgV.image = [UIImage imageNamed:imgName];
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [PersonalCell size];
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    edgeInsets = UIEdgeInsetsMake(0, 12.0, 12.0, 12.0);// 上左下右
    return edgeInsets;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0.0f;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

#pragma mark -
#pragma mark UICollectionViewDelegate


#pragma mark -
#pragma mark NetWork
-(void)refreshData {
    [self loadData];
}

-(void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.customNavigationBarView stopAnimating];
    });
}

#pragma mark -
#pragma mark Getter/Setter

- (PersonalCustomNavigationBarView *)customNavigationBarView {
    if (!_customNavigationBarView) {
        _customNavigationBarView = [[PersonalCustomNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    }
    return _customNavigationBarView;
}

- (PersonalHeaderView *)personalHeaderView {
    if (!_personalHeaderView) {
        _personalHeaderView = [PersonalHeaderView loadForNib];
        _personalHeaderView.frame = CGRectMake(0, 0, ScreenWidth, kTopHeaderViewHeight);
    }
    return _personalHeaderView;
}
@end
