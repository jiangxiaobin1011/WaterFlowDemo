//
//  ViewController.m
//  WaterFlowDemo
//
//  Created by jiangbin on 2020/5/11.
//  Copyright © 2020 ice. All rights reserved.
//

#import "ViewController.h"
#import "JWaterFlowLauput.h"
@interface ViewController ()<JWaterFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic ,strong)UICollectionView* collectionView;
@property(nonatomic ,strong)JWaterFlowLauput* flowLayout;
@property(nonatomic ,strong)NSMutableArray* dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initDatas];
    
    _flowLayout  = [[JWaterFlowLauput alloc] init];
    _flowLayout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIDDD"];
    //注册头尾视图
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFoot"];
    

    
    [self.view addSubview:_collectionView];
    
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }

    // Do any additional setup after loading the view.
}


- (void)initDatas{
    self.dataSource = [NSMutableArray array];
    for (int i = 0 ; i < 10 ; i ++) {
        [self.dataSource addObject:@(arc4random()%200 + 30)];
    }
    
}

/// 设置总section数
/// @param flowLayout flowLayout
- (NSInteger)secionCountInWaterFlowLayout:(JWaterFlowLauput*)flowLayout{
    return 1;
}

/// 设置列数
/// @param flowLayout flowLayout
- (NSInteger)cloumnCountInWaterFlowLayout:(JWaterFlowLauput*)flowLayout{
    return 3;
}

/// cell的size
/// @param flowLayout flowLayout
- (CGSize)itemSizeInWaterFlowLayout:(JWaterFlowLauput*)flowLayout indexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(self.view.frame.size.width / 3,[self.dataSource[indexPath.row] floatValue]);
}


/// 配置cell的边缘间距
/// @param flowLayout flowLayout
- (UIEdgeInsets)cellEdgeInsetsInWaterFlowLayout:(JWaterFlowLauput*)flowLayout{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


/// 配置cell的行间距
/// @param flowLayout flowLayout
- (CGFloat)cellRowMarginInWaterFlowLayout:(JWaterFlowLauput*)flowLayout{
    return 10;
}


/// 配置cell的列间距
/// @param flowLayout flowLayout description
- (CGFloat)cellCloumnMarginInWaterFlowLayout:(JWaterFlowLauput*)flowLayout{
    return 10;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIDDD" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 20)];
    label.text = [@(indexPath.row + 1) stringValue];
    label.textColor = [UIColor whiteColor];
    [cell addSubview:label];
    return cell;
}


#pragma mark  配置头部和尾部

/// 配置section的头部视图
/// @param flowLayout flowLayout
/// @param indexPath indexPath
- (CGSize)headerViewSizeInInWaterFlowLayout:(JWaterFlowLauput*)flowLayout indexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(self.collectionView.frame.size.width, 40);
}


/// 配置section的尾部视图
/// @param flowLayout fla
/// @param indexPath zz
- (CGSize)footerViewSizeInInWaterFlowLayout:(JWaterFlowLauput*)flowLayout indexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(self.collectionView.frame.size.width, 50);
}


- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor greenColor];
        return headerView;
        
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFoot" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor yellowColor];
        return footerView;
    }
}


@end
