//
//  ViewController.m
//  helloworld-objective-c
//
//  Created by CHENHSIN-PANG on 2015/3/23.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//

#import "ViewController.h"
#import "HWTableViewController.h"


@interface ViewController ()

@property(nonatomic, weak)UIButton  *startBtn;   // 基本上只要是View，都是設weak，因為在addsubView的時候，這個view就會與parent view 有strong的連結

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    // 用programmetically 的方式產生view，這是標準的patter
    // 1. create a view
    // 2. 利用addSubView，把這個view加到其他View中
    // 3. 將reference設給weak property
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 150, 40)];
    [button setTitle:@"Get Dam Status" forState:UIControlStateNormal];
    [self.view addSubview:button];
    self.startBtn = button;
        
    // Target-Action : 類似event的東西，在這裡就是處理點擊按鈕的部分
    
    [self.startBtn addTarget:self action:@selector(helloAction:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)helloAction:(UIButton*)sender
{
    NSLog(@"Hello");
    
    HWTableViewController *vc = [[HWTableViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];

}






@end
