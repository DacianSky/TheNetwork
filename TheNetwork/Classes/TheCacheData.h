//
//  TheCacheData.h
//  TheNetwork
//
//  Created by TheMe on 7/5/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TheCacheData : NSObject <NSCoding>

@property (nonatomic,copy) NSString *url;

@property (nonatomic,strong) NSDictionary *extraParameter;

@property (nonatomic) id cacheData;

/**
 *  @author thou, 16-07-05 20:07:07
 *
 *  @brief 最近缓存时间
 *
 *  @since 1.0
 */
@property (nonatomic) NSInteger timestamp;


@property (nonatomic) NSInteger cacheDuration;

@end
