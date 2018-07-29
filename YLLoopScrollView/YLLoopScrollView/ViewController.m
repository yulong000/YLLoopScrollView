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
    NSArray *arr = @[@"http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg",
                     @"http://pic.nipic.com/2007-11-09/2007119122519868_2.jpg",
                     @"http://pic25.nipic.com/20121209/9252150_194258033000_2.jpg",
                     @"http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg",
                     @"http://down.tutu001.com/d/file/20101129/2f5ca0f1c9b6d02ea87df74fcc_560.jpg"];
    
    YLLoopScrollView *scrollView = [YLLoopScrollView loopScrollViewWithTimer:3 customView:nil];
    scrollView.clickedBlock = ^(NSInteger index) {
        NSString * str = arr[index];
        NSLog(@"index : %ld  url : %@", index, str);
    };
    // ------------------- //
    // 根据自己需求设置
//    scrollView.showPageControl = NO;
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    scrollView.showPageControlAtBottom = YES;
    // ------------------- //
    scrollView.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    scrollView.dataSourceArr = arr;
    [self.view addSubview:scrollView];
    
    YLCustomViewModel *model1 = [self modelWithImage:@"1.jpg" title:@"图片1"];
    YLCustomViewModel *model2 = [self modelWithImage:@"2.jpg" title:@"图片2"];
    YLCustomViewModel *model3 = [self modelWithImage:@"3.jpg" title:@"图片3"];
    YLCustomViewModel *model4 = [self modelWithImage:@"4.jpg" title:@"图片4"];
    NSArray *arr1 = @[model1, model2, model3, model4];
    YLLoopScrollView *scrollView1 = [YLLoopScrollView loopScrollViewWithTimer:4 customView:^NSDictionary *{
        return @{@"YLCustomView" : @"model"};
    }];
    scrollView1.clickedBlock = ^(NSInteger index) {
        YLCustomViewModel *model = arr1[index];
        NSLog(@"index : %ld  title : %@", index, model.title);
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
