# YLLoopScrollView
### 无限轮播, 可以是图片, 可以是任意的自定义view

### 使用教程:
-------
#### 1.导入头文件
```Objective-c
#import "YLLoopScrollView.h"
```

#### 2.调用类方法构造实例对象
```Objective-c
// 传入轮播的时间(0 代表不启用定时器),需要轮播的自定义view,和需要重新赋值的model
YLLoopScrollView *scrollView = [YLLoopScrollView loopScrollViewWithTimer:2 customView:^NSDictionary *{
        return @{@"YLCustomView" : @"model"};
    }];

```
#### 3.设置回调block
``` Objective-c
scrollView.clickedBlock = ^(NSInteger index) {
        NSLog(@"index : %d", index);
    };
    
```
#### 4.设置数据源
```Objective-c
// arr里存放的是自定义view的model
scrollView.dataSourceArr = arr;
```
#### 5.设置frame
```Objective-c
scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
```
#### 6.添加到父视图
```Objective-c
[self.view addSubview:scrollView];
```

so easy ~~~ (具体使用方法请看demo)
----------

### 最简单的应用
``` Objective-c
NSArray *arr = @[[UIImage imageNamed:@"1.jpg"],
                     [UIImage imageNamed:@"2.jpg"],
                     [UIImage imageNamed:@"3.jpg"],
                     [UIImage imageNamed:@"4.jpg"]];
    YLLoopScrollView *scrollView = [YLLoopScrollView loopScrollViewWithTimer:2 customView:^NSDictionary *{
        return @{@"UIImageView" : @"image"};
    }];
    scrollView.dataSourceArr = arr;
    scrollView.clickedBlock = ^(NSInteger index) {
        // todo
    };
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    [self.view addSubview:scrollView];
```

