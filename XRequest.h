//
//  XRequest.h
//  NetworkRequest
//
//  Created by xheng on 26/12/17.
//  Copyright © 2017年 xheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XRequest, XResponse;
@protocol XRequestDelegate;


typedef NS_ENUM(NSUInteger, XRequestMethod) {
    XRequestMethodGET,
    XRequestMethodPOST,
};

typedef void(^Success)(XRequest *r);
typedef void(^Failure)(NSError *e);

@interface XRequest : NSObject

@property (nonatomic, assign) NSUInteger requestID; //请求ID
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) XRequestMethod method;

@property (nonatomic, weak) id<XRequestDelegate> delegate; //代理回调
@property (nonatomic, strong) XResponse *response;

//创建请求，并且马上执行
+ (instancetype)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail;
+ (instancetype)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail;

+ (instancetype)makeRequestWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail startImediately:(BOOL)startImediately;

- (void)analysisResponse:(id)responseObject;
- (void)failCallBackWithError:(NSError *)error;
//创建请求，但是不执行，需要调用start执行
+ (instancetype)GET:(NSString *)url
         parameters:(NSDictionary *)parameters
            success:(Success)success
               fail:(Failure)fail
    startImediately:(BOOL)startImediately;

+ (instancetype)POST:(NSString *)url
          parameters:(NSDictionary *)parameters
             success:(Success)success
                fail:(Failure)fail
     startImediately:(BOOL)startImediately;

- (void)start;
- (void)stop;

@end

@protocol XRequestDelegate <NSObject>

@optional
- (void)requestDidFinish:(XRequest *)request;
- (void)requestDidError:(NSError *)error;

@end
