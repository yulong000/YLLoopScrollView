//
//  ViewController.m
//  YLLoopScrollView
//
//  Created by DreamHand on 15/11/18.
//  Copyright © 2015年 WYL. All rights reserved.
//

#import "ViewController.h"
#import "YLLoopScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    YLLoopScrollView *scrollView1 = [[YLLoopScrollView alloc] initWithFrame:CGRectMake(20, 50, 300, 100) localImagesSource:@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"]];
    [scrollView1 startTimer];
    NSArray *arr = @[@"http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg",
                     @"http://pic.nipic.com/2007-11-09/2007119122519868_2.jpg",
                     @"http://pic25.nipic.com/20121209/9252150_194258033000_2.jpg",
                     @"http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg",
                     @"http://down.tutu001.com/d/file/20101129/2f5ca0f1c9b6d02ea87df74fcc_560.jpg"];
    
    YLLoopScrollView *scrollView2 = [[YLLoopScrollView alloc] initWithFrame:CGRectMake(20, 250, 300, 100) imageUrlsSource:arr placeholderImage:[UIImage imageNamed:@"1.jpg"]];
//    YLLoopScrollView *scrollView2 = [[YLLoopScrollView alloc] initWithFrame:CGRectMake(20, 250, 300, 100) imageUrlsSource:arr placeholderImage:nil];
    scrollView2.showPageControl = NO;
    scrollView2.imageViewClickBlock = ^(YLLoopImageView *imageView, NSInteger index){
      
        NSLog(@"url : %@, index : %ld", imageView.url, index);
    };
    
    
    YLLoopScrollView *scrollView3 = [[YLLoopScrollView alloc] initWithLocalImagesSource:@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"]];
    scrollView3.frame = CGRectMake(20, 400, 300, 100);
    scrollView3.showPageControl = YES;
    scrollView3.timeInterval = 2;
    [scrollView3 startTimer];
    scrollView3.pageControlDefaultColor = [UIColor redColor];
    scrollView3.pageControlCurrentPageColor = [UIColor greenColor];
    
    [self.view addSubview:scrollView1];
    [self.view addSubview:scrollView2];
    [self.view addSubview:scrollView3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
