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

#define MAX_WIDTH 100
#define MAX_HEIGHT 100
     
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

+ (Mat)drawHistmap:(Mat*)histMap length:(int)length{
    
    int height = 150;
    int width = 255;
    int border = 10;
    
    Mat map = Mat::zeros(cv::Size(width,height), CV_8UC4);
    
    cv::copyMakeBorder(map, map, border, border, border, border, cv::BORDER_DEFAULT);
    
    Scalar color[3] = {
        Scalar(255,0,0,100),
        Scalar(0,255,0,100),
        Scalar(0,0,255,100)
    };
    
    for(int index = 0; index < length; index++){

        double max,min;
        cv::minMaxLoc(histMap[index], &min,&max);
        
        for(int i = 0; i < histMap[index].size().height; i++){
            
    //        int value = histMap.at<float>(i);
            cv::line(map, cv::Point(border+i,height*0.9+border), cv::Point(i+border,(1.0-histMap[index].at<float>(i,0)/max)*height*0.9+border), color[index%3]);
            
    //        cout << i <<":"<<histMap.at<float>(i,0)<<endl;
        }
        
    }
    return map;
}

+ (Mat)drawHistmapByImage:(Mat)orgin{
    
    int chanels[1] ={0};
    int histSize[] = { 256 };
    float midRanges[] = { 0, 256 };
    const float *range[] = {midRanges};
    
    if(orgin.channels() >=4){
        cv::cvtColor(orgin, orgin, CV_RGBA2RGB);
    }
    
    Mat * chanelArray = new Mat[orgin.channels()];
    cv::split(orgin, chanelArray);
    
    Mat * histMapArray = new Mat[orgin.channels()];
    
    for(int i = 0; i < orgin.channels(); i++){
        cv::calcHist(&chanelArray[i],1, chanels, Mat(), histMapArray[i],1, histSize, range);
    }

    return [CVUtil drawHistmap:histMapArray length:orgin.channels()];
}
@end
