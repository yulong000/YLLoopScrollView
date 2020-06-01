//
//  YLCustomView.h
//  YLLoopScrollView
//
//  Created by weiyulong on 2018/7/29.
//  Copyright © 2018年 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLCustomViewModel;
@interface YLCustomView : UIView

@property (nonatomic, strong) YLCustomViewModel *model;

@property (nonatomic, copy)   void (^btnClickBlock)(YLCustomView *customView);
@end


@interface YLCustomViewModel : NSObject

@property (nonatomic, copy)   NSString *image;
@property (nonatomic, copy)   NSString *title;

@end
