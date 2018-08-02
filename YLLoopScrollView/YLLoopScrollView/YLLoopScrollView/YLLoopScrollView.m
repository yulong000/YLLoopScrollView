//
//  YLLoopScrollView.m
//  YLLoopScrollView
//
//  Created by weiyulong on 15/11/18.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import "YLLoopScrollView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface YLLoopScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YLLoopView *preView;
@property (nonatomic, strong) YLLoopView *currentView;
@property (nonatomic, strong) YLLoopView *nextView;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) int currentIndex;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval t;

@end

@interface YLLoopView : UIControl
@property (nonatomic, copy)   YLLoopScrollViewSetupBlock setupBlock;
@property (nonatomic, strong) NSString *customViewClass;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy)   NSString *property;
@property (nonatomic, strong) id obj;
@end

@implementation YLLoopScrollView

+ (instancetype)loopScrollViewWithTimer:(NSTimeInterval)time customView:(YLLoopScrollViewSetupBlock)setupBlock {
    YLLoopScrollView *loopView = [[YLLoopScrollView alloc] init];
    if(setupBlock == nil) {
        setupBlock = ^NSDictionary * {
            return @{@"YLImageView" : @"url"};
        };
    }
    loopView.preView.setupBlock = setupBlock;
    loopView.nextView.setupBlock = setupBlock;
    loopView.currentView.setupBlock = setupBlock;
    
    if(time > 0) {
        loopView.timer = [NSTimer scheduledTimerWithTimeInterval:time target:loopView selector:@selector(loop) userInfo:nil repeats:YES];
        loopView.t = time;
    }
    return loopView;
}

- (void)loop {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.preView = [[YLLoopView alloc] init];
        self.currentView = [[YLLoopView alloc] init];
        self.nextView = [[YLLoopView alloc] init];
        [self.preView addTarget:self action:@selector(loopViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.currentView addTarget:self action:@selector(loopViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.nextView addTarget:self action:@selector(loopViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.preView];
        [self.scrollView addSubview:self.currentView];
        [self.scrollView addSubview:self.nextView];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.userInteractionEnabled = NO;
        [self addSubview:self.pageControl];
        
        self.currentIndex = 0;
        self.showPageControl = YES;
        self.showPageControlAtBottom = NO;
    }
    return self;
}

- (void)loopViewClick:(YLLoopView *)loopView {
    if(self.clickedBlock) {
        self.clickedBlock(self.currentIndex);
    }
}
- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    if(showPageControl == NO) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
    [self setNeedsLayout];
}

- (void)setCurrentIndex:(int)currentIndex {
    _currentIndex = currentIndex;
    if(self.dataSourceArr.count) {
        self.pageControl.currentPage = currentIndex;
    }
}

- (void)setDataSourceArr:(NSArray *)dataSourceArr {
    _dataSourceArr = dataSourceArr;
    self.currentIndex = 0;
    if(dataSourceArr.count) {
        self.pageControl.numberOfPages = dataSourceArr.count;
        self.currentView.obj = dataSourceArr.firstObject;
        self.preView.obj = dataSourceArr.lastObject;
        if(dataSourceArr.count > 1) {
            self.nextView.obj = dataSourceArr[1];
        } else {
            self.nextView.obj = dataSourceArr.firstObject;
        }
        if(self.timer) {
            [self.timer fire];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.scrollView.contentOffset = CGPointMake(width, 0);
    self.scrollView.contentSize = CGSizeMake(width * 3, height);
    self.scrollView.contentInset = UIEdgeInsetsZero;
    if(self.showPageControl && self.showPageControlAtBottom) {
        self.scrollView.frame = CGRectMake(0, 0, width, height - kPageControlHeight);
    } else {
        self.scrollView.frame = self.bounds;
    }
    self.preView.frame = CGRectMake(0, 0, width, height);
    self.currentView.frame = CGRectMake(width, 0, width, height);
    self.nextView.frame = CGRectMake(width * 2, 0, width, height);
    self.pageControl.frame = CGRectMake(0, height - kPageControlHeight, width, kPageControlHeight);
}

#pragma mark - UIScrollview 代理方法
#pragma mark 将要开始手动拖拽，停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma mark 拖拽结束，开启计时器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self refreshScrollViewLayout];
    if(self.timer) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.t]];
    }
}
#pragma mark 已经停止滑动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self refreshScrollViewLayout];
}

#pragma mark 重新布局
- (void)refreshScrollViewLayout {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 向右滑动
    if (self.scrollView.contentOffset.x == 0) {
        // 滑动到了第一页
        for(YLLoopView *view in self.scrollView.subviews) {
            if(view.frame.origin.x > width * 1.5) {
                // 最后一页 放到第一页
                view.frame = CGRectMake(0, 0, width, height);
                self.preView = view;
                if(self.dataSourceArr.count == 1) {
                    self.preView.obj = self.dataSourceArr.firstObject;
                } else if(self.dataSourceArr.count == 2) {
                    if(self.currentIndex == 0)  self.preView.obj = self.dataSourceArr[0];
                    else self.preView.obj = self.dataSourceArr[1];
                } else {
                    if(self.currentIndex == 0){
                        self.preView.obj = self.dataSourceArr[self.dataSourceArr.count - 2];
                    } else if (self.currentIndex == 1) {
                        self.preView.obj = self.dataSourceArr[self.dataSourceArr.count - 1];
                    } else if (self.currentIndex == 2) {
                        self.preView.obj = self.dataSourceArr.firstObject;
                    } else {
                        self.preView.obj = self.dataSourceArr[self.currentIndex - 2];
                    }
                }
                if(--self.currentIndex < 0) {
                    self.currentIndex = (int)self.dataSourceArr.count - 1;
                }
            } else if (view.frame.origin.x < width * 0.5) {
                // 第一页 放到第二页
                view.frame = CGRectMake(width, 0, width, height);
                self.currentView = view;
            } else {
                // 第二页放到第三页
                view.frame = CGRectMake(width * 2, 0, width, height);
                self.nextView = view;
            }
        }
    }
    // 向左滑动
    else if(self.scrollView.contentOffset.x == width * 2) {
        // 把第1组数据删掉,在最后增加一组新的
        // 滑动到了第三页
        for(YLLoopView *view in self.scrollView.subviews) {
            if(view.frame.origin.x > width * 1.5) {
                // 最后一页 放到第二页
                view.frame = CGRectMake(width, 0, width, height);
                self.currentView = view;
            } else if (view.frame.origin.x < width * 0.5) {
                // 第一页 放到第三页
                view.frame = CGRectMake(width * 2, 0, width, height);
                self.nextView = view;
                if(self.dataSourceArr.count == 1) {
                    self.nextView.obj = self.dataSourceArr.firstObject;
                } else if(self.dataSourceArr.count == 2) {
                    if(self.currentIndex == 0)  self.nextView.obj = self.dataSourceArr[0];
                    else self.nextView.obj = self.dataSourceArr[1];
                } else {
                    if(self.currentIndex == self.dataSourceArr.count - 2){
                        self.nextView.obj = self.dataSourceArr.firstObject;
                    } else if(self.currentIndex == self.dataSourceArr.count - 1) {
                        self.nextView.obj = self.dataSourceArr[1];
                    } else if (self.currentIndex == self.dataSourceArr.count - 3) {
                        self.nextView.obj = self.dataSourceArr.lastObject;
                    } else {
                        self.nextView.obj = self.dataSourceArr[self.currentIndex + 2];
                    }
                }
                if(++ self.currentIndex >= self.dataSourceArr.count) {
                    self.currentIndex = 0;
                }
            } else {
                // 第二页放到第一页
                view.frame = CGRectMake(0, 0, width, height);
                self.preView = view;
            }
        }
    } else {
        return;
    }
    // 设置偏移量，使第二页处于中间
    self.scrollView.contentOffset = CGPointMake(width, 0);
}
@end

@implementation YLLoopView

- (void)setSetupBlock:(YLLoopScrollViewSetupBlock)setupBlock {
    _setupBlock = [setupBlock copy];
    self.customViewClass = self.setupBlock().allKeys.firstObject;
    self.property = self.setupBlock().allValues.firstObject;
    // 添加自定义view
    self.customView = [[NSClassFromString(self.customViewClass) alloc] init];
    if(self.customView) {
        self.customView.userInteractionEnabled = NO;
        [self addSubview:self.customView];
    }
}

- (void)setObj:(id)obj {
    _obj = obj;
    NSString *first = [self.property substringToIndex:1];
    NSString *other = [self.property substringFromIndex:1];
    NSString *set = [NSString stringWithFormat:@"set%@:", [[first uppercaseString] stringByAppendingString:other]];
    SEL sel = NSSelectorFromString(set);
    if([self.customView respondsToSelector:sel]) {
        ((void (*)(id,SEL,id))objc_msgSend)((id)self.customView, sel,obj);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.customView.frame = self.bounds;
}


@end

@implementation YLImageView

- (void)setUrl:(NSString *)url {
    _url = [url copy];
    if([url isKindOfClass:[NSNull class]] || url.length == 0)   return;
    NSURL *imageUrl;
    if([url isKindOfClass:[NSString class]]) {
        imageUrl = [NSURL URLWithString:_url];
    } else if([url isKindOfClass:[NSURL class]]){
        imageUrl = (NSURL *)_url;
    } else {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil && data.length) {
            // 获取到图片
            NSLog(@"图片下载成功 : %@", url);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image = [UIImage imageWithData:data];
            });
        } else {
            NSLog(@"图片下载失败 : %@  error : %@", url, error.userInfo);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image = nil;
            });
        }
    }];
    [task resume];
}

@end
