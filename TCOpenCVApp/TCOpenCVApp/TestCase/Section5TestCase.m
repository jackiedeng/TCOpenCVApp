//
//  Section5TestCase.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/19.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "Section5TestCase.h"

@interface Section5TestCase ()

@end

@implementation Section5TestCase

- (NSString*)title{
    return @"第5章节练习";
}

- (NSArray*)controlItems{
    return @[];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,UIImage*ocimage,NSString *label))check{
CV_TEST_CODE_BEGIN
    
    Mat src;
    
    UIImageToMat([UIImage imageNamed:@"test.png"],src);
    
    Mat test1 = Mat(100,100,CV_8UC3,Scalar(0,0,0));
    
    circle(test1, Point2i(50,50), 30, Scalar(255,0,0));
    
    check(test1,nil,@"练习1");
   
    Mat test2 = Mat(100,100,CV_8UC3,Scalar(0,0,0));
    
    rectangle(test2, Point2i(20,5), Point2i(40,20), Scalar(0,255,0));
    
    check(test2,nil,@"练习2");
    
    Mat test3 = Mat();
    test3.zeros(100, 100, CV_8UC3);
    
//    Point2i begin = Point2i(20,5);
//    Point2i end = Point2i(40,20);
//    

    
    
CV_TEST_CODE_END
}

@end
