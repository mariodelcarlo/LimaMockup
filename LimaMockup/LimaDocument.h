//
//  LimaDocument.h
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 13/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//A Document
@interface LimaDocument : NSObject

//Enum for the mime type of a file
typedef NS_ENUM(NSUInteger, MimeType) {
    MimeTypeDirectory = 0,
    MimeTypeVideo = 1,
    MimeTypeImage = 2,
    MimeTypeText = 3,
    MimeTypeSound = 4,
    MimeTypeUnknown = NSUIntegerMax
};

//The file name
@property(nonatomic, copy) NSString * fileName;

//The file path
@property(nonatomic, copy) NSString * filePath;

//The mime type
@property (nonatomic) MimeType mimeType;


- (id)initWithFileName:(NSString*)theFileName;
+ (MimeType)mimeTypeForMimeString:(NSString*)theMimeString;
- (UIImage*)iconImage;

@end
