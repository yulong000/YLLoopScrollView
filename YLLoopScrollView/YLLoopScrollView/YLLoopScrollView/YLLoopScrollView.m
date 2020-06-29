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

@interface YLLoopView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, copy)   YLLoopScrollViewSetupBlock setupBlock;
@property (nonatomic, copy)   void (^touchBlock)(YLLoopView *loopView);
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
    loopView.t = time;
    return loopView;
}

- (void)loop {
    if(self.scrollDirection == YLLoopScrollViewScrollDirectionHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height * 2) animated:YES];
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
        self.scrollView.contentInset = UIEdgeInsetsZero;
        [self addSubview:self.scrollView];
        
        self.preView = [[YLLoopView alloc] init];
        self.currentView = [[YLLoopView alloc] init];
        self.nextView = [[YLLoopView alloc] init];
        [self.scrollView addSubview:self.preView];
        [self.scrollView addSubview:self.currentView];
        [self.scrollView addSubview:self.nextView];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.userInteractionEnabled = NO;
        [self addSubview:self.pageControl];
        
        __weak typeof(self) weakSelf = self;
        self.preView.touchBlock = ^(YLLoopView *loopView) {
            if(weakSelf.clickedBlock) {
                weakSelf.clickedBlock(weakSelf, weakSelf.currentIndex);
            }
        };
        self.currentView.touchBlock = ^(YLLoopView *loopView) {
            if(weakSelf.clickedBlock) {
                weakSelf.clickedBlock(weakSelf, weakSelf.currentIndex);
            }
        };
        self.nextView.touchBlock = ^(YLLoopView *loopView) {
            if(weakSelf.clickedBlock) {
                weakSelf.clickedBlock(weakSelf, weakSelf.currentIndex);
            }
        };
        
        _currentIndex = 0;
        _showPageControl = YES;
        _showPageControlAtBottom = NO;
        _scrollDirection = YLLoopScrollViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (id)currentCustomView {
    return self.currentView.subviews.firstObject;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    if(showPageControl == NO) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
    [self setNeedsLayout];
}

- (void)setShowPageControlAtBottom:(BOOL)showPageControlAtBottom {
    _showPageControlAtBottom = showPageControlAtBottom;
    [self setNeedsLayout];
}

- (void)setCurrentIndex:(int)currentIndex {
    _currentIndex = currentIndex;
    if(self.dataSourceArr.count) {
        self.pageControl.currentPage = currentIndex;
    }
}

- (void)setLoopScrollWhenSingle:(BOOL)loopScrollWhenSingle {
    _loopScrollWhenSingle = loopScrollWhenSingle;
    self.dataSourceArr = self.dataSourceArr;
    [self setNeedsLayout];
}

- (void)setScrollDirection:(YLLoopScrollViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    if(scrollDirection == YLLoopScrollViewScrollDirectionVertical) {
        self.showPageControl = NO;
    }
    [self setNeedsLayout];
}

- (void)setDataSourceArr:(NSArray *)dataSourceArr {
    _dataSourceArr = dataSourceArr;
    self.currentIndex = 0;
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if(dataSourceArr.count) {
        if(self.loopScrollWhenSingle == NO && dataSourceArr.count == 1) {
            self.currentView.obj = dataSourceArr.firstObject;
            self.pageControl.hidden = YES;
        } else {
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = dataSourceArr.count;
            self.currentView.obj = dataSourceArr.firstObject;
            self.preView.obj = dataSourceArr.lastObject;
            if(dataSourceArr.count > 1) {
                self.nextView.obj = dataSourceArr[1];
            } else {
                self.nextView.obj = dataSourceArr.firstObject;
            }
            if(self.t > 0) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:self.t target:self selector:@selector(loop) userInfo:nil repeats:YES];
            }
        }
    } else {
        self.currentView.obj = self.preView.obj = self.nextView.obj = nil;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    if(self.didEndScrollBlock) {
        self.didEndScrollBlock(self, self.scrollView);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(self.scrollDirection == YLLoopScrollViewScrollDirectionHorizontal) {
        self.pageControl.frame = CGRectMake(0, self.frame.size.height - kPageControlHeight, self.frame.size.width, kPageControlHeight);
        if(self.showPageControl && self.showPageControlAtBottom) {
            self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kPageControlHeight);
        } else {
            self.scrollView.frame = self.bounds;
        }
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat height = self.scrollView.frame.size.height;
        if(self.loopScrollWhenSingle == NO && self.dataSourceArr.count <= 1) {
            self.preView.hidden = self.nextView.hidden = YES;
            self.scrollView.contentSize = CGSizeMake(width, height);
            self.scrollView.contentOffset = CGPointZero;
            self.currentView.frame = self.scrollView.bounds;
        } else {
            self.preView.hidden = self.nextView.hidden = NO;
            self.scrollView.contentOffset = CGPointMake(width, 0);
            self.scrollView.contentSize = CGSizeMake(width * 3, height);
            self.preView.frame = CGRectMake(0, 0, width, height);
            self.currentView.frame = CGRectMake(width, 0, width, height);
            self.nextView.frame = CGRectMake(width * 2, 0, width, height);
        }
    } else {
        self.scrollView.frame = self.bounds;
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat height = self.scrollView.frame.size.height;
        if(self.loopScrollWhenSingle == NO && self.dataSourceArr.count <= 1) {
            self.preView.hidden = self.nextView.hidden = YES;
            self.scrollView.contentSize = CGSizeMake(width, height);
            self.scrollView.contentOffset = CGPointZero;
            self.currentView.frame = self.scrollView.bounds;
        } else {
            self.preView.hidden = self.nextView.hidden = NO;
            self.scrollView.contentOffset = CGPointMake(0, height);
            self.scrollView.contentSize = CGSizeMake(width, height * 3);
            self.preView.frame = CGRectMake(0, 0, width, height);
            self.currentView.frame = CGRectMake(0, height, width, height);
            self.nextView.frame = CGRectMake(0, height * 2, width, height);
        }
    }
}

#pragma mark - UIScrollview 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.didScrollBlock) {
        self.didScrollBlock(self, scrollView);
    }
}

#pragma mark 将要开始手动拖拽，停止计时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer setFireDate:[NSDate distantFuture]];
}

#pragma mark 拖拽结束，开启计时器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(self.willEndScrollBlock) {
        self.willEndScrollBlock(self, scrollView);
    }
    [self refreshScrollViewLayout];
    if(self.timer) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.t]];
    }
    if(self.didEndScrollBlock) {
        self.didEndScrollBlock(self, scrollView);
    }
}

#pragma mark 已经停止滑动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if(self.willEndScrollBlock) {
        self.willEndScrollBlock(self, scrollView);
    }
    [self refreshScrollViewLayout];
    if(self.didEndScrollBlock) {
        self.didEndScrollBlock(self, scrollView);
    }
}

#pragma mark 重新布局
- (void)refreshScrollViewLayout {
    if(self.dataSourceArr.count == 0)   return;
    CGFloat width = self.currentView.frame.size.width;
    CGFloat height = self.currentView.frame.size.height;
    if(self.scrollDirection == YLLoopScrollViewScrollDirectionHorizontal) {
        // 横向滚动
        if (self.scrollView.contentOffset.x == 0) {
            // 向右滑动
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
        } else if(self.scrollView.contentOffset.x == width * 2) {
            // 向左滑动
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
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    } else {
        // 纵向滑动
        if (self.scrollView.contentOffset.y == 0) {
            // 向下滑动
            // 滑动到了第一页
            for(YLLoopView *view in self.scrollView.subviews) {
                if(view.frame.origin.y > height * 1.5) {
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
                } else if (view.frame.origin.y < height * 0.5) {
                    // 第一页 放到第二页
                    view.frame = CGRectMake(0, height, width, height);
                    self.currentView = view;
                } else {
                    // 第二页放到第三页
                    view.frame = CGRectMake(0, height * 2, width, height);
                    self.nextView = view;
                }
            }
        } else if(self.scrollView.contentOffset.y == height * 2) {
            // 向上滑动
            // 把第1组数据删掉,在最后增加一组新的
            // 滑动到了第三页
            for(YLLoopView *view in self.scrollView.subviews) {
                if(view.frame.origin.y > height * 1.5) {
                    // 最后一页 放到第二页
                    view.frame = CGRectMake(0, height, width, height);
                    self.currentView = view;
                } else if (view.frame.origin.y < height * 0.5) {
                    // 第一页 放到第三页
                    view.frame = CGRectMake(0, height * 2, width, height);
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
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
}
@end

@implementation YLLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setSetupBlock:(YLLoopScrollViewSetupBlock)setupBlock {
    _setupBlock = [setupBlock copy];
    self.customViewClass = self.setupBlock().allKeys.firstObject;
    self.property = self.setupBlock().allValues.firstObject;
    // 添加自定义view
    self.customView = [[NSClassFromString(self.customViewClass) alloc] init];
    if(self.customView) {
        [self addSubview:self.customView];
    }
}

- (void)setObj:(id)obj {
    if(obj) {
        _obj = obj;
        if(self.customView.superview == nil) {
            [self addSubview:self.customView];
            [self setNeedsLayout];
        }
        NSString *first = [self.property substringToIndex:1];
        NSString *other = [self.property substringFromIndex:1];
        NSString *set = [NSString stringWithFormat:@"set%@:", [[first uppercaseString] stringByAppendingString:other]];
        SEL sel = NSSelectorFromString(set);
        if([self.customView respondsToSelector:sel]) {
            ((void (*)(id,SEL,id))objc_msgSend)((id)self.customView, sel,obj);
        }
    } else {
        [self.customView removeFromSuperview];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.customView.frame = self.bounds;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if(self.touchBlock) {
        self.touchBlock(self);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[UIControl class]] ||
       [touch.view isKindOfClass:[UITableView class]] ||
       [touch.view isKindOfClass:[UICollectionView class]]) {
        return NO;
    }
    return YES;
}


@end

@implementation YLImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

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
