//
//  TheRequestBaseBean.h
//  TheNetwork
//
//  Created by DacianSky on 6/23/16.
//  Copyright © 2016 sdqvsqiu@gmail.com. All rights reserved.
//

#import "TheBeanInterface.h"

typedef NSString BeanParameter;
extern NSString *const BeanParameterTrue;
extern NSString *const BeanParameterFalse;
extern NSString *const BeanTypeUnpackJsonData;

@interface TheRequestBaseBean : NSObject <TheBeanInterface>

@property(strong,nonatomic) id unpackJsonData;

@end
