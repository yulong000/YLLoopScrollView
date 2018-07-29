//
//  YLLoopScrollView.h
//  YLLoopScrollView
//
//  Created by DreamHand on 15/11/18.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLLoopView;

// 点击了customView返回当前点击的index
typedef void (^YLLoopScrollViewClickedBlock)(NSInteger index);
// 字典里 key 对应的是customView的 class名字(如:@"UIImageView"), value对应的是customView的model名字(如:@"image"), 通过重写setter方法更新显示customView
typedef NSDictionary * (^YLLoopScrollViewSetupBlock)(void);

//--------------------------------  YLLoopScrollView  -------------------------------------------/

@interface YLLoopScrollView : UIView

/**  点击回调, 返回点击的 index  */
@property (nonatomic, copy)   YLLoopScrollViewClickedBlock clickedBlock;

/**  数据源,对应customView的数据  */
@property (nonatomic, strong) NSArray *dataSourceArr;

/**
 构造方法

 @param time 计时器时间间隔, time = 0 时不添加计时器
 @param customView 设置自定义的view, 如果返回 nil, 则默认为 YLImageView, dataSourceArr 存放的是 url 的数组
 */
+ (instancetype)loopScrollViewWithTimer:(NSTimeInterval)time customView:(YLLoopScrollViewSetupBlock)setupBlock;

@end

//--------------------------------  YLLoopScrollView  -------------------------------------------/


// 举个栗子, dataSourceArr 里存放的是 url 的数组, setupBlock 返回的是 @{@"YLImageView" : @"url"}, 需要重写 url 的setter 方法
@interface YLImageView : UIImageView
/**  图片的网络地址  */
@property (nonatomic, copy)   NSString *url;

@end
