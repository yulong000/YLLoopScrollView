//
//  YLLoopScrollView.m
//  YLLoopScrollView
//
//  Created by DreamHand on 15/11/18.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import "YLLoopScrollView.h"
#import "YLLoopImageView.h"

@interface YLLoopScrollView () <UIScrollViewDelegate>
{
    YLLoopImageView *_firstImageView;
    YLLoopImageView *_secondImageView;
    YLLoopImageView *_thirdImageView;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  是否是网络图片
 */
@property (nonatomic, assign, getter=isUrlImages) BOOL urlImages;

/**
 *  当前显示的序号
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  默认显示的图片
 */
@property (nonatomic, strong) UIImage *placeholderImage;
@end

@implementation YLLoopScrollView


#pragma mark - 创建实例对象
- (instancetype)initWithFrame:(CGRect)frame localImagesSource:(NSArray *)sourceArr
{
    if(self = [super initWithFrame:frame])
    {
        [self initializeSubviews];
        _dataSource = sourceArr;
        self.urlImages = NO;
        self.showPageControl = YES;
        self.timeInterval = kDefaultTimeInterval;
        [self reloadData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageUrlsSource:(NSArray *)sourceArr placeholderImage:(UIImage *)holderImage
{
    if(self = [super initWithFrame:frame])
    {
        [self initializeSubviews];
        _dataSource = sourceArr;
        self.urlImages = YES;
        self.showPageControl = YES;
        self.placeholderImage = holderImage;
        self.timeInterval = kDefaultTimeInterval;
        [self reloadData];
    }
    return self;
}

- (instancetype)initWithLocalImagesSource:(NSArray *)sourceArr
{
    return [self initWithFrame:CGRectZero localImagesSource:sourceArr];
}

- (instancetype)initWithImageUrlsSource:(NSArray *)sourceArr placeholderImage:(UIImage *)holderImage
{
    return [self initWithFrame:CGRectZero imageUrlsSource:sourceArr placeholderImage:holderImage];
}

+ (instancetype)loopScrollViewWithFrame:(CGRect)frame localImagesSource:(NSArray *)sourceArr
{
    return [[[self class] alloc] initWithFrame:frame localImagesSource:sourceArr];
}

+ (instancetype)loopScrollViewWithFrame:(CGRect)frame imageUrlsSource:(NSArray *)sourceArr placeholderImage:(UIImage *)holderImage
{
    return [[[self class] alloc] initWithFrame:frame imageUrlsSource:sourceArr placeholderImage:holderImage];
}

+ (instancetype)loopScrollViewWithLocalImagesSource:(NSArray *)sourceArr
{
    return [[self class] loopScrollViewWithFrame:CGRectZero localImagesSource:sourceArr];
}
+ (instancetype)loopScrollViewWithImageUrlsSource:(NSArray *)sourceArr placeholderImage:(UIImage *)holderImage
{
    return [[self class] loopScrollViewWithFrame:CGRectZero imageUrlsSource:sourceArr placeholderImage:holderImage];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initializeSubviews];
    }
    return self;
}

- (instancetype)init
{
    if(self = [super init])
    {
        [self initializeSubviews];
    }
    return self;
}

#pragma mark 初始化子控件
- (void)initializeSubviews
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _firstImageView = [[YLLoopImageView alloc] init];
    _secondImageView = [[YLLoopImageView alloc] init];
    _thirdImageView = [[YLLoopImageView alloc] init];
    [_scrollView addSubview:_firstImageView];
    [_scrollView addSubview:_secondImageView];
    [_scrollView addSubview:_thirdImageView];
    
    __block typeof(self) blockSelf = self;
    _firstImageView.tapBlock = ^(YLLoopImageView *imageView){
        
        if(blockSelf.imageViewClickBlock)
        {
            blockSelf.imageViewClickBlock(imageView, imageView.tag);
        }
    };
    _secondImageView.tapBlock = ^(YLLoopImageView *imageView){
        
        if(blockSelf.imageViewClickBlock)
        {
            blockSelf.imageViewClickBlock(imageView, imageView.tag);
        }
    };
    _thirdImageView.tapBlock = ^(YLLoopImageView *imageView){
        
        if(blockSelf.imageViewClickBlock)
        {
            blockSelf.imageViewClickBlock(imageView, imageView.tag);
        }
    };
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.defersCurrentPageDisplay = YES;
    [_pageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}
#pragma mark 设置frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;
    _firstImageView.frame = CGRectMake(0, 0, width, height);
    _secondImageView.frame = CGRectMake(width, 0, width, height);
    _thirdImageView.frame = CGRectMake(width * 2, 0, width, height);
    
    _pageControl.frame = CGRectMake(0, height - 10, width, 10);
}
#pragma mark - 更改了pageControl的值
- (void)pageControlValueChange:(UIPageControl *)pageControl
{
    if(pageControl.currentPage == self.currentIndex + 1)
    {
        // 向右循环
        [UIView animateWithDuration:0.5 animations:^{
            
            _scrollView.contentOffset = CGPointMake(self.frame.size.width * 2, 0);
            
        } completion:^(BOOL finished) {
            
            [self scrollViewDidEndDecelerating:_scrollView];
            
        }];
    }
    else if (pageControl.currentPage == self.currentIndex - 1)
    {
        // 向左循环
        [UIView animateWithDuration:0.5 animations:^{
            
            _scrollView.contentOffset = CGPointZero;
            
        } completion:^(BOOL finished) {
            
            [self scrollViewDidEndDecelerating:_scrollView];
            
        }];
    }
}
#pragma mark 是否显示分页控件
- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    
    _pageControl.hidden = !showPageControl;
}
#pragma mark 设置pageControl 的默认颜色
- (void)setPageControlDefaultColor:(UIColor *)pageControlDefaultColor
{
    _pageControlDefaultColor = pageControlDefaultColor;
    
    _pageControl.pageIndicatorTintColor = _pageControlDefaultColor;
}
#pragma mark 设置pageControl 的当前页面的颜色
- (void)setPageControlCurrentPageColor:(UIColor *)pageControlCurrentPageColor
{
    _pageControlCurrentPageColor = pageControlCurrentPageColor;
    
    _pageControl.currentPageIndicatorTintColor = pageControlCurrentPageColor;
}

#pragma mark - 设置定时器的时间间隔
- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval <= 0.0 ? kDefaultTimeInterval : timeInterval;
}

#pragma mark 开始定时器
- (void)startTimer
{
    if(self.timer == nil)
    {
        self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval] interval:self.timeInterval target:self selector:@selector(updateCurrentPage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    else
    {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]];
    }
}

#pragma mark 暂停定时器
- (void)pauseTimer
{
    if(self.timer)
    {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark 从父控件移除后，销毁计时器
- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 轮播, 更新页面
- (void)updateCurrentPage
{
    // 向右循环
    [UIView animateWithDuration:0.5 animations:^{
        
        _scrollView.contentOffset = CGPointMake(self.frame.size.width * 2, 0);
        
    } completion:^(BOOL finished) {
        
        [self scrollViewDidEndDecelerating:_scrollView];
        
    }];
}

#pragma mark 刷新显示数据
- (void)reloadData
{
    if(self.dataSource.count == 0)  return;
    
    NSString *secondImage = self.dataSource.firstObject;
    NSString *firstImage = self.dataSource.lastObject;
    NSString *thirdImage = self.dataSource.count == 1 ? self.dataSource.firstObject : self.dataSource[1];
    
    _firstImageView.placeholderImage = self.placeholderImage;
    _secondImageView.placeholderImage = self.placeholderImage;
    _thirdImageView.placeholderImage = self.placeholderImage;
    
    if(self.isUrlImages)
    {
        _firstImageView.url = firstImage;
        _secondImageView.url = secondImage;
        _thirdImageView.url = thirdImage;
    }
    else
    {
        _firstImageView.image = [UIImage imageNamed:firstImage];
        _secondImageView.image = [UIImage imageNamed:secondImage];
        _thirdImageView.image = [UIImage imageNamed:thirdImage];
    }
    
    self.currentIndex = 0;
    _pageControl.numberOfPages = self.dataSource.count;
    _pageControl.currentPage = self.currentIndex;
}

#pragma mark - UIScrollview 代理方法
#pragma mark 滑动过程中多次调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    YLLoopScrollViewScrollDirection direction = YLLoopScrollViewScrollDirectionFromLeftToRight;
    if(scrollView.contentOffset.x > self.frame.size.width)
    {
        direction = YLLoopScrollViewScrollDirectionFromRightToLeft;
    }
    
    if([self.delegate respondsToSelector:@selector(loopScrollViewDidScroll:scrollDirection:)] && _scrollView.contentOffset.x != self.frame.size.width)
    {
        [self.delegate loopScrollViewDidScroll:self scrollDirection:direction];
    }
}
#pragma mark 将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(self.timer.valid)
    {
        [self pauseTimer];
    }
}
#pragma mark 将要停止拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}
#pragma mark 停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
#pragma mark 停止拖拽，将要开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(loopScrollViewWillBeginDecelerating:)])
    {
        [self.delegate loopScrollViewWillBeginDecelerating:self];
    }
}
#pragma mark 已经停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.timer.valid)
    {
        [self startTimer];
    }
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 向右滑动
    if (_scrollView.contentOffset.x == 0)
    {
        self.currentIndex--;
        if(self.currentIndex < 0)
        {
            self.currentIndex = self.dataSource.count - 1;
        }
        // 滑动到了第一页
        for(YLLoopImageView *imageView in _scrollView.subviews)
        {
            if(imageView.frame.origin.x > width * 1.5)
            {
                // 最后一页 放到第一页
                imageView.frame = CGRectMake(0, 0, width, height);
                imageView.tag = self.currentIndex - 1 < 0 ? self.dataSource.count - 1 : self.currentIndex - 1;
                
                if(self.isUrlImages)
                {
                    imageView.url = self.dataSource[imageView.tag];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:self.dataSource[imageView.tag]];
                }
            }
            else if (imageView.frame.origin.x < width * 0.5)
            {
                // 第一页 放到第二页
                imageView.frame = CGRectMake(width, 0, width, height);
                imageView.tag = self.currentIndex;
            }
            else
            {
                // 第二页放到第三页
                imageView.frame = CGRectMake(width * 2, 0, width, height);
                imageView.tag = self.currentIndex + 1 >= self.dataSource.count ? 0 : self.currentIndex + 1;
                if(self.isUrlImages)
                {
                    imageView.url = self.dataSource[imageView.tag];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:self.dataSource[imageView.tag]];
                }
            }
        }
        _scrollView.contentOffset = CGPointMake(width, 0);
        _pageControl.currentPage = self.currentIndex;
        
        if([self.delegate respondsToSelector:@selector(loopScrollView:didEndDeceleratingWithDirection: currentIndex:)])
        {
            [self.delegate loopScrollView:self didEndDeceleratingWithDirection:YLLoopScrollViewScrollDirectionFromLeftToRight currentIndex:self.currentIndex];
        }
    }
    // 向左滑动
    else if(_scrollView.contentOffset.x == width * 2)
    {
        self.currentIndex++;
        if(self.currentIndex >= self.dataSource.count)
        {
            self.currentIndex = 0;
        }
        // 滑动到了第三页
        for(YLLoopImageView *imageView in _scrollView.subviews)
        {
            if(imageView.frame.origin.x > width * 1.5)
            {
                // 最后一页 放到第二页
                imageView.frame = CGRectMake(width, 0, width, height);
                imageView.tag = self.currentIndex;
            }
            else if (imageView.frame.origin.x < width * 0.5)
            {
                // 第一页 放到第三页
                imageView.frame = CGRectMake(width * 2, 0, width, height);
                imageView.tag = self.currentIndex + 1 >= self.dataSource.count ? 0 : self.currentIndex + 1;
                
                if(self.isUrlImages)
                {
                    imageView.url = self.dataSource[imageView.tag];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:self.dataSource[imageView.tag]];
                }
            }
            else
            {
                // 第二页放到第一页
                imageView.frame = CGRectMake(0, 0, width, height);
                imageView.tag = self.currentIndex - 1 < 0 ? self.dataSource.count - 1 : self.currentIndex - 1;
                if(self.isUrlImages)
                {
                    imageView.url = self.dataSource[imageView.tag];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:self.dataSource[imageView.tag]];
                }
            }
        }
        _scrollView.contentOffset = CGPointMake(width, 0);
        _pageControl.currentPage = self.currentIndex;
        
        if([self.delegate respondsToSelector:@selector(loopScrollView:didEndDeceleratingWithDirection: currentIndex:)])
        {
            [self.delegate loopScrollView:self didEndDeceleratingWithDirection:YLLoopScrollViewScrollDirectionFromRightToLeft currentIndex:self.currentIndex];
        }
    }
}

#pragma mark 停止带动画的滚动（setContentOffsize/scrollRectVisible:  animated: 结束时有效）在scrollViewDidEndDecelerating 后调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}
@end
