//
//  FilterDataTool.h
//  LpymLpost
//
//  Created by JOJO on 2021/10/29.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FilterDataTool : NSObject
+(NSMutableArray *)colorMatrixList;
+(NSMutableArray *)pictureProcessData:(UIImage *)image;
+(UIImage *)pictureProcessData:(UIImage *)image matrixName: (NSString *)name ;
@end

NS_ASSUME_NONNULL_END
