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
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
CV_TEST_CODE_BEGIN
    
    Mat src;
    
    UIImageToMat([UIImage imageNamed:@"test.png"],src);
    
    Mat test1 = Mat(100,100,CV_8UC3,Scalar(0,0,0));
    
    circle(test1, Point2i(50,50), 30, Scalar(255,0,0));
    
    check(test1,@"练习1");
   
    Mat test2 = Mat(100,100,CV_8UC3,Scalar(0,0,0));
    
    rectangle(test2, Point2i(20,5), Point2i(40,20), Scalar(0,255,0));
    
    check(test2,@"练习2");
    
    check([self test4],@"练习4");
    
    check([self test5],@"练习5");
    
    [self test6:check];

CV_TEST_CODE_END
}

- (Mat)test4{
 
    int width=210;
    Mat test3 = Mat::zeros(width, width, CV_8UC1);
    int count = 0;
    for(int height=20;height < width;height+=20){
        
        cv::Rect drawRect = cv::Rect(count*10,(width-height)/2,10,height);
        cout<<"rect:"<<drawRect<<endl;
        Mat box = test3(drawRect);
        count++;
        
        box.setTo(100);
    }
    
    return test3;
}

- (Mat)test5{
    
    Mat src;
    Test1Mat(src);
    src = src(cv::Rect(0,0,100,100));
    
    Mat deal1 = src(cv::Rect(5,10,20,30));
    Mat deal2 = src(cv::Rect(50,60,20,30));
    
    bitwise_not(deal1, deal1);
    bitwise_not(deal2, deal2);
    
    return src;
}

- (void)test6:(void(^)(Mat img,NSString *label))check{
    
    Mat src;
    Test1Mat(src);
    
    check(src,@"练习6-1 原始图");
    
    Mat * chanelMat = new Mat[src.channels()];
    
    cv::split(src, chanelMat);
    
    chanelMat[0].setTo(0);
    chanelMat[2].setTo(0);
    
    Mat green;
    cv::merge(chanelMat, src.channels(), green);
    check(green,@"练习6-2 绿色通道图");
    
    Mat greenClone1 = chanelMat[1].clone();
    Mat greenClone2 = chanelMat[1].clone();
    
    double max,min,thresh;
    cv::minMaxLoc(green,&min,&max);
    
    thresh = (max-min)/2;
    
    greenClone1.setTo(thresh);
    greenClone2.setTo(0);
    cv::compare(chanelMat[1], greenClone1, greenClone2, cv::CMP_GE);
    
    cv::subtract(chanelMat[1], thresh, chanelMat[1],greenClone2);
    
    cv::merge(chanelMat, src.channels(), green);
    
    check(green,@"练习6-3 消除绿色均值/2以上的结果图");

    cv::split(src, chanelMat);
    
    chanelMat[1].setTo(0);
    
    Mat removeGreen;
    
    cv::merge(chanelMat, src.channels(), removeGreen);
    
    check(removeGreen,@"去绿色通道");
    
    
    delete [] chanelMat;
    
    
}

@end
