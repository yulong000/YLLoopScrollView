//
//  YLCustomView.m
//  YLLoopScrollView
//
//  Created by weiyulong on 2018/7/29.
//  Copyright © 2018年 WYL. All rights reserved.
//

#import "YLCustomView.h"

@interface YLCustomView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation YLCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        self.imageView = [[UIImageView alloc] init];
        self.label = [[UILabel alloc] init];
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 100, 100);
    self.label.frame = CGRectMake(120, 0, 100, 30);
}

- (void)setModel:(YLCustomViewModel *)model {
    _model = model;
    self.imageView.image = [UIImage imageNamed:model.image];
    self.label.text = model.title;
}


@end

@implementation YLCustomViewModel
@end
