//
//  ViewController.m
//  keyboardProject
//
//  Created by misterLiu on 2019/3/14.
//  Copyright © 2019 mister. All rights reserved.
//

#import "ViewController.h"
#import "JFinputPwdView.h"  //加密密码输入框
#import "Base64KeyBoardView.h"
#import "Masonry.h"

@interface ViewController ()

@property(nonatomic,strong)JFinputPwdView *  passwordPhone;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
//    NSLog(@"--1---");
    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"--2---");
//    });
    
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"--2---");
//    });
//    NSLog(@"--3---");
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"async:1");
//    });
//    NSLog(@"async:2");
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"async:3");
//    });
//    NSLog(@"async:4");
    
// DISPATCH_QUEUE_PRIORITY_HIGH 2
// DISPATCH_QUEUE_PRIORITY_DEFAULT 0
// DISPATCH_QUEUE_PRIORITY_LOW (-2)
// DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN

//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"----sync:1");
//    });
//    NSLog(@"----sync:2");
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"----sync:3");
//    });
//    NSLog(@"----sync:4");

   
    
    
    [self.view addSubview:self.passwordPhone];
    [self.passwordPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
//        make.centerY.equalTo(self.view.mas_centerY);
        make.top.mas_equalTo(self.view.mas_top).with.offset(100);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor cyanColor];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60,60));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.passwordPhone.mas_bottom).with.offset(30);
    }];
}

-(void)btnClick:(UIButton *)sender{
    
    NSString * decodeStr = [Base64KeyBoardView tranceBaseToString:self.passwordPhone.encryStr];
    NSLog(@"-加密后的数据---%@--/n---解密后的数据----%@----",self.passwordPhone.encryStr,decodeStr);
    
    
}



-(JFinputPwdView*)passwordPhone{
    if (!_passwordPhone) {
        _passwordPhone = [[JFinputPwdView alloc]init];
        _passwordPhone.mInput.placeholder = @"请输入登录密码";
        //        [_passwordPhone drawRadius];
    }
    return _passwordPhone;
}


@end
