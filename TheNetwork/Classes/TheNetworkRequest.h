//
//  TheNetworkRequest.h
//  TheNetwork
//
//  Created by TheMe on 6/20/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheBeanInterface.h"
#import "TheResponseBeanProtocol.h"

typedef BOOL (^ RequestAbandon)(id<TheBeanInterface> bean);
typedef id (^ RequestLocalData)(NSDictionary *response);
typedef void (^ RequestProcessing)(NSProgress * progress);
typedef id (^ RequestValidate)(id<TheBeanInterface> bean,id model);
typedef void (^ RequestSuccess)(id model);
typedef void (^ RequestFailure)(NSError *error);
typedef void (^ RequestFinally)(void);
typedef BOOL (^ RequestUnauthorized)(void); // when server return 401,if u return this block "no",handle will not add to next request
typedef NSDictionary *(^ RequestIntent)(void);

@interface TheNetworkRequest : NSObject <NSCopying>

@property (nonatomic,strong) id<TheBeanInterface> bean;

// 响应结果模型类，不配置的话默认所有ResultCode都为ResultCodeSucceed
@property (nonatomic,strong) Class<TheResponseBeanProtocol> responseBeanType;

@property (nonatomic,copy) RequestAbandon abandon; // 当返回NO时请求数据结果将被弃用
@property (nonatomic,copy) RequestAbandon start;
@property (nonatomic) BOOL forceUseLocalData;
@property (nonatomic,copy) RequestLocalData localData;
@property (nonatomic,copy) RequestProcessing processing;
@property (nonatomic,copy) RequestValidate validate;    // 校验请求数据，当返回值为nil时将弃用数据
@property (nonatomic,copy) RequestSuccess success;
@property (nonatomic,copy) RequestSuccess exception;
@property (nonatomic,copy) RequestFailure failure;
@property (nonatomic,copy) RequestFinally finally;
@property (nonatomic,copy) RequestFinally suspend;
@property (nonatomic,copy) RequestUnauthorized unauthorized;
@property (nonatomic,copy) RequestUnauthorized willLogin;
@property (nonatomic,copy) RequestIntent onLogin;

+ (instancetype)requestWithBean:(id<TheBeanInterface>)bean;
- (instancetype)initWithBean:(id<TheBeanInterface>)bean;


@property (nonatomic,copy) NSString *errorMsg;

@end
