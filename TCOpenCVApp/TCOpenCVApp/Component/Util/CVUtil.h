//
//  OpenCVTool.h
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/types.hpp>
#import <opencv2/imgproc/types_c.h>
using namespace std;
using namespace cv;

#define Test1Mat(x) UIImageToMat([CVUtil testImage], x)
#define MatFromImage(x,y) UIImageToMat([UIImage imageNamed:x], y)
#define HalfMat(x) [CVUtil leftHalfImage:x]
#define HalfMatBack(x,y) [CVUtil halfImageBackToOrgin:x half:y]

NS_ASSUME_NONNULL_BEGIN

@interface CVUtil : NSObject
+ (UIImage*)testImage;
//显示mat数字的图像
+ (UIImage*)matNumberImage:(Mat)mat;
+ (Mat)leftHalfImage:(Mat)img;
+ (Mat)halfImageBackToOrgin:(Mat)orgin half:(Mat)half;
@end

NS_ASSUME_NONNULL_END
