//
//  OpCVBaseViewController.h
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/types.hpp>
#import <opencv2/core/utility.hpp>
#import <opencv2/imgproc/types_c.h>
#import "SlideConfigItem.h"
#import "SelectionConfigItem.h"

using namespace std;
using namespace cv;

#define getValue(k,c) [self valueFromConfig:k config:c]
#define getFloatValue(k,c) [self floatValueFromConfig:k config:c]
#define lhImg(x) [self leftHalfImage:x]

NS_ASSUME_NONNULL_BEGIN

@interface OpCVBaseViewController : UIViewController
- (NSString*)title;
- (NSArray*)controlItems;
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)configs;
- (cv::Mat)imageNamed:(NSString*_Nonnull)image;
- (Mat)leftHalfImage:(Mat)img;
- (NSString*)valueFromConfig:(NSString*)key config:(NSDictionary*)config;
- (float)floatValueFromConfig:(NSString*)key config:(NSDictionary*)config;
@end

NS_ASSUME_NONNULL_END
