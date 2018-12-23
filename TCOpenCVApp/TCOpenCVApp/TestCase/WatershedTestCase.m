//
//  WatershedTestCase.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/22.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "WatershedTestCase.h"

@interface WatershedTestCase ()

@end

@implementation WatershedTestCase


- (NSString*)title{
    return @"[cut]分水岭图像分割";
}

- (NSArray*)controlItems{
    return @[
             [DrawMaskConfigItem drawMask:@"draw"
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
    
    NSDictionary * setting = [configs objectForKey:@"mask"];
    UIImage * maskImage = [setting objectForKey:@"mask"];
    UIImage * orginImage = [setting objectForKey:@"image"];
    
    Mat maskOrgin;
    UIImageToMat(maskImage, maskOrgin);
    
    cvtColor(maskOrgin, maskOrgin, CV_RGBA2GRAY);
    
//    check(maskOrgin,@"origin");
    
    vector<vector< cv::Point> > contoursVec;
    
    vector<Vec4i>hierarchy;
    
    cv::findContours(maskOrgin, contoursVec, hierarchy, RETR_CCOMP, CHAIN_APPROX_SIMPLE);

    Mat mask = Mat::zeros(maskOrgin.size(), CV_32SC1);

    Mat displayMat = Mat::zeros(maskOrgin.size(),CV_8UC1);
    cout<<"size:"<<hierarchy.size()<<endl;
    
    for (int i = 0; i < hierarchy.size(); i++)
    {
        cv::drawContours(mask, contoursVec, i, Scalar::all(i + 1), -1, 8, hierarchy);
        cv::drawContours(displayMat, contoursVec, i, Scalar::all((i*40)%255),-1,8,hierarchy);
    }
    
    check(displayMat,@"mask");
    
    Mat testImage,meashiftMat;
    UIImageToMat(orginImage, testImage);
//
    cvtColor(testImage, testImage, CV_RGBA2RGB);
  
    cv::pyrMeanShiftFiltering(testImage, meashiftMat, 20, 40);
//
    cv::watershed(meashiftMat, mask);
//
    Mat cutResult = Mat::zeros(mask.size(), CV_8UC3);

    MatIterator_<int> matInterator = mask.begin<int>();
    MatIterator_<Vec3b> cutResultInterator = cutResult.begin<Vec3b>();

    int colorCount = 5;
    Vec3b color[] = {
        {255,0,0},
        {0,255,0},
            {0,0,255},
            {255,255,0},
            {0,255,255}
    };

    int mark[100];
    memset(mark, 0, 100);

    for(;matInterator!=mask.end<int>() && cutResultInterator != cutResult.end<Vec3b>()
        ;matInterator++,cutResultInterator++){

        int index = (*matInterator);

        if( index == -1){

            (*cutResultInterator)[0] = 255;
            (*cutResultInterator)[1] = 255;
            (*cutResultInterator)[2] = 255;
        }
        else if(index > 0){
//            cout<<"["<<*matInterator<<"]";
//            (*matInterator) = 40;

            (*cutResultInterator) = color[index%colorCount];

            if(mark[index] == 0){
                mark[index]=1;
                cout<<"find:"<<index<<endl;
            }

        }
    }
    
    cv::addWeighted(cutResult, 0.5, testImage, 0.5, 0, cutResult);

    check(cutResult,@"result");
    
    CV_TEST_CODE_END
}

@end
