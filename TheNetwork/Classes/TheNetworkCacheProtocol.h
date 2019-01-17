//
//  TheNetworkCacheProtocol.h
//  TheNetwork
//
//  Created by TheMe on 2019/1/15.
//  Copyright © 2019 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ RequestCacheCallback)(TheNetworkRequest *handle,NSDictionary *response);

@protocol TheNetworkCacheProtocol <NSObject>

@property (nonatomic,strong) NSMutableDictionary *cachePool;

/**
 *  @author thou, 16-07-06 11:07:22
 *
 *  @brief 写入回调
 *
 *  @return 决定网络层是否还需要执行结果回调。
 *
 *  @since 1.0
 */
- (BOOL)writeCache:(id<TheBeanInterface>)bean response:(id)response;
- (void)clearCache;

- (BOOL)willSendRequest:(TheNetworkRequest *)handle withCallback:(RequestCacheCallback)callback;

@end

NS_ASSUME_NONNULL_END
