//
//  FindContoursTestCase.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/25.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "FindContoursTestCase.h"

@interface FindContoursTestCase ()

@end

@implementation FindContoursTestCase


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSString*)title{
    return @"轮廓分析";
}

- (NSArray*)controlItems{
    return @[
             [DrawMaskConfigItem drawMaskWithType:NONE_MASK
                                            title:@"原始图片"
                                              key:@"mask"
                                            image:[UIImage imageNamed:@"test2.png"]],
             
             [SlideConfigItem slideConfigWithTitle:@"轮廓"
                                               key:@"hold"
                                             range:NSMakeRange(0, 255)
                                      defaultValue: 100],
             
             [SlideConfigItem slideConfigWithTitle:@"过滤面积"
                                               key:@"size"
                                             range:NSMakeRange(0, 255)
                                      defaultValue: 1],
             
             [SlideConfigItem slideConfigWithTitle:@"多变形逼近"
                                               key:@"dpSize"
                                             range:NSMakeRange(1, 100)
                                      defaultValue: 10]
             
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
    
    float hold = (float)getFloatValue(@"hold", configs);
    float size = getFloatValue(@"size", configs);
    float dpSize = getFloatValue(@"dpSize", configs);
    
    Mat src;
    UIImageToMat(image, src);
    
    cvtColor(src, src, CV_RGBA2GRAY);
    
    cv::threshold(src, src, hold, 255, cv::THRESH_BINARY_INV);
    
    check(src,@"thrshod");
    
    vector<vector<Point2i>> contours;
    vector<Vec4i> hierarchy;
    
    cv::findContours(src, contours, hierarchy, cv::RETR_CCOMP, cv::CHAIN_APPROX_SIMPLE);
    
    Mat result = Mat::ones(src.size(),CV_8UC3);
    
    double step = 255.0/hierarchy.size();
    
    for(int i = 0; i < hierarchy.size();i++){
        cv::approxPolyDP(contours[i], contours[i], dpSize, true);
    }
    
    for(int i = 0; i < hierarchy.size(); i++){
        
        cv::drawContours(result, contours, i, Scalar(i*step,0,0),1,8,hierarchy,2,cv::Point(0,0));
    }
    
    check(result,@"多边形逼近");
    
    check([self markLinkArea:src size:size dpSize:dpSize],@"mark");
    
    CV_TEST_CODE_END
}

- (Mat)markLinkArea:(Mat)srcMat
               size:(float)size
             dpSize:(float)dpSize{
    
    Mat labels,temp,stats;
    
    int total = cv::connectedComponentsWithStats(srcMat, labels,stats,temp);
    
    Vec3b * colors = new Vec3b[total];
    
    for(int i = 0; i < total; i++){
        colors[i] = Vec3b(rand()%255,rand()%255,rand()%255);
        
        if( stats.at<int>(i,cv::CC_STAT_AREA)< size){
            
            colors[i] = Vec3b(0,0,0);
        }
    }
    
    Mat result = Mat::zeros(srcMat.size(),CV_8UC3);
    
    MatIterator_<int> labelInterator = labels.begin<int>();
    MatIterator_<Vec3b> resultInterator = result.begin<Vec3b>();
        
    for(;labelInterator!=labels.end<int>() && resultInterator!=result.end<Vec3b>();
        labelInterator++,resultInterator++){
        (*resultInterator) = colors[(*labelInterator)];
    }
    
    //过滤
    delete[] colors;
    
    return result;
    
}

@end
