//
//  TheRequestSimpleBean.h
//  TheNetwork
//
//  Created by TheMe on 2/13/19.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheRequestBaseBean.h"

NS_ASSUME_NONNULL_BEGIN

@interface TheRequestSimpleBean : TheRequestBaseBean

@property (nonatomic, strong) id tag;

@property (nonatomic, copy) NSString *simpleUrl;
@property (nonatomic, copy) NSString *fullUrl;
@property (nonatomic, strong, readonly) NSMutableDictionary *simpleParams;

@end

NS_ASSUME_NONNULL_END
