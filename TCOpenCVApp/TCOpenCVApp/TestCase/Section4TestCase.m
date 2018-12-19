//
//  Section4TestCase.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/19.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "Section4TestCase.h"

@interface Section4TestCase ()

@end

@implementation Section4TestCase

- (NSString*)title{
    return @"第4章节练习";
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
    
    Test1Mat(src);
    
    check(src,nil,@"练习2 积分图（练习一打字一很无聊略过了）");
    
    Mat chanels = Mat::zeros(Size2i(10,10), CV_32FC1);
    
    RNG rand = RNG(1);
    
    rand.fill(chanels, RNG::UNIFORM, 1, 200);
    
    check(Mat(),[CVUtil matNumberImage:chanels],@"单通道随机");

    Mat resultMat = chanels.clone();
    resultMat.setTo(0);
//    cout<<sumMat<<endl;
    //计算积分图
    for(int row = 0; row < chanels.rows; row++){
        
        for(int col =0 ;col < chanels.cols; col++){
            
            Mat subMat = chanels(Rect2i(0,0,row+1,col+1));
            Scalar a = cv::sum(subMat);
            resultMat.at<float>(col,row) = a[0];
        }
    }
    
    check(Mat(),[CVUtil matNumberImage:resultMat],@"积分图");
    
    CV_TEST_CODE_END
}

@end
