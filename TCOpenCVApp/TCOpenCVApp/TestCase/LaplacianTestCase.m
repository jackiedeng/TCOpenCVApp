//
//  LaplacianTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/20.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "LaplacianTestCase.h"

@interface LaplacianTestCase ()

@end

@implementation LaplacianTestCase

- (NSString*)title{
    return @"拉普拉斯变换";
}

- (NSArray*)controlItems{
    return @[
    
             [SelectionConfigItem selectConfigWithTitle:@"kSize"
                                                    key:@"k"
                                             selections:@{@"3":@"3",@"5":@"5",@"7":@"7",@"9":@"9"}
                                           defaultValue:@"3"],
             [SlideConfigItem slideConfigWithTitle:@"scale"
                                               key:@"scale"
                                             range:NSMakeRange(1, 10)
                                      defaultValue:1],
             [SlideConfigItem slideConfigWithTitle:@"delta"
                                               key:@"delta"
                                             range:NSMakeRange(0, 255)
                                      defaultValue:0]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
    
    NSString* ksize = getValue(@"k", configs);
    float scale = getFloatValue(@"scale", configs);
    float delta = getFloatValue(@"delta", configs);
  
    Mat src;
    Test1Mat(src);
    cvtColor(src, src, CV_RGBA2RGB);
    

    
    cv::Laplacian(src, src, src.depth(),[ksize intValue],scale,delta);
    
    check(src,@"result");
    
    CV_TEST_CODE_END
}

@end
