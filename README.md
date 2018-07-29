# YLLoopScrollView
无限轮播, 可以是图片, 可以是任意的自定义view
=======
使用教程:
-------
####1.导入头文件
#import "YLLoopScrollView.h"

####2.调用类方法构造实例对象
```Objective-c
// 传入轮播的时间,自定义轮播的view,和需要重新赋值的model
YLLoopScrollView *scrollView = [YLLoopScrollView loopScrollViewWithTimer:2 customView:^NSDictionary *{
        return @{@"YLCustomView" : @"model"};
    }];

```
####3.设置回调block
``` objective c
scrollView.clickedBlock = ^(NSInteger index) {
        NSLog(@"index : %d", index);
    };
    
```
####4.设置数据源
``` objective c
// arr里存放的是自定义view的model
scrollView.dataSourceArr = arr;
```
####5.设置frame
``` objective c
scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
```
####6.添加到父视图
``` objective c
[self.view addSubview:scrollView];
```

so easy ~~~
----------
