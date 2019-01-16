//
//  TheNetworkCache.h
//  TheNetwork
//
//  Created by DacianSky on 7/5/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheNetworkRequest.h"
#import "TheNetworkCacheProtocol.h"

@interface TheNetworkCache : NSObject <TheNetworkCacheProtocol>

#pragma mark -  overpoint
// 自定义缓存类覆盖方法
- (void)buildCachePool;

- (void)writeCachePool:(NSString *)cacheType key:(NSString *)key data:(id)cacheData;
- (id)readCachePool:(NSString *)cacheType key:(NSString *)key;

+ (BOOL)requestBeforeJudgeConnect;

@end
