//
//  GrabCutTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/23.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "GrabCutTestCase.h"

@interface GrabCutTestCase ()

@end

@implementation GrabCutTestCase

- (NSString*)title{
    return @"[cut]GrabCut图像分割";
}

- (NSArray*)controlItems{
    return @[
             [DrawMaskConfigItem drawMaskWithType:RECT_MASK
                                            title:@"mask"
                                              key:@"mask"
                                            image:[UIImage imageNamed:@"test2.png"]]
             ];
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
 
    NSDictionary * dict = [configs objectForKey:@"mask"];
    UIImage * image = [dict objectForKey:@"image"];
    CGRect rect = [[dict objectForKey:@"maskRect"] CGRectValue];
    
    if(rect.size.width < 1 || rect.size.height  < 1){
        rect.size.width = 10;
        rect.size.height = 10;
    }
    
    NSLog(@"draw value%@",NSStringFromCGRect(rect));
    
    Mat src;
    UIImageToMat(image, src);
    
    cvtColor(src, src, CV_RGBA2RGB);
    
    Mat resut;
    Mat bgModel,fgModel;
    
    cv::grabCut(src, resut, cv::Rect(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height),
                bgModel,fgModel, 1,cv::GC_INIT_WITH_RECT);
    
    
    Mat displayMat = Mat(src.size(),src.type(),Scalar(255,255,255));
    
//    cout<<resut<<endl;
    cv::compare(resut, cv::GC_PR_FGD, resut, cv::CMP_EQ);
    
    src.copyTo(displayMat, resut);
    
    check(displayMat,@"result");
    
    
    CV_TEST_CODE_END
}

@end
