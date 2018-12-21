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
//    Mat src;
//    Test1Mat(src);
//    check(src,@"原始");
//
////  二值化
//    Mat thresholdMat;
//    cv::cvtColor(src, thresholdMat, CV_BGRA2GRAY);
//
//    Mat normalThresholdMat = thresholdMat.clone();
//    Mat deal = HalfMat(normalThresholdMat);
//    cv::threshold(deal, deal,100, 100, cv::THRESH_BINARY);
//    check(HalfMatBack(normalThresholdMat,deal),@"普通二值化");
//
//    Mat adapterThresholdMat = thresholdMat.clone();
//    Mat deal2 = HalfMat(adapterThresholdMat);
//    cv::adaptiveThreshold(deal2,deal2 , 100, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, 5, 0);
//    check(HalfMatBack(adapterThresholdMat,deal2),@"自适应二值化");
////    平滑
//    Mat blurMat = HalfMat(src);
//
//    Mat blur1 = blurMat.clone();
//    cv::blur(blur1, blur1, cv::Size(3,3));
//    check(HalfMatBack(src, blur1),@"3x3简单平滑");
//
//    Mat blur2 = blurMat.clone();
//    cv::boxFilter(blur2, blur2, -1, cv::Size(5,5));
//    check(HalfMatBack(src, blur2),@"5x5归一化方框滤波器");
//
//    Mat testBlur = blurMat.clone();
//    cv::medianBlur(testBlur, testBlur, 5);
//    check(HalfMatBack(src, testBlur),@"5x5中值滤波");
//
//    testBlur = blurMat.clone();
//    cv::GaussianBlur(testBlur, testBlur,cv::Size(5,5), 0);
//    check(HalfMatBack(src, testBlur),@"5x5高斯滤波");
//
    
    Mat single = Mat::zeros(100, 100, CV_8UC1);
    
    single.at<char>(50,50) = (char)255;
    
    Mat double5x5 = single.clone();
    
    check(single,@"习题2");
    
    cv::GaussianBlur(single, single, cv::Size(5,5), 1);
    
    check(single,@"guassian 5x5");
    
    cv::GaussianBlur(single, single, cv::Size(9,9), 1);
    
    check(single,@"guassian + 9x9");
    
    cv::GaussianBlur(double5x5, double5x5, cv::Size(5,5), 1);
    cv::GaussianBlur(double5x5, double5x5, cv::Size(5,5), 1);

    check(double5x5,@"guassian 2*5x5");
    
    [self test4WithstageImageSet:check];
    
    CV_TEST_CODE_END
}


- (void)test4WithstageImageSet:(void(^)(Mat img,NSString *label))check{
    
    Mat src1,src2;
    MatFromImage(@"10s5t_0.JPG",src1);
    MatFromImage(@"10s5t_1.JPG",src2);
    
    cvtColor(src1, src1, CV_RGB2GRAY);
    cvtColor(src2, src2, CV_RGB2GRAY);
    
    Mat subResut;
    cv::subtract(src1, src2, subResut);
    cv::abs(subResut);

    check(subResut,@"习题5a");
    
    Mat thresholdMat;
    cv::threshold(subResut, thresholdMat, 0, 255, cv::THRESH_OTSU|cv::THRESH_BINARY);
//
//    cv::morphologyEx(subResut, subResut, cv::MORPH_OPEN, cv::getStructuringElement(cv::MORPH_RECT,cv::Size(5,5)));
//
//    cv::bitwise_and(src2, subResut, subResut);
    
    check(thresholdMat,@"5b");
//    cv::adaptiveThreshold(subResut, subResut, <#double maxValue#>, <#int adaptiveMethod#>, <#int thresholdType#>, <#int blockSize#>, <#double C#>)
    
    
}
@end
