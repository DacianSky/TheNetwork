//
//  TheBasicRequestHandle.h
//  TheNetwork
//
//  Created by TheMe on 2019/1/16.
//  Copyright © 2019 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheRequestHandleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 基础的get,post,upload RESTful风格请求.默认request,response为json格式。
 */
@interface TheBasicRequestHandle : NSObject <TheRequestHandleProtocol>

@end

NS_ASSUME_NONNULL_END
