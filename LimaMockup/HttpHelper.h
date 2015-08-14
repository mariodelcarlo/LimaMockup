//
//  HttpHelper.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 14/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpHelper : NSObject
+ (void)fetchJSONForURL:(NSURL *)url completion:(void (^)(id data, NSError *error)) completionHandler;
+ (void) handleError:(NSError*)theError;
+ (void)fetchDataForURL:(NSURL *)url completion:(void (^)(id theData, NSError *error)) completionHandler;
@end
