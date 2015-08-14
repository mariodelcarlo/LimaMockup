//
//  LimaDocument.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 13/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LimaDocument : NSObject

typedef NS_ENUM(NSUInteger, MimeType) {
    MimeTypeDirectory = 0,
    MimeTypeVideo = 1,
    MimeTypeImage = 2,
    MimeTypeText = 3,
    MimeTypeUnknown = NSUIntegerMax
};

@property(nonatomic, copy) NSString * fileName;
@property(nonatomic, copy) NSString * filePath;
@property (nonatomic) MimeType mimeType;

- (id)initWithFileName:(NSString*)theFileName;
+ (MimeType)mimeTypeForMimeString:(NSString*)theMimeString;
- (UIImage*)iconImage;

@end
