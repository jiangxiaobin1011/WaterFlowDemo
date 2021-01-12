//
//  JWaterFlowLauput.h
//  WaterFlowDemo
//
//  Created by jiangbin on 2020/5/11.
//  Copyright © 2020 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JWaterFlowLauput;

@protocol JWaterFlowLayoutDelegate <NSObject>



@required   //必须要实现的方法

/// 设置总section数
/// @param flowLayout flowLayout
- (NSInteger)secionCountInWaterFlowLayout:(JWaterFlowLauput*)flowLayout;

/// 设置列数
/// @param flowLayout flowLayout
- (NSInteger)cloumnCountInWaterFlowLayout:(JWaterFlowLauput*)flowLayout;

/// cell的size
/// @param flowLayout flowLayout
- (CGSize)itemSizeInWaterFlowLayout:(JWaterFlowLauput*)flowLayout indexPath:(NSIndexPath*)indexPath;


@optional   //可选方法

/// 配置cell的边缘间距
/// @param flowLayout flowLayout
- (UIEdgeInsets)cellEdgeInsetsInWaterFlowLayout:(JWaterFlowLauput*)flowLayout;


/// 配置cell的行间距
/// @param flowLayout flowLayout
- (CGFloat)cellRowMarginInWaterFlowLayout:(JWaterFlowLauput*)flowLayout;


/// 配置cell的列间距
/// @param flowLayout flowLayout description
- (CGFloat)cellCloumnMarginInWaterFlowLayout:(JWaterFlowLauput*)flowLayout;



/// 配置section的头部视图
/// @param flowLayout flowLayout
/// @param indexPath indexPath
- (CGSize)headerViewSizeInInWaterFlowLayout:(JWaterFlowLauput*)flowLayout indexPath:(NSIndexPath*)indexPath;


/// 配置section的尾部视图
/// @param flowLayout fla
/// @param indexPath zz
- (CGSize)footerViewSizeInInWaterFlowLayout:(JWaterFlowLauput*)flowLayout indexPath:(NSIndexPath*)indexPath;


@end




@interface JWaterFlowLauput : UICollectionViewFlowLayout

//代理
@property (nonatomic , weak) id<JWaterFlowLayoutDelegate> delegate;

@end




NS_ASSUME_NONNULL_END
