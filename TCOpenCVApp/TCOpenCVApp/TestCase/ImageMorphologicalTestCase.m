//
//  ImageMorphologicalTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/20.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "ImageMorphologicalTestCase.h"

@interface ImageMorphologicalTestCase ()

@end

@implementation ImageMorphologicalTestCase

- (NSString*)title{
    return @"图像形态学";
}

- (NSArray*)controlItems{
    return @[
             
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
    
   
    Mat src;
    Test1Mat(src);
    cvtColor(src, src, CV_RGBA2RGB);
    
    
    
    CV_TEST_CODE_END
}
@end
