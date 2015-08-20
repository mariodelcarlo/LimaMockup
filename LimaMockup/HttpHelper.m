//
//  HttpHelper.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "HttpHelper.h"

@implementation HttpHelper

//Get the URL session
+ (NSURLSession *)dataSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return session;
}

//Send a http request that will return JSON datas and perform a completion block if provided
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

//Send a http request that will return NSData and perform a completion block if provided
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

//Handles Error in Http process
+ (void) handleError:(NSError*)theError{
    NSLog(@"Error in HttpHelper=%@",theError);
    
    //Show an alert
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error")
                                                       message:NSLocalizedString(@"httpErrorMessage", @"httpErrorMessage")
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
}

@end
