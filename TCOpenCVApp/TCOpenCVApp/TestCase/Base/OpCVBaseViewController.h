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

using namespace std;
using namespace cv;

#define getValue(x,y) [self valueFromConfig:x config:y]

NS_ASSUME_NONNULL_BEGIN

@interface OpCVBaseViewController : UIViewController
- (NSString*)title;
- (NSArray*)controlItems;
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)configs;
- (cv::Mat)imageNamed:(NSString*_Nonnull)image;
- (instancetype)valueFromConfig:(NSString*)key config:(NSDictionary*)config;
@end

NS_ASSUME_NONNULL_END
