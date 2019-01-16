//
//  TheNetworkCenter.h
//  TheNetwork
//
//  Created by DacianSky on 6/20/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheNetworkRequest.h"
#import "TheNetworkCacheProtocol.h"
#import "TheRequestHandleProtocol.h"

#define kNet [TheNetworkCenter sharedNetworkCenter]
void sendRequest(TheNetworkRequest *request);

@interface TheNetworkCenter : NSObject

+ (instancetype)sharedNetworkCenter;

- (void)sendRequest:(TheNetworkRequest *)model;

// 具体网络发送请求类，具体方法在此处实现
@property (nonatomic,strong) id<TheRequestHandleProtocol> network;

// 设置缓存类，缓存类为nil时缓存配置项将无法生效
@property (nonatomic,strong) id<TheNetworkCacheProtocol> networkCachePool;
- (void)clearCache;

@end
