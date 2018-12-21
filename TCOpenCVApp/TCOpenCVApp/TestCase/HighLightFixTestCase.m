//
//  HighLightFixTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/21.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "HighLightFixTestCase.h"

@interface HighLightFixTestCase ()

@end

@implementation HighLightFixTestCase


- (NSString*)title{
    return @"直方图均衡";
}

- (NSArray*)controlItems{
    return @[
             
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
    

    
    Mat src1;
    MatFromImage(@"10s6t_0.png", src1);
    
    Mat src2;
    MatFromImage(@"10s6t_2.png", src2);
    
    Mat src3;
    MatFromImage(@"10s6t_1.png", src3);
    
    check(src1,@"origin1");
    [self fix:src1 stageImageSet:check];
    
    check(src2,@"origin2");
    [self fix:src2 stageImageSet:check];
    
    check(src3,@"origin3");
    [self fix:src3 stageImageSet:check];
    
    CV_TEST_CODE_END
}

- (void)fix:(Mat)orgin
stageImageSet:(void(^)(Mat img,NSString *label))check{
    
    //绘制直方图
    cvtColor(orgin, orgin, CV_BGR2YCrCb);
    check(HistMap(orgin),@"原始直方图");
//    check(orgin,@"原始图");
    
    Mat * chanelArray = new Mat[orgin.channels()];
    cv::split(orgin, chanelArray);

    for(int i = 0; i < 1; i++){
        cv::equalizeHist(chanelArray[i], chanelArray[i]);
    }
    
    Mat result;
    
    cv::merge(chanelArray, orgin.channels(), result);
    
    cv::cvtColor(result, result, CV_YCrCb2BGR);
    
    check(HistMap(result),@"均衡之后的直方图");
    
    check(result,@"result");
    
}



@end
