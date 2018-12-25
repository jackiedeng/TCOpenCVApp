//
//  ContoursTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/24.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "ContoursTestCase.h"

@interface ContoursTestCase ()

@end

@implementation ContoursTestCase


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSString*)title{
    return @"轮廓查找与绘制";
}

- (NSArray*)controlItems{
    return @[
             [DrawMaskConfigItem drawMaskWithType:NONE_MASK
                                            title:@"orgin"
                                              key:@"mask"
                                            image:[UIImage imageNamed:@"test2.png"]]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
    
    NSDictionary * dict = [configs objectForKey:@"mask"];
    UIImage * image = [dict objectForKey:@"image"];
    
    Mat src;
    UIImageToMat(image, src);
    
    check(src,@"origin");
    
    cvtColor(src, src, CV_RGBA2RGB);
    Mat backGround;
    backGround = src.clone();
//    cv::pyrMeanShiftFiltering(src, src, 5, 5);
//    check(src,@"shift");
//    cv::bitwise_not(src, src);
    
   
    
    cvtColor(src, src, CV_RGBA2GRAY);
    check(src,@"gray");
    cv::equalizeHist(src, src);
    check(src,@"equalize");
    
    Mat result;
    cv::bilateralFilter(src, result, 6, 50,100);
    src=result;
    check(src,@"bilateral");
    
//
//    cv::morphologyEx(src,src, cv::MORPH_OPEN, cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5,5)),cv::Point(-1,-1),2);
    
    src.convertTo(src,-1,2,0);
    
//    check(src,@"open");
    
    
    double max,min;
    //find max min
    double scale= 3.0;
    cv::minMaxLoc(src, &min,&max);
    double lower = cv::abs( (max-min)/scale );
    double higher = cv::abs( (max-min)/scale *(scale-1) );
    double mid = (lower+higher)/2;
//    cv::Canny(result, result,mid,mid);
    cv::Canny(src, src, lower, higher);
    
    //find contours
    
    
    
    cv::pyrMeanShiftFiltering(backGround, backGround, 10, 30);
    cvtColor(backGround, backGround, CV_RGBA2GRAY);
    
    cv::minMaxLoc(backGround, &min,&max);
    
//    double offset = 255-max;
//    backGround.convertTo(backGround, -1,1,offset);
    
    check(src,@"result");
    
    cv:addWeighted(src,1, backGround, 1, 0, src);
    
    check(src,@"canny");
    
    check([CVUtil drawHistmapByImage:backGround],@"hist");
    
    
    CV_TEST_CODE_END
}

@end
