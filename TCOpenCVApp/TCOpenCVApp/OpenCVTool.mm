//
//  OpenCVTool.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "OpenCVTool.h"
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/types.hpp>
#import <opencv2/imgproc/types_c.h>
using namespace std;
using namespace cv;

@implementation OpenCVTool

+ (UIImage*)test{
    
    NSLog(@"begin>>>>");
    Mat d,dd;
    
    int width = 300;
    int height = 50;
    
    d = Mat(Size_<int>(width,height),CV_8UC3,Scalar(255,0,0));
//    UIImage * image = [UIImage imageNamed:@"test.png"];
//
//    UIImageToMat(image, d);
    
    dd = Mat(d,Rect_<int>(0,0,50,50));
    
    MatIterator_<Vec3b> interator;
    
    for(interator=dd.begin<Vec3b>();interator != dd.end<Vec3b>();interator++){
        (*interator)[2] = 255;
    }
//    for(int row = 10; row < 20; row++){
//
//        for(int col = 0; col < d.cols; col++){
//
//            Vec3b vec;
//            vec[0] = 0;
//            vec[1] = 255;
//            vec[2] = 0;
//
//            d.at<Vec3b>(row,col) = vec;
//        }
//    }
//
    cout<<dd;
    return MatToUIImage(d);
}
    
@end
