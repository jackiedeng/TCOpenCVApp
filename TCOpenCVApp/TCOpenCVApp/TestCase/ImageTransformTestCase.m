//
//  ImageTransformTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/21.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "ImageTransformTestCase.h"

@interface ImageTransformTestCase ()

@end

@implementation ImageTransformTestCase

- (NSString*)title{
    return @"图像变换(仿射&透视)";
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
    Test1Mat(src1);
    check(src1,@"origin");
    
//    cv::warpAffine(<#InputArray src#>, <#OutputArray dst#>, <#InputArray M#>, <#Size dsize#>)
    cv::warpAffine(src1, src2, cv::getRotationMatrix2D(cv::Point(src1.size().width/2,src1.size().height/2),
                                                       180, 1.0),src1.size());
    
    
    check(src2,@"rotate");
    
    Point2f srcPoint[3];
    Point2f dstPoint[3];
    
    srcPoint[0] = Point2f(0,0);
    srcPoint[1] = Point2f(src1.size().width,0);
    srcPoint[2] = Point2f(0,src1.size().height);
    
    dstPoint[0] = Point2f(0,src1.size().height/2);
    dstPoint[1] = Point2f(src1.size().width/2,0);
    dstPoint[2] = Point2f(src1.size().width/2,src1.size().height);
    
    cv::warpAffine(src1, src2, cv::getAffineTransform(srcPoint, dstPoint), src1.size());
    check(src2,@"仿射");
    
    double M = 70.0;
    Mat result;
//    cv::logPolar(src1, result, Point2f(src1.size().width/2,src1.size().height/2)
//                 , M, cv::INTER_LINEAR|cv::WARP_FILL_OUTLIERS);
//
    cv::logPolar(src1, result, Point2f(src1.size().width/2,src1.size().height/2)
                 , M, cv::INTER_LINEAR|cv::WARP_FILL_OUTLIERS);
    
    
    
    check(result,@"极坐标WARP_FILL_OUTLIERS");
    
    cv::logPolar(src1, result, Point2f(src1.size().width/2,src1.size().height/2)
                                  , M, cv::INTER_LINEAR|cv::WARP_INVERSE_MAP);
    
    check(result,@"极坐标WARP_INVERSE_MAP");
    CV_TEST_CODE_END
}

@end
