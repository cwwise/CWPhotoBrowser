//
//  ViewController.m
//  CWPhotoBrowser
//
//  Created by chenwei on 2017/6/20.
//  Copyright © 2017年 cwwise. All rights reserved.
//

#import "ViewController.h"
#import "CWPhotoBrowser-Bridging-Header.h"
#import "CWPhotoBrowser-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PhotoBrowser *controller = [[PhotoBrowser alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
