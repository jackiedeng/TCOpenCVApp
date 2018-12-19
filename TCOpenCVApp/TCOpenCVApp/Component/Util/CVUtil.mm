//
//  OpenCVTool.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "CVUtil.h"
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/types.hpp>
#import <opencv2/imgproc/types_c.h>
using namespace std;
using namespace cv;

@implementation CVUtil

+ (UIImage*)test{
    
    NSLog(@"begin>>>>");
    Mat d,dd;
    
   
    double t = (double)getTickCount();
  
//    d = Mat(Size_<int>(width,height),CV_8UC3,Scalar(255,0,0));
    UIImage * image = [UIImage imageNamed:@"test.png"];
//
    UIImageToMat(image, d);
    
    int width = d.cols;
    int height = d.rows;
    
    cout<<"width:"<<width<<endl<<"height:"<<height<<endl;
    
    dd = Mat(d,Rect_<int>(0,0,width/2,height/2));
    
    MatIterator_<Vec3b> interator;
    
    Mat filter = (Mat_<char>(5,5) <<  0,0,0,0,0,
                                      0,0,0,0,0,
                                      -1,0,3,0,-1,
                                      0,0,0,0,0,
                                      0,0,0,0,0
    );
    
    filter2D(dd, dd, dd.depth(), filter);
    
    t = ((double)getTickCount() - t)/getTickFrequency();
    
    Mat redBackgrond = Mat(d.rows,d.cols,d.type(),Scalar(255,0,0));
    
    addWeighted(d, 0.6, redBackgrond, 0.4, 0.0, d);
    
    cout<<"use time:"<<t;
    return MatToUIImage(d);
}
    
@end
