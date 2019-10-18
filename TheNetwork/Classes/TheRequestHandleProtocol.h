//
//  TheRequestHandleProtocol.h
//  TheNetwork
//
//  Created by TheMe on 6/20/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheNetworkRequest.h"
#import "TheNetworkCacheProtocol.h"

typedef NS_ENUM(NSInteger,NetworkSecretType){
    NetworkSecretTypeNone,
    NetworkSecretTypeHash
};

typedef void(^ResponseProgress)(NSProgress *progress);
typedef void(^ResponseSuccess)(id responseObjec);
typedef void(^ResponseError)(NSError *error);

@protocol TheRequestHandleProtocol <NSObject>

- (void)sendRequest:(TheNetworkRequest *)request url:(NSString *)url parameters:(id)parameters progress:(ResponseProgress)progress success:(ResponseSuccess)success failure:(ResponseError)failure;

@optional
- (void)willSendRequest;
- (void)didSendRequest;

//需要加密的协议相对应的key
@property (nonatomic) id networkSecretKey;
@property (nonatomic) NetworkSecretType networkSecretType;

@end
