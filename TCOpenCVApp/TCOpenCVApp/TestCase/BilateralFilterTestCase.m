//
//  BilateralFilterTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/20.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "BilateralFilterTestCase.h"

@implementation BilateralFilterTestCase
- (NSString*)title{
    return @"双边滤波器";
}

- (NSArray*)controlItems{
    return @[
             [SlideConfigItem slideConfigWithTitle:@"d"
                                               key:@"d"
                                             range:NSMakeRange(1, 10)
                                      defaultValue:2],
             [SlideConfigItem slideConfigWithTitle:@"sigmaColor"
                                               key:@"sigmaColor"
                                             range:NSMakeRange(1, 100)
                                      defaultValue:10],
             [SlideConfigItem slideConfigWithTitle:@"sigmaSpace"
                                               key:@"sigmaSpace"
                                             range:NSMakeRange(1, 200)
                                      defaultValue:100],
             [SlideConfigItem slideConfigWithTitle:@"loops"
                                               key:@"loop"
                                             range:NSMakeRange(1,5)
                                        isContinue:NO
                                      defaultValue:1]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
    
    float d = getFloatValue(@"d", configs);
    float sigmaColor = getFloatValue(@"sigmaColor", configs);
    float sigmaSpace = getFloatValue(@"sigmaSpace", configs);
    int loop = (int)getFloatValue(@"loop", configs);
    
    Mat src;
    Test1Mat(src);
    
    cv::cvtColor(src, src, CV_RGBA2RGB);
    
    Mat result;
    
    for(int i = 0; i < loop;i++){
        
        cv::bilateralFilter(src, result, (int)d, sigmaColor, sigmaSpace);
        src = result;
        result = Mat();
    }
    
    check(src,@"result");
    
    CV_TEST_CODE_END
}
@end
