//
//  XRequest.m
//  NetworkRequest
//
//  Created by xheng on 26/12/17.
//  Copyright © 2017年 xheng. All rights reserved.
//

#import "XRequest.h"
#import "AFNetworking.h"
#import "XResponse.h"
@interface XRequest ()
{
    NSURLSessionDataTask *_task;
}

//请求结果处理
@property (nonatomic, strong) Success success;
@property (nonatomic, strong) Failure failure;

@property (nonatomic, assign, getter=isStart) BOOL start;

@end

@implementation XRequest

#pragma mark - 构建请求
+ (instancetype)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail {
    return [self GET:url parameters:parameters success:success fail:fail startImediately:YES];
}

+ (instancetype)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail {
    return [self POST:url parameters:parameters success:success fail:fail startImediately:YES];
}

+ (instancetype)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail startImediately:(BOOL)startImediately {
    XRequest *request = [self makeRequestWithURL:url parameters:parameters success:success fail:fail startImediately:startImediately];
    request.method = XRequestMethodGET;
    return request;
}

+ (instancetype)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail startImediately:(BOOL)startImediately {
    XRequest *request = [self makeRequestWithURL:url parameters:parameters success:success fail:fail startImediately:startImediately];
    request.method = XRequestMethodPOST;
    return request;
}

+ (instancetype)makeRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail startImediately:(BOOL)startImediately {
    static NSUInteger requestID = 0;
    XRequest *request = [[XRequest alloc] init];
    request.url = url;
    request.parameters = parameters;
    request.success = success;
    request.failure = fail;
    request.requestID = requestID++;
    if (startImediately) {
        [request start];
    }
    return request;
}
#pragma mark - 开始请求
- (void)start {
    if (self.isStart) {
        NSLog(@"request already start");
        return ;
    }
    self.start = YES;
    switch (self.method) {
        case XRequestMethodGET:
            [self doGet];
            break;
        case XRequestMethodPOST:
            [self doPost];
            break;
    }
}

- (void)stop {
    [_task cancel];
}

#pragma mark - 发送请求
- (void)doGet {
    _task = [[self sessionManager] GET:self.url parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failCallBackWithError:error];
    }];
}

- (void)doPost {
    _task = [[self sessionManager] POST:self.url parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisResponse:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failCallBackWithError:error];
    }];
}
#pragma mark - 数据解析
- (void)analysisResponse:(id)responseObject {
    XResponse *res = [[XResponse alloc] init];
    res.responseID = self.requestID;
    res.ret = 0;
    res.responseObject = responseObject;
    self.response = res;
    if (_success) {
        _success(self);
    }
    [self successCallback];
}

#pragma mark - delegate callback
- (void)successCallback {
    self.start = NO; //结束请求
    
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delegate requestDidFinish:self];
    }
}

- (void)failCallBackWithError:(NSError *)error {
    self.start = NO; //结束请求
    if (_failure) {
        _failure(error);
    }
    
    if ([self.delegate respondsToSelector:@selector(requestDidError:)]) {
        [self.delegate requestDidError:error];
    }
}

#pragma mark - session configuretion
- (AFHTTPSessionManager *)sessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //custome header setting
    return manager;
}

@end
