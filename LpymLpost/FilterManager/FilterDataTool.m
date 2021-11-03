//
//  FilterDataTool.m
//  LpymLpost
//
//  Created by JOJO on 2021/10/29.
//

#import "FilterDataTool.h"
#import "PictureProcessTool.h"
#import "FilterColorMatrix.h"

@implementation FilterDataTool


+(NSArray *)colorMatrixList {

    return @[@"原图", @"LOMO", @"黑白", @"复古", @"哥特", @"锐化", @"淡雅", @"酒红", @"清宁", @"浪漫", @"光晕", @"蓝调", @"梦幻", @"夜色"];
}


+(UIImage *)pictureProcessData:(UIImage *)image matrixName: (NSString *)name {
    UIImage *fixedImg = image;
     
    if ([name isEqual: @"原图"]) {
        return  fixedImg;
    } else if ([name isEqual: @"LOMO"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_lomo];
    } else if ([name isEqual: @"黑白"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_heibai];
    } else if ([name isEqual: @"复古"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_huajiu];
    } else if ([name isEqual: @"哥特"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_gete];
    } else if ([name isEqual: @"锐化"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_ruise];
    } else if ([name isEqual: @"淡雅"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_danya];
    } else if ([name isEqual: @"酒红"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_jiuhong];
    } else if ([name isEqual: @"清宁"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_qingning];
    } else if ([name isEqual: @"浪漫"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_langman];
    } else if ([name isEqual: @"光晕"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_guangyun];
    } else if ([name isEqual: @"蓝调"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_landiao];
    } else if ([name isEqual: @"梦幻"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_menghuan];
    } else if ([name isEqual: @"夜色"]) {
        fixedImg = [PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_yese];
    }
    
    
    return fixedImg;
}

+(NSMutableArray *)pictureProcessData:(UIImage *)image{
    NSMutableArray *datasourse = [NSMutableArray array];
    NSDictionary *dic = @{@"image":image,@"name":@"原图"};
    [datasourse addObject:dic];
    NSDictionary *diclomo = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_lomo],
                              @"name":@"LOMO"};
    [datasourse addObject:diclomo];
    NSDictionary *dicheibai = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_heibai],
                                @"name":@"黑白"};
    [datasourse addObject:dicheibai];
    NSDictionary *dicRetro = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_huajiu],
                               @"name":@"复古"};
    [datasourse addObject:dicRetro];
    NSDictionary *dicgete = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_gete],
                              @"name":@"哥特"};
    [datasourse addObject:dicgete];
    NSDictionary *dicrui = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_ruise],
                             @"name":@"锐化"};
    [datasourse addObject:dicrui];
    NSDictionary *dicdany = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_danya],
                              @"name":@"淡雅"};
    [datasourse addObject:dicdany];
    NSDictionary *dicjiuhong = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_jiuhong],
                                 @"name":@"酒红"};
    [datasourse addObject:dicjiuhong];
    NSDictionary *qingning = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_qingning],
                               @"name":@"清宁"};
    [datasourse addObject:qingning];
    NSDictionary *langman = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_langman],
                              @"name":@"浪漫"};
    [datasourse addObject:langman];
    NSDictionary *guangyun = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_guangyun],
                               @"name":@"光晕"};
    [datasourse addObject:guangyun];
    NSDictionary *landiao = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_landiao],
                              @"name":@"蓝调"};
    [datasourse addObject:landiao];
    NSDictionary *menghuan = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_menghuan],
                               @"name":@"梦幻"};
    [datasourse addObject:menghuan];
    NSDictionary *yese = @{@"image":[PictureProcessTool imageWithImage:image withColorMatrix:colormatrix_yese],
                           @"name":@"夜色"};
    [datasourse addObject:yese];
    return datasourse;
}




@end
