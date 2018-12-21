//
//  ImageMorphologicalTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/20.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "ImageMorphologicalTestCase.h"

@interface ImageMorphologicalTestCase ()

@end

@implementation ImageMorphologicalTestCase

- (NSString*)title{
    return @"图像形态学";
}

- (NSArray*)controlItems{
    return @[
             [SlideConfigItem slideConfigWithTitle:@"loop"
                                               key:@"loop"
                                             range:NSMakeRange(1, 10)
                                        isContinue:NO defaultValue:1]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
   
    int loop = (int)getFloatValue(@"loop", configs);
   
    Mat src;
    Test1Mat(src);
    cvtColor(src, src, CV_RGBA2RGB);
    
    Mat openMat;
    openMat = HalfMat(src);
    cv::morphologyEx(openMat,openMat, cv::MORPH_OPEN, cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5,5)),cv::Point(-1,-1),loop);
//    cvtColor(openMat, openMat, CV_RGB2RGBA);
    check(HalfMatBack(src, openMat),@"形态函数:开");
    
    Mat closeMat;
    closeMat = HalfMat(src);
    cv::morphologyEx(closeMat,closeMat, cv::MORPH_CLOSE,
                     cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5,5))
                     ,cv::Point(-1,-1),loop);
//    cvtColor(closeMat, closeMat, CV_RGB2RGBA);
    check(HalfMatBack(src, closeMat),@"形态函数:关");
    
    Mat testMat;
    testMat = HalfMat(src);
    cv::morphologyEx(testMat,testMat, cv::MORPH_GRADIENT,
                     cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5,5))
                     ,cv::Point(-1,-1),loop);
    //    cvtColor(closeMat, closeMat, CV_RGB2RGBA);
    check(HalfMatBack(src, testMat),@"形态梯度");
    

    testMat = HalfMat(src);
    cv::morphologyEx(testMat,testMat, cv::MORPH_TOPHAT,
                     cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5,5))
                     ,cv::Point(-1,-1),loop);
    //    cvtColor(closeMat, closeMat, CV_RGB2RGBA);
    check(HalfMatBack(src, testMat),@"形态函数：顶帽");
    
 
    testMat = HalfMat(src);
    cv::morphologyEx(testMat,testMat, cv::MORPH_BLACKHAT,
                     cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5,5))
                     ,cv::Point(-1,-1),loop);
    //    cvtColor(closeMat, closeMat, CV_RGB2RGBA);
    check(HalfMatBack(src, testMat),@"形态函数：黑帽");
    
    CV_TEST_CODE_END
}
@end
