//
//  ViewController.m
//  TheNetworkDemo
//
//  Created by TheMe on 2019/1/16.
//  Copyright © 2019 sdqvsqiu@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import <TheNetwork/TheNetwork.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequestTest];
}

- (void)sendRequestTest
{
    TheRequestSimpleBean *bean = [[TheRequestSimpleBean alloc] init];
    bean.fullUrl = @"https://raw.githubusercontent.com/Pgyer/TravisFile/master/pgyer_upload.sh";
    
    TheNetworkRequest *request = [[TheNetworkRequest alloc] init];
    request.forbiddenSendRepeat = YES;
    request.bean = bean;
    
    __weak __typeof__(self) __weak_self__ = self;
    request.success = ^(NSDictionary *responseDict){
//        TheResponseBaseBean *response = [[TheResponseBaseBean alloc] initWithDictionary:responseDict];
        NSLog(@"请求成功会过来---->self:%@,response:%@",__weak_self__,responseDict);
    };
    request.failure = ^(NSError *error) {
        NSLog(@"请求失败会过来---->self:%@,error:%@",__weak_self__,error);
    };
    request.finally = ^{
        NSLog(@"无论成功失败最终都会过来");
    };
    sendRequest(request);
    sendRequest(request);   // 测试重复请求
}

@end
