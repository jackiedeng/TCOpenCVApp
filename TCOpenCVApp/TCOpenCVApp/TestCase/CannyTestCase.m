//
//  CannyTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/22.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "CannyTestCase.h"

@interface CannyTestCase ()

@end

@implementation CannyTestCase

- (NSString*)title{
    return @"canny边缘检测";
}

- (NSArray*)controlItems{
    return @[
             
             [SlideConfigItem slideConfigWithTitle:@"lower threshold" key:@"lt" range:NSMakeRange(0,255) defaultValue:140],
             [SlideConfigItem slideConfigWithTitle:@"high threshold" key:@"ht" range:NSMakeRange(0,255) defaultValue:76],
             
              [SlideConfigItem slideConfigWithTitle:@"hough threshold" key:@"threshold" range:NSMakeRange(0,255) defaultValue:100],
             
             [SlideConfigItem slideConfigWithTitle:@"rho" key:@"rho" range:NSMakeRange(1,100) defaultValue:1],
             
             
              [SlideConfigItem slideConfigWithTitle:@"theta" key:@"theta" range:NSMakeRange(0,360) defaultValue:180],
             
             [SelectionConfigItem selectConfigWithTitle:@"L2gradient"
                                                    key:@"l2g"
                                             selections:@{@"true":@"true",@"false":@"false"}
                                           defaultValue:@"false"]
        
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
    
    float lt = getFloatValue(@"lt", configs);
    float ht = getFloatValue(@"ht", configs);
    int threshold = (int)getFloatValue(@"threshold", configs);
    float theta = getFloatValue(@"theta", configs);
    float rho = getFloatValue(@"rho", configs);
    bool l2g = [getValue(@"l2g", configs) boolValue];
    
    Mat src,src2;
    Test1Mat(src);
    MatFromImage(@"test.png", src2);
    
    cvtColor(src, src, CV_RGBA2GRAY);
    cvtColor(src2, src2, CV_RGBA2GRAY);
    
    Mat orgin = src.clone();
    
    src = HalfMat(src);
    //    cvtColor(src, src, CV_RGBA2RGB);
    cv::Canny(src, src, lt, ht,3,l2g);
    
    check(HalfMatBack(orgin,src),@"result");
    
  
  
    
    src = HalfMat(src2);
    //    cvtColor(src, src, CV_RGBA2RGB);
    cv::Canny(src, src, lt, ht,3,l2g);
    
    check(HalfMatBack(src2,src),@"result");
    
    Mat lines;
    cv::HoughLines(src, lines, rho, CV_PI/theta, threshold);
    
    cout<<lines<<endl;
    
    MatIterator_<Vec2f> it = lines.begin<Vec2f>();
    
    Mat lineMat = Mat::zeros(src.size(),CV_8UC1);
    
    int w = 1000;
    int h = 1000;
    
    for(;it != lines.end<Vec2f>();it++){
       
        float rho = (*it)[0];
        float theta = (*it)[1];
        
        double a = cos(theta),b=sin(theta);
        double x0 = a*rho,y0=b*rho;
        
        cv::Point2f p1,p2;
        
        p1 = cv::Point2f(cvRound(x0+w*(-b)),cvRound(y0+h*(a)));
        p2 = cv::Point2f(cvRound(x0-w*(-b)),cvRound(y0-h*(a)));
        
        cv::line(lineMat, p1, p2, Scalar(255));
    }
    
    check(lineMat,@"标准houghline");
    
    Mat plines;
    cv::HoughLinesP(src, plines, rho, CV_PI/theta, threshold);
    Mat pLineMat = Mat::zeros(src.size(),CV_8UC1);
    
    MatIterator_<Vec4i> plineIterator = plines.begin<Vec4i>();
    
    for(;plineIterator != plines.end<Vec4i>();plineIterator++){
        
        line(pLineMat, cv::Point2i((*plineIterator)[0],(*plineIterator)[1]),
             cv::Point2i((*plineIterator)[2],(*plineIterator)[3]), Scalar(255));
        
    }
    
    check(pLineMat,@"渐进概率houghline");
    
    
    CV_TEST_CODE_END
}

@end
