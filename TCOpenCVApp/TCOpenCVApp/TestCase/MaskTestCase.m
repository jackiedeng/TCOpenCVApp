//
//  MaskTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/21.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "MaskTestCase.h"

@interface MaskTestCase ()

@end

@implementation MaskTestCase

- (NSString*)title{
    return @"蒙版";
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
    
    Mat src1,src2;
    MatFromImage(@"test.png", src1);
    MatFromImage(@"test2.png", src2);
    
    Mat rect = src1(cv::Rect(0,0,150,150));
    Mat rect2 = src2(cv::Rect(50,50,150,150));
    
    
    Mat mask = Mat::zeros(cv::Size(150,150), CV_8U);
    
    circle(mask, cv::Point(75,75), 40, Scalar(255),-1,8);
    
    circle(mask, cv::Point(25,25), 20, Scalar(100),-1,8);
    
    cv::GaussianBlur(mask, mask, cv::Size(5,5), 3);
    
    check(mask,@"mask");
    
    rect.copyTo(rect2,mask);
    
    
    
    check(src2,@"result");
  
    
    CV_TEST_CODE_END
}


@end
