//
//  MultiStageTestCase.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/18.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "MultiStageTestCase.h"

@interface MultiStageTestCase ()

@end

@implementation MultiStageTestCase
- (NSString*)title{
    return @"多阶段测试";
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
    
    Mat src;
    
    UIImageToMat([UIImage imageNamed:@"test.png"],src);
    
    check(src,@"orgin");
    
    Mat gray;
    cvtColor(src, gray, COLOR_RGB2GRAY);
    
    check(gray,@"gary");
    
    Mat mask = Mat(gray.size(),gray.type(),Scalar(255));
    
    addWeighted(mask, 0.5, gray, 0.5, 0.0, gray);
    
    check(gray,@"half");
    
    Mat half = src(cv::Rect(0,0,100,100));
    Ptr<Mat> p = makePtr<Mat>(half);
    
    [NSValue valueWithPointer:p];
    
    check(half,@"part");
    
    CV_TEST_CODE_END
}

@end
