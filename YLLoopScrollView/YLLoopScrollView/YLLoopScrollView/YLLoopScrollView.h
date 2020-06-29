//
//  YLLoopScrollView.h
//  YLLoopScrollView
//
//  Created by weiyulong on 15/11/18.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>

// 默认的pageContorl的高度
#define kPageControlHeight 15
@class YLLoopScrollView;

// 滚动的方向
typedef NS_ENUM(NSInteger, YLLoopScrollViewScrollDirection) {
    YLLoopScrollViewScrollDirectionHorizontal,
    YLLoopScrollViewScrollDirectionVertical
};

// 字典里 key 对应的是customView的 class名字(如:@"UIImageView"), value对应的是customView的model名字(如:@"image"), 通过重写setter方法更新显示customView
typedef NSDictionary * (^YLLoopScrollViewSetupBlock)(void);
// 点击了customView返回当前点击的index
typedef void (^YLLoopScrollViewClickedBlock)(YLLoopScrollView *loopScrollView, NSInteger index);
// 滑动回调
typedef void (^YLLoopScrollViewDidScrollBlock)(YLLoopScrollView *loopScrollView, UIScrollView *scrollView);
// 手动滑动/自动滚动将要结束静止时回调
typedef void (^YLLoopScrollViewWillEndScrollBlock)(YLLoopScrollView *loopScrollView, UIScrollView *scrollView);
// 手动滑动/自动滚动结束静止后回调
typedef void (^YLLoopScrollViewDidEndScrollBlock)(YLLoopScrollView *loopScrollView, UIScrollView *scrollView);

//--------------------------------  YLLoopScrollView  -------------------------------------------/
@class YLLoopView;
@interface YLLoopScrollView : UIView

/**  数据源,对应customView的数据  */
@property (nonatomic, strong) NSArray *dataSourceArr;

/**  点击回调, 返回点击的 index  */
@property (nonatomic, copy)   YLLoopScrollViewClickedBlock clickedBlock;

/**  滑动回调  */
@property (nonatomic, copy  ) YLLoopScrollViewDidScrollBlock didScrollBlock;

/**  手动滑动/自动滚动将要结束时回调, 处理完数据后会回调  didEndScrollBlock */
@property (nonatomic, copy  ) YLLoopScrollViewWillEndScrollBlock willEndScrollBlock;

/**  手动滑动/自动滚动结束静止后回调  */
@property (nonatomic, copy  ) YLLoopScrollViewDidEndScrollBlock didEndScrollBlock;

/**  当前页码  */
@property (nonatomic, assign, readonly) int currentIndex;
/**  页面指示器  */
@property (nonatomic, readonly) UIPageControl *pageControl;
/**  是否显示页面指示器, default = YES  */
@property (nonatomic, assign) BOOL showPageControl;
/**  pageControl 和 customView 分开显示, default = NO , showPageControl == YES 时有效 */
@property (nonatomic, assign) BOOL showPageControlAtBottom;
/**  只有一条数据时是否滚动,默认 yes */
@property (nonatomic, assign) BOOL loopScrollWhenSingle;
/**  滚动方向,默认横向滚动,竖向滚动时会不显示pageControl  */
@property (nonatomic, assign) YLLoopScrollViewScrollDirection scrollDirection;
/**  当前显示的自定义view,  可以在 didEndScrollBlock 中获取得到当前的自定义view, 并进行其他操作 */
@property (nonatomic, weak, readonly)   id currentCustomView;

/**
 构造方法

 @param time 计时器时间间隔, time = 0 时不添加计时器
 @param setupBlock 设置自定义的view, 如果返回 nil, 则默认为 YLImageView, dataSourceArr 存放的是 url 的数组
 */
+ (instancetype)loopScrollViewWithTimer:(NSTimeInterval)time customView:(YLLoopScrollViewSetupBlock)setupBlock;

@end

//--------------------------------  YLLoopScrollView  -------------------------------------------/


// 举个栗子, dataSourceArr 里存放的是 url 的数组, setupBlock 返回的是 @{@"YLImageView" : @"url"}, 需要重写 url 的setter 方法
@interface YLImageView : UIImageView
/**  图片的网络地址  */
@property (nonatomic, copy)   NSString *url;

@end
