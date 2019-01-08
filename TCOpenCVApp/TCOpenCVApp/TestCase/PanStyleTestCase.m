//
//  PanStyleTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2019/1/8.
//  Copyright © 2019 jackiedeng. All rights reserved.
//

#import "PanStyleTestCase.h"

@implementation PanStyleTestCase


- (NSString*)title{
    return @"铅笔笔触研究院";
}

- (NSArray*)controlItems{
    return @[
//             [DrawMaskConfigItem drawMaskWithType:NONE_MASK
//                                            title:@"orgin"
//                                              key:@"mask"
//                                            image:[UIImage imageNamed:@"test2.png"]]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    
    CV_TEST_CODE_BEGIN
    
    Mat src = Mat::zeros(cv::Size(200,200),CV_8UC1);
    
    
    check(src,@"base");
 
    CV_TEST_CODE_END
}


- (Mat)drawLine:(int)depth
           size:(cv::Size)size{
    
    Mat lineMat = Mat(size,CV_8UC3,Scalar(255,255,255));
    //    int radius= 1;
    for(int i = 0; i < 20000; i++)
    {
        //        cv::circle(lineMat, cv::Point(rand()%100,rand()%100), radius, Scalar(200,200,200));
        
        Vec3b vec = lineMat.at<Vec3b>(rand()%50,rand()%50);
        
        int color =  vec[0];
        
        if(color < depth){
            color = depth;
        }else{
            color -= 40;
        }
        
        lineMat.at<Vec3b>((int)(rand()%size.height),(int)(rand()%size.width)) = Vec3b(color,color,color);
    }
    
    //    Mat result;
    //    cv::copyMakeBorder(lineMat, result, (size.height-50)/2, (size.height-50)/2, (size.width-50)/2, (size.width-50)/2, cv::BORDER_REFLECT101);
    
    //    cout<<lineMat<<endl;
    return lineMat;
    
}

@end
