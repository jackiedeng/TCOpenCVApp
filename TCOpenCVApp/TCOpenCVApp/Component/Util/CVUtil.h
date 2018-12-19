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

#define Test1Mat(x) UIImageToMat([UIImage imageNamed:@"test.png"], x)

NS_ASSUME_NONNULL_BEGIN

@interface CVUtil : NSObject
+ (UIImage*)test;
//显示mat数字的图像
+ (UIImage*)matNumberImage:(Mat)mat;
@end

NS_ASSUME_NONNULL_END
