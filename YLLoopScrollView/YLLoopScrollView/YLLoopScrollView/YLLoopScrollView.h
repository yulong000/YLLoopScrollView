//
//  YLLoopScrollView.h
//  YLLoopScrollView
//
//  Created by DreamHand on 15/11/18.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLLoopImageView.h"

// 默认的定时器时间间隔
#define kDefaultTimeInterval 3.0

//  YLLoopScrollView 的轮播方向
typedef NS_ENUM(NSInteger, YLLoopScrollViewScrollDirection){
    
    YLLoopScrollViewScrollDirectionFromRightToLeft, // 从右向左滑动
    YLLoopScrollViewScrollDirectionFromLeftToRight  // 从左向右滑动
};


/**
 *  点击了某个imageView的回掉
 *  @param currentIndex imageView的序号
 */
typedef void(^ImageViewClickBlock)(YLLoopImageView *imageView, NSInteger currentIndex);


@class YLLoopScrollView;
@protocol YLLoopScrollViewDelegate <NSObject>
@optional

/**
 *  scrollView正在滑动
 *  @param scrollDirection 相对与初始位置的滑动方向
 */
- (void)loopScrollViewDidScroll:(YLLoopScrollView *)loopScrollView scrollDirection:(YLLoopScrollViewScrollDirection)scrollDirection;


/**
 *  scroolView 松开拖动的手指，将要开始减速
 */
- (void)loopScrollViewWillBeginDecelerating:(YLLoopScrollView *)loopScrollView;


/**
 *  scrollView停止滑动
 *  @param scrollDirection 相对与初始位置的滑动方向
 */
- (void)loopScrollView:(YLLoopScrollView *)loopScrollView didEndDeceleratingWithDirection:(YLLoopScrollViewScrollDirection)scrollDirection currentIndex:(NSInteger)index;

@end


@interface YLLoopScrollView : UIView

/**
 *  数据源,存放本地图片, 或者图片的URL地址(NSString类型)
 */
@property (nonatomic, strong, readonly) NSArray *dataSource;

/**
 *  点击了某个图片后的回掉
 */
@property (nonatomic, copy) ImageViewClickBlock imageViewClickBlock;

/**
 *  代理
 */
@property (nonatomic, weak) id <YLLoopScrollViewDelegate> delegate;


/**
 *  轮播的间隔时间 , default = 3
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;


//-------------- pageControl 属性设置-----------------//

/**
 *  是否显示pageControl  (default : YES)
 */
@property (nonatomic, assign) BOOL showPageControl;

/**
 *  pageControl 的 默认颜色
 */
@property (nonatomic, strong) UIColor *pageControlDefaultColor;
/**
 *  pageControl 的 当前选中的颜色
 */
@property (nonatomic, strong) UIColor *pageControlCurrentPageColor;




/**
 *  根据传入的本地图片,创建实例
 *
 *  @param frame     frame
 *  @param sourceArr 本地图片 name 的数组
 */
- (instancetype)initWithFrame:(CGRect)frame localImagesSource:(NSArray *)sourceArr;

/**
 *  根据传入的网络图片的URL地址(NSString), 创建实例
 *
 *  @param frame       frame
 *  @param sourceArr   url地址的数组
 *  @param holderImage 默认显示的图片
 */
- (instancetype)initWithFrame:(CGRect)frame imageUrlsSource:(NSArray *)sourceArr placeholderImage:(UIImage *)holderImage;

- (instancetype)initWithLocalImagesSource:(NSArray *)sourceArr;
- (instancetype)initWithImageUrlsSource:(NSArray *)sourceArr placeholderImage:(UIImage *)holderImage;

+ (instancetype)loopScrollViewWithFrame:(CGRect)frame localImagesSource:(NSArray *)sourceArr;
+ (instancetype)loopScrollViewWithFrame:(CGRect)frame imageUrlsSource:(NSArray *)sourceArr placeholderImage:(UIImage *)holderImage;

+ (instancetype)loopScrollViewWithLocalImagesSource:(NSArray *)sourceArr;
+ (instancetype)loopScrollViewWithImageUrlsSource:(NSArray *)sourceArr placeholderImage:(UIImage *)holderImage;

// 定时器
- (void)startTimer;
- (void)pauseTimer;

@end
