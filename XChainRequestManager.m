//
//  XChainRequestManager.m
//  NetworkRequest
//
//  Created by xheng on 26/12/17.
//  Copyright © 2017年 xheng. All rights reserved.
//

#import "XChainRequestManager.h"
#import "XRequest.h"

@interface XChainRequestManager() <XRequestDelegate>

@property (nonatomic, strong) NSMutableArray<XRequest *> *requests;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) Action notifyAction;

@end

@implementation XChainRequestManager

+ (instancetype)shareManager {
    static XChainRequestManager *chain;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chain = [[XChainRequestManager alloc] init];
        chain.index = 0;
    });
    return chain;
}

- (void)addRequest:(XRequest *)request {
    [self.requests addObject:request];
}

- (void)start {
    if (self.requests.count == 0) {
        return ;
    }
    
    [self doNextRq];
}

- (void)reStart {
    self.index = 0;
    [self doNextRq];
}

- (void)stop {
    self.index = -1; //结束
}

- (void)setNotifyAction:(Action)action {
    _notifyAction = action;
}

- (BOOL)doNextRq {
    if (self.index < self.requests.count) {
        XRequest *request = self.requests[self.index];
        request.delegate = self;
        [request start];
        self.index += 1;
        return YES;
    } else {
        return NO;
    }
}

- (NSMutableArray<XRequest *> *)requests {
    if (!_requests) {
        _requests = [[NSMutableArray alloc] init];
    }
    return _requests;
}

- (void)requestDidFinish:(XRequest *)request {
    if (![self doNextRq]) {
        if (self.notifyAction) {
            self.notifyAction();
        }
    }
}

@end
