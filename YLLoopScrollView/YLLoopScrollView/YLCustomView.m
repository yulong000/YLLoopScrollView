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

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UISwitch *s;
@property (nonatomic, strong) UIControl *control;

@end

@implementation YLCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        self.imageView = [[UIImageView alloc] init];
        self.label = [[UILabel alloc] init];
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        self.btn = [[UIButton alloc] init];
        [self.btn setTitle:@"点我" forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:self.btn];
        
        self.s = [[UISwitch alloc] init];
        [self addSubview:self.s];
        
        self.control = [[UIControl alloc] init];
        self.control.backgroundColor = [UIColor greenColor];
        [self addSubview:self.control];
        
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 100, 100);
    self.label.frame = CGRectMake(120, 0, 100, 30);
    self.btn.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 30, 50, 30);
    self.s.frame = CGRectMake(0, self.frame.size.height - 40, 50, 40);
    self.control.frame = CGRectMake(self.frame.size.width - 100, 0, 100, 20);
}

- (void)setModel:(YLCustomViewModel *)model {
    _model = model;
    self.imageView.image = [UIImage imageNamed:model.image];
    self.label.text = model.title;
}

- (void)btnClick:(UIButton *)btn {
    NSLog(@"点击了按钮 :  点我");
    if(self.btnClickBlock) {
        self.btnClickBlock(self);
    }
}

- (void)controlClick {
    NSLog(@"点击了control");
}


@end

@implementation YLCustomViewModel
@end
