//
//  XFViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFViewController.h"

@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self initialize];
    [self setupViews];
    [self setupNavigationBar];
    [self addSubviews];
    [self makeConstraints];
    [self registerViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Custom

- (void)requestData {}
- (void)initialize {}
- (void)setupViews {}
- (void)setupNavigationBar {}
- (void)addSubviews {}
- (void)makeConstraints {}
- (void)registerViews {}

- (void)showError:(NSError *)error {
    if (error.code == -1009) {
        [XFProgressHUD showMessage:@"无网络连接!"];
    }
    else if (error.code == -1001) {
        [XFProgressHUD showMessage:@"请求超时!"];
    }
    else if (error.code == -1004) {
        [XFProgressHUD showMessage:@"无法连接到服务器!"];
    } else if (error.code == -1011) {
        [XFProgressHUD showMessage:@"服务器打了个盹~>.<"];
    }
    else if (error.code == -1003) {
        [XFProgressHUD showMessage:@"服务器打了个盹~>.<"];
    }
    else {
        [XFProgressHUD showMessage:[NSString stringWithFormat:@"%@", error.domain]];
    }
}
@end
