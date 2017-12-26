//
//  XChainRequestManager.h
//  NetworkRequest
//
//  Created by xheng on 26/12/17.
//  Copyright © 2017年 xheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XRequest;
typedef void(^Action)(void);

@interface XChainRequestManager : NSObject

+ (instancetype)shareManager;

- (void)addRequest:(XRequest *)request;
- (void)setNotifyAction:(Action)action;

- (void)start;
- (void)reStart;
- (void)stop;

@end
