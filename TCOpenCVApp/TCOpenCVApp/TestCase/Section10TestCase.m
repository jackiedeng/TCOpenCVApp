//
//  Section10TestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/20.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "Section10TestCase.h"

@implementation Section10TestCase

- (NSString*)title{
    return @"第10章节练习(滤波）";
}

- (NSArray*)controlItems{
    return @[];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
    
//    Mat origin = Mat::ones(10, 10, CV_32FC1);
//
//    uiCheck([CVUtil matNumberImage:origin],@"原始");
//
    Mat src;
    Test1Mat(src);
    check(src,@"原始");

//  二值化
    Mat thresholdMat;
    cv::cvtColor(src, thresholdMat, CV_BGRA2GRAY);

    Mat normalThresholdMat = thresholdMat.clone();
    Mat deal = HalfMat(normalThresholdMat);
    cv::threshold(deal, deal,100, 100, cv::THRESH_BINARY);
    check(HalfMatBack(normalThresholdMat,deal),@"普通二值化");
  
    Mat adapterThresholdMat = thresholdMat.clone();
    Mat deal2 = HalfMat(adapterThresholdMat);
    cv::adaptiveThreshold(deal2,deal2 , 100, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, 5, 0);
    check(HalfMatBack(adapterThresholdMat,deal2),@"自适应二值化");
//    平滑
    Mat blurMat = HalfMat(src);
    
    Mat blur1 = blurMat.clone();
    cv::blur(blur1, blur1, cv::Size(3,3));
    check(HalfMatBack(src, blur1),@"3x3简单平滑");
    
    Mat blur2 = blurMat.clone();
    cv::boxFilter(blur2, blur2, -1, cv::Size(5,5));
    check(HalfMatBack(src, blur2),@"5x5归一化方框滤波器");
    
    Mat testBlur = blurMat.clone();
    cv::medianBlur(testBlur, testBlur, 5);
    check(HalfMatBack(src, testBlur),@"5x5中值滤波");
    
    testBlur = blurMat.clone();
    cv::GaussianBlur(testBlur, testBlur,cv::Size(5,5), 0);
    check(HalfMatBack(src, testBlur),@"5x5高斯滤波");
    

    
    testBlur = blurMat.clone();
    
    cv::cvtColor(testBlur, testBlur, CV_RGBA2RGB);
    testBlur.convertTo(testBlur, CV_8UC3);
    
    cout<<testBlur.type()<<"="<<(testBlur.type() == (((0) & ((1 << 3) - 1)) + (((3)-1) << 3)))<<">"<<(testBlur.depth() == CV_8U)<<endl;
    
    Mat resultMat;
    cv::bilateralFilter(testBlur, resultMat, 20, 100, 100);
    
    cv::cvtColor(resultMat, resultMat, CV_RGB2RGBA);
    
    check(HalfMatBack(src, resultMat),@"5x5双边滤波");
    
    CV_TEST_CODE_END
}
@end
