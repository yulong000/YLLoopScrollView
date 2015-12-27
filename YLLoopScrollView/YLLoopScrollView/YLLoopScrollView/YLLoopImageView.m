//
//  YLLoopImageView.m
//  YLLoopScrollView
//
//  Created by DreamHand on 15/11/19.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import "YLLoopImageView.h"
#import "UIImageView+WebCache.h"

@implementation YLLoopImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark 设置网络图片
- (void)setUrl:(NSString *)url
{
    _url = [url copy];
    
    [self setImageWithURL:[NSURL URLWithString:_url] placeholderImage:self.placeholderImage options:SDWebImageRetryFailed];
}

#pragma mark 点击手势
- (void)tap:(UITapGestureRecognizer *)tap
{
    if(self.tapBlock)
    {
        __block typeof(self) blockSelf = self;
        self.tapBlock(blockSelf);
    }
}
@end
