//
//  SketchStyle.h
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/25.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/types.hpp>
#import <opencv2/core/utility.hpp>
#import <opencv2/imgproc/types_c.h>

NS_ASSUME_NONNULL_BEGIN
using namespace cv;
using namespace std;

@interface SketchStyle : NSObject
- (Mat)sketchMat:(Mat)mat;
@end

NS_ASSUME_NONNULL_END
