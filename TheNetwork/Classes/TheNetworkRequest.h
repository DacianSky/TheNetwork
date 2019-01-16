//
//  TheNetworkRequest.h
//  TheNetwork
//
//  Created by DacianSky on 6/20/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheBeanInterface.h"
#import "TheResponseBeanProtocol.h"

typedef BOOL (^ RequestCancel)(void);
typedef void (^ RequestStart)(void);
typedef id (^ RequestLocalData)(void);
typedef void (^ RequestProcessing)(NSProgress * progress);
typedef void (^ RequestSuccess)(id model);
typedef void (^ RequestFailure)(NSError *error);
typedef void (^ RequestFinally)(void);
typedef BOOL (^ RequestUnauthorized)(void); // when server return 401,if u return this block "no",handle will not add to next request
typedef NSDictionary *(^ RequestIntent)(void);

@interface TheNetworkRequest : NSObject <NSCopying>

@property (nonatomic,strong) id<TheBeanInterface> bean;

// 响应结果模型类，不配置的话默认所有ResultCode都为ResultCodeSucceed
@property (nonatomic,strong) Class<TheResponseBeanProtocol> responseBeanType;

@property (nonatomic,copy) RequestCancel cancel;
@property (nonatomic,copy) RequestStart start;
@property (nonatomic) BOOL forceUseLocalData;
@property (nonatomic,copy) RequestLocalData localData;
@property (nonatomic,copy) RequestProcessing processing;
@property (nonatomic,copy) RequestSuccess success;
@property (nonatomic,copy) RequestSuccess exception;
@property (nonatomic,copy) RequestFailure failure;
@property (nonatomic,copy) RequestFinally finally;
@property (nonatomic,copy) RequestUnauthorized unauthorized;
@property (nonatomic,copy) RequestUnauthorized willLogin;
@property (nonatomic,copy) RequestIntent onLogin;

+ (instancetype)requestWithBean:(id<TheBeanInterface>)bean;
- (instancetype)initWithBean:(id<TheBeanInterface>)bean;


@property (nonatomic,copy) NSString *errorMsg;

@end
