//
//  TheResponseBeanProtocol.h
//  TheNetwork
//
//  Created by TheMe on 2019/1/15.
//  Copyright © 2019 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ResultCode){
    ResultCodeSucceed = 0,
    ResultCodeUndefinedError,
    ResultCodeParamsError = 5000,
    ResultCodeFreqOutOfLimit,
    ResultCodeUnauthorized,
    ResultCodeExternalServiceUnavailable,
    ResultCodeServerUndefined,
    ResultCodeVersionDisable
};


@protocol TheResponseBeanProtocol <NSObject>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;


@optional
- (ResultCode)resultCode;

@end

NS_ASSUME_NONNULL_END
