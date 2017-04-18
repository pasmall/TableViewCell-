//
//  ViewController.m
//  TableViewMenu
//
//  Created by lyric on 2017/4/17.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "ViewController.h"
#import "CellExpansionViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic,strong)NSArray *controlNameArray;

@end

@implementation ViewController


#pragma mark 懒加载数据
- (NSArray *)controlNameArray {
    if (!_controlNameArray) {
        
        /*
         CellExpansionViewController : section 展开
         
         
         
         */

        _controlNameArray = @[@"CellExpansionViewController",@"CellInsertViewController",@"ChangeCellHeightViewController"];
    }
    return _controlNameArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"cell展开的实现方式";
    
    NSArray *titileArray = @[@"1:tableView分组展开" ,@"2:插入Cell",@"3:改变cell高度" ];
    self.view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < titileArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.bounds = CGRectMake(0, 0, 300, 30);
        button.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, 150 + i *60);
        [button setTitle:titileArray[i] forState:UIControlStateNormal];
        button.tag =  10+i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

#pragma mark - 事件监听

- (void)buttonPressed:(UIButton *)sender {
    UIViewController *control = [self getViewcontrolWithName:self.controlNameArray[sender.tag-10]];
    [self.navigationController pushViewController:control animated:YES];
}

#pragma mark - other

- (UIViewController *)getViewcontrolWithName:(NSString *)name {
    //类名(对象名)
    NSString *class = name;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    UIViewController *instance = [[newClass alloc] init];
    return instance;
}






@end
