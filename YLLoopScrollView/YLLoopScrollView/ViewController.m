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
    
    NSArray *arr = @[@"http://i6.topit.me/6/5d/45/1131907198420455d6o.jpg",
                     @"http://pic.nipic.com/2007-11-09/2007119122519868_2.jpg",
                     @"http://pic25.nipic.com/20121209/9252150_194258033000_2.jpg",
                     @"http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg",
                     @"http://down.tutu001.com/d/file/20101129/2f5ca0f1c9b6d02ea87df74fcc_560.jpg"];
    NSArray *arr1 = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    YLLoopScrollView *scrollView = [YLLoopScrollView loopScrollViewWithTimer:3 customView:nil];
    scrollView.clickedBlock = ^(NSInteger index) {
        NSString * str = arr[index];
        NSLog(@"index : %ld  url : %@", index, str);
    };
    scrollView.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    scrollView.dataSourceArr = arr;
    [self.view addSubview:scrollView];

}


@end
