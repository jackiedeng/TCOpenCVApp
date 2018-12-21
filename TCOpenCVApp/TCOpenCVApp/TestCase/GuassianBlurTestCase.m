//
//  GuassianBlurTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/20.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "GuassianBlurTestCase.h"

@interface GuassianBlurTestCase ()

@end

@implementation GuassianBlurTestCase

- (NSString*)title{
    return @"高斯模糊";
}

- (NSArray*)controlItems{
    return @[
             
             [SelectionConfigItem selectConfigWithTitle:@"kSize"
                                                    key:@"k"
                                             selections:@{@"3":@"3",@"5":@"5",@"7":@"7",@"9":@"9"}
                                           defaultValue:@"3"],
             [SlideConfigItem slideConfigWithTitle:@"sigmaX"
                                               key:@"x"
                                             range:NSMakeRange(1,60)
                                      defaultValue:1],
             [SlideConfigItem slideConfigWithTitle:@"sigmaY"
                                               key:@"y"
                                             range:NSMakeRange(0,60)
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
    
    NSString* ksize = getValue(@"k", configs);
    float sigmaX = getFloatValue(@"x", configs);
    float sigmaY = getFloatValue(@"y", configs);
    
    Mat src;
    Test1Mat(src);
    Mat orgin = src.clone();
    
    src = HalfMat(src);
//    cvtColor(src, src, CV_RGBA2RGB);
    cv::GaussianBlur(src, src, cv::Size([ksize intValue],[ksize intValue]), sigmaX,sigmaY);
    
    check(HalfMatBack(orgin,src),@"result");
    
    CV_TEST_CODE_END
}


@end
