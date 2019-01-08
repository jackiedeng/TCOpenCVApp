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
#import "DrawMaskConfigItem.h"
#import "CVUtil.h"

using namespace std;
using namespace cv;

typedef enum{
    single_image = 0,
    multi_stage,
}ProcessType;

#define getValue(k,c) [self valueFromConfig:k config:c]
#define getFloatValue(k,c) [self floatValueFromConfig:k config:c]
#define lhImg(x) [self leftHalfImage:x]

#define CV_TEST_CODE_BEGIN
#define CV_TEST_CODE_END

NS_ASSUME_NONNULL_BEGIN

@interface OpCVBaseViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//所有测试

- (NSString*)title;
- (NSArray*)controlItems;
//处理流程 处理单张还是多张 默认single_image
- (ProcessType)processType;
//单张图片处理
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)configs;
//处理多张图片过程 用于显示处理过程过程中的图片
- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck;
;

- (cv::Mat)imageNamed:(NSString*_Nonnull)image;

- (NSString*)valueFromConfig:(NSString*)key config:(NSDictionary*)config;
- (float)floatValueFromConfig:(NSString*)key config:(NSDictionary*)config;

- (UIImage*)imageToSave;

@end

NS_ASSUME_NONNULL_END
