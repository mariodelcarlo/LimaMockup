//
//  LimaDocument.m
//  LimaMockup
//
//  Created by Marie-Odile Del Carlo on 13/08/2015.
//  Copyright (c) 2015 Marie-Odile Del Carlo. All rights reserved.
//

#import "LimaDocument.h"

@implementation LimaDocument

- (id)initWithFileName:(NSString*)theFileName{
    self = [super init];
    if (self) {
        self.fileName = theFileName;
    }
    return self;
}

- (UIImage*)iconImage{
    switch (self.mimeType) {
        case MimeTypeText:
            return [UIImage imageNamed:@"MimeText.png"];
            break;
            
        case MimeTypeVideo:
            return [UIImage imageNamed:@"MimeVideo.png"];
            break;
            
        case MimeTypeImage:
            return [UIImage imageNamed:@"MimeImage.png"];
            break;
        
        case MimeTypeDirectory:
            return [UIImage imageNamed:@"MimeDirectory.png"];
            break;
        
        case MimeTypeSound:
            return [UIImage imageNamed:@"MimeSound.png"];
            break;
            
        default:
            return [UIImage imageNamed:@"MimeDirectory.png"];
            break;
    }
}



+ (MimeType)mimeTypeForMimeString:(NSString*)theMimeString{
    if([theMimeString hasPrefix:@"inode/directory"]){
        return MimeTypeDirectory;
    }
    else if([theMimeString hasPrefix:@"image"]){
        return MimeTypeImage;
    }
    else if([theMimeString hasPrefix:@"video"]){
        return MimeTypeVideo;
    }
    else if([theMimeString hasPrefix:@"text"]){
        return MimeTypeText;
    }
    return MimeTypeUnknown;
}



@end
