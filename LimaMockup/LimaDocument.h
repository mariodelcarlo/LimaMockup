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
    MimeTypeUnknown = 0,
    MimeTypeDirectory = 1,
    MimeTypeVideo = 2,
    MimeTypeImage = 3,
    MimeTypeText = 4,
    MimeTypeSound = 5
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
