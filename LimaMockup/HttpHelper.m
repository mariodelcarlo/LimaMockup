//
//  HttpHelper.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper

+ (NSURLSession *)dataSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return session;
}

+ (void)fetchJSONForURL:(NSURL *)url completion:(void (^)(id data, NSError *error)) completionHandler {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *dataTask = [[self dataSession] dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
         if (completionHandler == nil){
             return;
         }
         
         if (error) {
             completionHandler(nil, error);
             return;
         }
        
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse*)response;
        if (urlResponse.statusCode != 200) {
            NSError *statusError = [NSError errorWithDomain:@"Status Error" code:144 userInfo:nil];
            completionHandler(nil, statusError);
        }
        
        
        NSError *jsonError = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if(!jsonError){
            completionHandler(result, nil);
        }
        else{
            completionHandler(nil, jsonError);
        }
     }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [dataTask resume];
}

+ (void)fetchDataForURL:(NSURL *)url completion:(void (^)(id theData, NSError *error)) completionHandler {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *dataTask = [[self dataSession] dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (completionHandler == nil){
            return;
        }
        
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse*)response;
        if (urlResponse.statusCode != 200) {
            NSError *statusError = [NSError errorWithDomain:@"Status Error" code:144 userInfo:nil];
            completionHandler(nil, statusError);
        }
        completionHandler(data,nil);
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [dataTask resume];
}

+ (void) handleError:(NSError*)theError{
    NSLog(@"WB error:%@",theError);
}

@end
