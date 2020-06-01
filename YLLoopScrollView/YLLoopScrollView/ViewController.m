//
//  ViewController.m
//  YLLoopScrollView
//
//  Created by DreamHand on 15/11/18.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import "ViewController.h"
#import "YLLoopScrollView.h"
#import "YLCustomView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //-------------------------------------------- 样式1 --------------------------------------------//
    NSArray *arr = @[@"http://imgsrc.baidu.com/imgad/pic/item/7c1ed21b0ef41bd595ff4fdf5ada81cb39db3d68.jpg",
                     @"http://www.qqma.com/imgpic2/cpimagenew/2018/4/5/6e1de60ce43d4bf4b9671d7661024e7a.jpg",
                     @"http://img.zcool.cn/community/011a5859ac137ea8012028a92fc78a.jpg@1280w_1l_2o_100sh.jpg",
                     @"http://img.zcool.cn/community/01c60259ac0f91a801211d25904e1f.jpg@1280w_1l_2o_100sh.jpg"];
    
    YLLoopScrollView *scrollView = [YLLoopScrollView loopScrollViewWithTimer:3 customView:nil];
    scrollView.clickedBlock = ^(YLLoopScrollView *loopScrollView, NSInteger index) {
        NSString * str = arr[index];
        NSLog(@"index : %ld  url : %@", index, str);
    };
    // ------------------- //
    // 根据自己需求设置
//    scrollView.showPageControl = NO;
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    scrollView.showPageControlAtBottom = YES;
    scrollView.scrollDirection = YLLoopScrollViewScrollDirectionVertical;
    // ------------------- //
    scrollView.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    scrollView.dataSourceArr = arr;
    [self.view addSubview:scrollView];
    
    
    //-------------------------------------------- 样式2 --------------------------------------------//
    YLCustomViewModel *model1 = [self modelWithImage:@"1.jpg" title:@"图片1"];
    YLCustomViewModel *model2 = [self modelWithImage:@"2.jpg" title:@"图片2"];
    YLCustomViewModel *model3 = [self modelWithImage:@"3.jpg" title:@"图片3"];
    YLCustomViewModel *model4 = [self modelWithImage:@"4.jpg" title:@"图片4"];
    NSArray *arr1 = @[model1, model2, model3, model4];
    YLLoopScrollView *scrollView1 = [YLLoopScrollView loopScrollViewWithTimer:4 customView:^NSDictionary *{
        return @{@"YLCustomView" : @"model"};
    }];
    scrollView1.clickedBlock = ^(YLLoopScrollView *loopScrollView, NSInteger index) {
        YLCustomViewModel *model = arr1[index];
        NSLog(@"index : %ld  title : %@", index, model.title);
    };
    scrollView1.didEndScrollBlock = ^(YLLoopScrollView *loopScrollView, UIScrollView *scrollView) {
        YLCustomView *custom = loopScrollView.currentCustomView;
        custom.btnClickBlock = ^(YLCustomView *customView) {
            NSLog(@"点击了自定义view上的按钮 : %d --> 标题 : %@", loopScrollView.currentIndex, customView.model.title);
        };
    };
    scrollView.didScrollBlock = ^(YLLoopScrollView *loopScrollView, UIScrollView *scrollView) {
        
    };
    scrollView1.dataSourceArr = arr1;
    scrollView1.frame = CGRectMake(0, 300, self.view.frame.size.width, 150);
    [self.view addSubview:scrollView1];

}

- (YLCustomViewModel *)modelWithImage:(NSString *)image title:(NSString *)title {
    YLCustomViewModel *model = [[YLCustomViewModel alloc] init];
    model.image = image;
    model.title = title;
    return model;
}


@end
