//
//  JWaterFlowLauput.m
//  WaterFlowDemo
//
//  Created by jiangbin on 2020/5/11.
//  Copyright © 2020 ice. All rights reserved.
//

#import "JWaterFlowLauput.h"

/**默认cell之间的行间距*/
static const CGFloat JDefaultRowMargin = 10 ;
/**默认cell之间的列间距*/
static const CGFloat JDefaultCloumnMargin = 10 ;
/**默认cell之间的列间距*/
static const UIEdgeInsets JDefaultCellEdgInset = {10, 10, 10, 10};

@interface JWaterFlowLauput()

/// 所有方块的布局属性
@property (nonatomic ,strong)NSMutableArray* attrsArray;

/// 记录所有方块中最底部的cell.frame.y + cell.size.frame.height
@property (nonatomic ,assign)CGFloat maxBottomY;

/// 每一列中最底部方块的cell.frame.y + cell.size.frame.height
@property (nonatomic ,strong)NSMutableArray* allCloumnBottomY_Arr;


/// 总section数
@property (nonatomic, assign)NSInteger sectionNum;

/// 总列数
@property (nonatomic, assign)NSInteger cloumnNum;

///行间距
@property (nonatomic, assign)CGFloat rowMargin;

///列间距
@property (nonatomic, assign)CGFloat cloumnMargin;

//边缘边距
@property (nonatomic, assign)UIEdgeInsets cellEdgInset;

@end


@implementation JWaterFlowLauput


// 属性配置

- (NSInteger)sectionNum{
    return [self.delegate secionCountInWaterFlowLayout:self];
}
- (NSInteger)cloumnNum{
    return [self.delegate cloumnCountInWaterFlowLayout:self];
}

- (UIEdgeInsets)cellEdgInset{
    if([self.delegate respondsToSelector:@selector(cellEdgeInsetsInWaterFlowLayout:)]){
        return [self.delegate cellEdgeInsetsInWaterFlowLayout:self];
    }else{
        return JDefaultCellEdgInset;
    }
}

- (CGFloat)rowMargin{
    if([self.delegate respondsToSelector:@selector(cellRowMarginInWaterFlowLayout:)]){
        return [self.delegate cellRowMarginInWaterFlowLayout:self];
    }else{
        return JDefaultRowMargin;
    }

}

- (CGFloat)cloumnMargin{
    if([self.delegate respondsToSelector:@selector(cellCloumnMarginInWaterFlowLayout:)]){
        return [self.delegate cellCloumnMarginInWaterFlowLayout:self];
    }else{
        return JDefaultCloumnMargin;
    }
}

/// 懒加载
- (NSMutableArray*)allCloumnBottomY_Arr{
    if(!_allCloumnBottomY_Arr){
        _allCloumnBottomY_Arr = [NSMutableArray array];
    }
    return _allCloumnBottomY_Arr;
}

- (NSMutableArray*)attrsArray{
    if(!_attrsArray){
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}





/// 重写-prepareLayout-方法
- (void)prepareLayout{
    [super prepareLayout];
    //初始化参数
    self.maxBottomY = 0;
    [self.allCloumnBottomY_Arr removeAllObjects];
    [self.attrsArray removeAllObjects];
    //给每一列添加对应的顶部y值
    for (NSInteger i = 0; i < self.cloumnNum; i ++) {
        [self.allCloumnBottomY_Arr addObject:@(0)];
    }
    //huo每一个cell的attrs
    for (NSInteger sec = 0; sec < self.sectionNum; sec ++) {
        
        //如果代理中实现了头部视图的方法，则代表存在头部视图，那么需要把headerview的attrs也添加进数组
        if([self.delegate respondsToSelector:@selector(headerViewSizeInInWaterFlowLayout:indexPath:)]){
            if ([self.delegate respondsToSelector:@selector(headerViewSizeInInWaterFlowLayout:indexPath:)]) {
                CGSize headerSize = [self.delegate headerViewSizeInInWaterFlowLayout:self indexPath:[NSIndexPath indexPathForItem:0 inSection:sec]];
                if ((headerSize.width > CGFLOAT_MIN) && (headerSize.height > CGFLOAT_MIN)) {
                    UICollectionViewLayoutAttributes * headerAttr =[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:sec]];
                    [self.attrsArray addObject:headerAttr];
                }
            }
        }
        //获取每一个sction中的cell的总h个数
        NSInteger rowNum = [self.collectionView numberOfItemsInSection:sec];
        for (NSInteger row = 0 ; row < rowNum; row ++) {
            UICollectionViewLayoutAttributes * attr = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:sec]];
            [self.attrsArray addObject:attr];
        }
        //如果代理中实现了尾部视图的方法，则代表存在头部视图，那么需要把fotterview的attrs也添加进数组
        if([self.delegate respondsToSelector:@selector(footerViewSizeInInWaterFlowLayout:indexPath:)]){
            if ([self.delegate respondsToSelector:@selector(headerViewSizeInInWaterFlowLayout:indexPath:)]) {
                CGSize footerSize = [self.delegate footerViewSizeInInWaterFlowLayout:self indexPath:[NSIndexPath indexPathForItem:0 inSection:sec]];
                if ((footerSize.width > CGFLOAT_MIN) && (footerSize.height > CGFLOAT_MIN)) {
                    UICollectionViewLayoutAttributes * footAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:sec]];
                    [self.attrsArray addObject:footAttr];
                }
            }
        }
    }
    
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

//实现每个cell的attrs
- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //创建空的attrs
     UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes  layoutAttributesForCellWithIndexPath:indexPath];
    //初始化frame，将最后的frame赋值e给cell。
    CGRect finalFrame = CGRectZero;
    CGFloat x = 0;//cell的otigin.x
    CGFloat y = 0;//cell的otigin.y
    CGFloat w = 0;//cell的size.width
    CGFloat h = 0;//cell的size.height
    //首先获取每个cell的宽度
    w = (self.collectionView.frame.size.width - self.cellEdgInset.left - self.cellEdgInset.right - (self.cloumnNum - 1)*self.rowMargin)/self.cloumnNum;
    //cell的高度
    h = [self.delegate itemSizeInWaterFlowLayout:self indexPath:indexPath].height;
    
    //接着我们找出所有列中高度最短的那一列出来
    NSInteger minColumnIndex = 0;
    CGFloat minBottom_Y = [self.allCloumnBottomY_Arr[0] doubleValue];
    for (NSInteger cloumnIndex = 0; cloumnIndex < self.allCloumnBottomY_Arr.count; cloumnIndex ++) {
        CGFloat indexBottom_Y = [self.allCloumnBottomY_Arr[cloumnIndex] doubleValue];
        if(indexBottom_Y < minBottom_Y){//
            minColumnIndex = cloumnIndex;
            minBottom_Y = indexBottom_Y;
        }
    }
    
    //接着取到了最短的那一列之后,就可以得到cell的x值
    x = self.cellEdgInset.left + (w + self.rowMargin) * minColumnIndex;
    //接着把cell添加到最短那一列的下面，记住，别忘记了列间距
    y = minBottom_Y + self.cloumnMargin ;
    
    //最后cell的frame确定了
    finalFrame = CGRectMake(x, y, w, h);
    
    //这时候我们需要更新一下每一列的最底部的距离
    self.allCloumnBottomY_Arr[minColumnIndex] = @(CGRectGetMaxY(finalFrame));
    
    
    //同时记录一下  所有方块中最底部的y值，未必就是刚刚加上的方块的最底部
    if(self.maxBottomY < [self.allCloumnBottomY_Arr[minColumnIndex] doubleValue]){
        self.maxBottomY = [self.allCloumnBottomY_Arr[minColumnIndex] doubleValue];
    }
    
    attrs.frame = finalFrame;
    
    return attrs;
    
}


- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, self.maxBottomY + self.cellEdgInset.bottom);
}

//实现头部和尾部的attrs，并且返回
- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attrs;
    //初始化frame，将最后的frame赋值e给头部或者尾部
    CGRect finalFrame = CGRectZero;
    CGFloat x = 0;//view的otigin.x
    CGFloat y = self.maxBottomY + self.cloumnMargin;//view的otigin.y
    CGFloat w = 0;
    CGFloat h = 0;//view的size.height
    if([elementKind isEqualToString:UICollectionElementKindSectionHeader]){
        
        attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];

        w = [self.delegate headerViewSizeInInWaterFlowLayout:self indexPath:indexPath].width;
        h = [self.delegate headerViewSizeInInWaterFlowLayout:self indexPath:indexPath].height;

        //更新maxY的值
        self.maxBottomY = y + h ;
        
        //更新每一列的最底部的值
//        [self.allCloumnBottomY_Arr removeAllObjects];
        for (NSInteger i = 0; i < self.allCloumnBottomY_Arr.count; i ++) {
            self.allCloumnBottomY_Arr[i] = @( self.maxBottomY);
        }
    }else{
        
        attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];

        w = [self.delegate footerViewSizeInInWaterFlowLayout:self indexPath:indexPath].width;
        h = [self.delegate footerViewSizeInInWaterFlowLayout:self indexPath:indexPath].height;

        //更新maxY的值
        self.maxBottomY = y + h ;
        
        //更新每一列的最底部的值
//        [self.allCloumnBottomY_Arr removeAllObjects];
        for (NSInteger i = 0; i < self.allCloumnBottomY_Arr.count; i ++) {
            self.allCloumnBottomY_Arr[i] = @( self.maxBottomY);
        }
    }
    finalFrame = CGRectMake(x, y, w, h);
    attrs.frame = finalFrame;
    return attrs;
}
@end
