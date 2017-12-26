//
//  XResponse.h
//  NetworkRequest
//
//  Created by xheng on 26/12/17.
//  Copyright © 2017年 xheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XResponse : NSObject

@property (nonatomic, assign) NSUInteger responseID; //和requestID相同
@property (nonatomic, strong) id responseObject;
@property (nonatomic, assign) NSUInteger ret;

@end
