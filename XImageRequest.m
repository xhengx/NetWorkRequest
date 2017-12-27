//
//  XImageRequest.m
//  NetworkRequest
//
//  Created by xheng on 27/12/17.
//  Copyright © 2017年 xheng. All rights reserved.
//

#import "XImageRequest.h"

@implementation XImageRequest

+ (instancetype)dataWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail {
    return [super makeRequestWithURL:url parameters:parameters success:success fail:fail startImediately:NO];
}

- (void)start {
    [self doGetImage];
}

- (void)doGetImage {
    [[self sessionManager] GET:self.url parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIImage *image = [UIImage imageWithData:responseObject];
        [super analysisResponse:image];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [super failCallBackWithError:error];
    }];
}

- (AFHTTPSessionManager *)sessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"image/*;q=0.8" forHTTPHeaderField:@"Accept"];
    return manager;
}

@end
