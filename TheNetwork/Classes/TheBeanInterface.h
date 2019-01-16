//
//  TheBeanInterface.h
//  TheNetwork
//
//  Created by DacianSky on 6/23/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheNetworkAPI.h"

@protocol TheBeanInterface <NSObject>

/**
 *  @author thou, 16-06-24 08:06:38
 *
 *  @brief 存放对应请求的Api接口。
 *
 *  @since 1.0
 */
@property (nonatomic,copy) TheNetworkAPI *beanApi;

/**
 *  @author thou, 16-06-24 08:06:35
 *
 *  @brief 发送网络请求时实际会被使用的参数。在TheNetworkCenter中被赋值传递给网络层。
 *
 *  @since 1.0
 */
@property (nonatomic,copy) NSMutableDictionary *actualParams;

@optional;
@property (nonatomic,copy) NSData *uploadData;

/**
 *  @author thou, 16-08-26 15:08:44
 *
 *  @brief 服务器接口接受一个解包后的类型(数组，字符串)作为请求参数时将数据放在该接口中
 *
 *  @since 0.7.3
 */
@property(strong,nonatomic) id unpackJsonData;

/**
 *  @author thou, 16-08-26 14:39:44
 *
 *  @brief 参数字典，生成的子类需要将参数在此处转换为字典；建议继承一个字类作为子类使用字典转模型工具转换
 *
 *  @since 1.1
 */
- (NSDictionary *)parameterDict;

@end
