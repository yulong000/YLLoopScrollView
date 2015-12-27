//
//  YLLoopImageView.h
//  YLLoopScrollView
//
//  Created by DreamHand on 15/11/19.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLLoopImageView;

/**
 *  点击回调
 */
typedef void (^TapBlock)(YLLoopImageView *imageView);

@interface YLLoopImageView : UIImageView

/**
 *  图片的url地址
 */
@property (nonatomic, copy) NSString *url;

/**
 *  默认显示的图片
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 *  点击回调
 */
@property (nonatomic, copy) TapBlock tapBlock;


@end
