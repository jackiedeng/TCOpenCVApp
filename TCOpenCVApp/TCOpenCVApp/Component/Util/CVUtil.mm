//
//  OpenCVTool.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "CVUtil.h"

@implementation CVUtil
+ (UIImage*)testImage{
    return [UIImage imageNamed:@"test2.png"];
}

+ (UIImage*)matNumberImage:(Mat)mat{

#define MAX_WIDTH 10
#define MAX_HEIGHT 10
     
    Size2i singleDisplaySize = Size2i(40,40);
    int width = mat.size().width > MAX_WIDTH?MAX_WIDTH:mat.size().width;
    int height = mat.size().height > MAX_HEIGHT?MAX_HEIGHT:mat.size().height;
    
    Mat numberMat = Mat::zeros(Size2i(singleDisplaySize.width*width,singleDisplaySize.height*height),CV_8UC3);
    
    for(int i = 0; i < width; i++){
        for(int j = 0; j < height; j++){
            
            Mat subMat = numberMat(Rect2i(i*singleDisplaySize.width,
                                          j*singleDisplaySize.height,
                                          singleDisplaySize.width,
                                          singleDisplaySize.height));
            Scalar color;
            if(i%2==0){
                color = j%2==0?Scalar(100,100,100):Scalar(50,50,50);
            }else{
                color = j%2==0?Scalar(50,50,50):Scalar(100,100,100);
            }
            Mat(subMat.size(),subMat.type(),color).copyTo(subMat);
            
            NSString * text = [NSString stringWithFormat:@"%.0f",mat.at<float>(j,i)];
            
            putText(subMat, [text UTF8String], Point2i(0,singleDisplaySize.height/2),
                    CV_FONT_HERSHEY_COMPLEX_SMALL, 0.7, Scalar(255,255,255));
        }
    }
    
    return MatToUIImage(numberMat);
}

+ (Mat)leftHalfImage:(Mat)img{
    
    return img(cv::Rect(0,0,img.size().width/2,img.size().height)).clone();
}

+ (Mat)halfImageBackToOrgin:(Mat)orgin half:(Mat)half{
    
    Mat newOrgin = orgin.clone();
    
    Mat right = newOrgin(cv::Rect(half.size().width,0,half.size().width,half.size().height));
    
//    right.setTo(half);
    cv::addWeighted(right, 0, half, 1, 0, right);
    
    return newOrgin;
}
@end
