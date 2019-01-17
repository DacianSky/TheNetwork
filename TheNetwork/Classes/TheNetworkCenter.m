//
//  TheNetworkCenter.m
//  TheNetwork
//
//  Created by DacianSky on 6/20/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheNetworkCenter.h"
#import "NSString+TheNetwork.h"
#import "TheNetworkCache.h"
#import "TheBasicRequestHandle.h"

inline void sendRequest(TheNetworkRequest *request)
{
    [kNet sendRequest:request];
}

NSInteger const kRequestInterval = 10;

@interface TheNetworkCenter()

@end

@implementation TheNetworkCenter

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [[self class] sharedNetworkCenter] ;
}

+ (instancetype)sharedNetworkCenter{
    return [[[self class] alloc] init];
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static TheNetworkCenter *center;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [super allocWithZone:zone];
        center.networkCachePool = [[TheNetworkCache alloc] init];
        center.network = [[TheBasicRequestHandle alloc] init];
    });
    return center;
}

- (void)sendRequest:(TheNetworkRequest *)model
{
    if ([self.network respondsToSelector:@selector(willSendRequest)]) {
        [self.network willSendRequest];
    }
    
    TheNetworkRequest *handle = [self convertHandle:model];
    if (![self prepareHandle:handle]) {
        return;
    }
    NSString *url = handle.bean.actualParams[@"apiUrl"];
    id parameter = [self convertParameter:handle];
    
    __weak __typeof__(self) __weak_self__ = self;
    [self.network sendRequest:model.bean.beanApi.requestType url:url parameters:parameter responseType:model.bean.beanApi.responseType progress:^(NSProgress *progress) {
        !handle.processing?:handle.processing(progress);
    } success:^(id responseObject) {
        [__weak_self__ success:responseObject handle:handle];
    } failure:^(NSError *error) {
        [__weak_self__ failure:error handle:handle];
    }];
}

- (BOOL)prepareHandle:(TheNetworkRequest *)handle
{
    !handle.start?:handle.start();
    
    BOOL flag = YES;
    if ([self localHandle:handle]) {
        flag =  NO;
    }
    if ([self cacheHandle:handle]) {
        flag = NO;
    }
    
    return flag;
}

- (BOOL)localHandle:(TheNetworkRequest *)handle
{
    BOOL isLocal = NO;
    if (handle.forceUseLocalData) {
        NSMutableDictionary *response = [themeAppJson(@"request")[@"Succeed"] mutableCopy];
        id data = handle.localData();
        if (response) {
            response[@"Body"] = data;
            [self success:response handle:handle];
        }else{
            [self success:data handle:handle];
        }
        isLocal = YES;
    }
    return isLocal;
}

- (BOOL)cacheHandle:(TheNetworkRequest *)handle
{
    __weak __typeof__(self) __weak_self__ = self;
    BOOL needSendRequestflag = [self.networkCachePool willSendRequest:handle withCallback:^(TheNetworkRequest *handle, NSDictionary *response) {
        [__weak_self__ success:response handle:handle];
    }];
    needSendRequestflag = !self.networkCachePool?YES:needSendRequestflag;
    return !needSendRequestflag;
}

#pragma mark - request response

- (void)failure:(NSError *)error handle:(TheNetworkRequest *)handle
{
    if ([self.network respondsToSelector:@selector(didSendRequest)]) {
        [self.network didSendRequest];
    }
    
    if (handle.cancel()) {
        !handle.finally?:handle.finally();
        return;
    }
    /*
    if (DEBUG) {
        NSString *log = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",log);
    }
     */
    !handle.failure?:handle.failure(error);
    !handle.finally?:handle.finally();
}

- (void)success:(id)responseObject handle:(TheNetworkRequest *)handle
{
    if ([self.network respondsToSelector:@selector(didSendRequest)]) {
        [self.network didSendRequest];
    }
    
    if (handle.cancel()) {
        !handle.finally?:handle.finally();
        return;
    }
    
    if (handle.bean.beanApi.responseType == NetWorkResponseTypeNSDictionary) {
        responseObject = [self validResponseData:responseObject];
    }
    
    [self.networkCachePool writeCache:handle.bean response:responseObject];
    [self dealHandle:handle withResponse:responseObject];
}

- (void)dealHandle:(TheNetworkRequest *)handle withResponse:(id)response
{
    if(response){
        if (![response isKindOfClass:[NSDictionary class]]) {
            !handle.success?:handle.success(response);
        }else{
            // 响应结果模型类，不配置的话默认所有ResultCode都为ResultCodeSucceed
            id<TheResponseBeanProtocol> responseBean = [[(Class)handle.responseBeanType alloc] initWithDictionary:response];
            if (responseBean.resultCode == ResultCodeSucceed) {
                !handle.success?:handle.success(response);
            }else if(responseBean.resultCode == ResultCodeVersionDisable){;
                NSLog(@"------------->警告:%@",responseBean.msg);
            }else{
                !handle.exception?:handle.exception(response);
            }
        }
    }else{
        NSError *error = [NSError errorWithDomain:handle.bean.actualParams[@"apiUrl"] code:404 userInfo:nil];
        !handle.failure?:handle.failure(error);
    }
    !handle.finally?:handle.finally();
}

#pragma mark - util
- (NSDictionary *)convertParameter:(TheNetworkRequest *)handle
{
    NSMutableDictionary *parameter = [handle.bean.actualParams mutableCopy];
    [parameter removeObjectForKey:@"apiUrl"];
    return parameter;
}

- (NSDictionary *)validResponseData:(id)responseObject
{
    NSDictionary *response = responseObject;
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSError *err;
        response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        if(err) {
            return nil;
        }
    }
    return response;
}

- (TheNetworkRequest *)convertHandle:(TheNetworkRequest *)model
{
    id<TheBeanInterface> bean = model.bean;
    
    // 获得模板Api url
    NSString *url = bean.beanApi.apiUrl;
    
    NSAssert(bean != nil && url != nil, @"网络请求bean或url为空，发送请求失败。");
    
    // 将模板url中占位符替换为实际参数
    NSMutableDictionary *actualParams = [[bean parameterDict] mutableCopy];
    if (actualParams == nil) {
        actualParams = [@{} mutableCopy];
    }
    url = [url parseURLPlacehold:actualParams];
    
    actualParams[@"apiUrl"] = url;
    
    TheNetworkRequest *handle = [model copy];
    handle.bean.actualParams = actualParams;    //为了省一个属性，强制将字典当做该类型传递。
    
    return handle;
}

- (void)clearCache
{
    [self.networkCachePool clearCache];
}

@end
