//
//  ImageCutTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/22.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "ImageCutTestCase.h"

@implementation ImageCutTestCase


- (NSString*)title{
    return @"图像切割";
}

- (NSArray*)controlItems{
    return @[
             [SlideConfigItem slideConfigWithTitle:@"offset" key:@"offset"
                                             range:NSMakeRange(1, 10)
                                      defaultValue:6]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
   
    int offset = (int)getFloatValue(@"offset", configs);
    
    Mat src;
    Test1Mat(src);
    
    cvtColor(src, src, CV_RGBA2RGB);
    
    Mat floodMat = src.clone();
    cv::Rect rect;
    cv::floodFill(floodMat, Point2i(300,50), Scalar(255,0,0),&rect,Scalar(offset,offset,offset),Scalar(offset,offset,offset));
    
    check(floodMat,@"漫水填充");
    
    CV_TEST_CODE_END
}
@end
