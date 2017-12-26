# NetWorkRequest
单个请求
``` objective-c
[XRequest GET:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.4.255.255" parameters:nil success:^(XRequest *r) {
        NSLog(@"req:%ld,%@", r.requestID, r.response.responseObject);
    } fail:^(NSError *error) {
        NSLog(@"req error:%@", error);
}];
``` 
链式请求
``` objective-c
XChainRequestManager *chain = [XChainRequestManager shareManager];
for (NSUInteger i = 0; i < 10; ++i) {
  XRequest *req = [XRequest GET:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.4.255.255" parameters:nil success:^(XRequest *r) {
    NSLog(@"req:%ld", r.requestID);
  } fail:^(NSError *error) {
    NSLog(@"req error:%ld", i);
  } startImediately:NO];
  [chain addRequest:req];
}
  [chain setNotifyAction:^{
    NSLog(@"finish all");
  }];
  [chain start];
```
