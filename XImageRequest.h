//
//  XImageRequest.h
//  FunnyTicket
//
//  Created by xheng on 27/12/17.
//  Copyright © 2017年 Heyhou. All rights reserved.
//

#import "XRequest.h"

@interface XImageRequest : XRequest

+ (instancetype)dataWithURL:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail;

@end
