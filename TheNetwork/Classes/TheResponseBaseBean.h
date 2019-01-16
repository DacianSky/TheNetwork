//
//  TheResponseBaseBean.h
//  TheNetwork
//
//  Created by DacianSky on 6/20/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheResponseBeanProtocol.h"

@interface TheResponseBaseBean : NSObject <TheResponseBeanProtocol>

@property (nonatomic, strong) id body;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic) ResultCode resultCode;
@property (nonatomic, assign) BOOL succeed;

@end
