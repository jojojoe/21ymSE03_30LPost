//
//  PictureProcessTool.h
//  LpymLpost
//
//  Created by JOJO on 2021/10/29.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PictureProcessTool : NSObject

+ (UIImage *)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*)f;
@end

NS_ASSUME_NONNULL_END
