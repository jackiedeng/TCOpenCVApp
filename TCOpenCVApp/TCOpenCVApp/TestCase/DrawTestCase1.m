//
//  DrawTestCase1.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/25.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "DrawTestCase1.h"

@interface DrawTestCase1 ()

@end

@implementation DrawTestCase1


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSString*)title{
    return @"<play>绘制demo1";
}

- (NSArray*)controlItems{
    return @[
             [DrawMaskConfigItem drawMaskWithType:NONE_MASK
                                            title:@"原始图片"
                                              key:@"mask"
                                            image:[UIImage imageNamed:@"test3.png"]]
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
    
    Mat src;
    UIImageToMat(image, src);
    
    cv::cvtColor(src, src, CV_RGBA2RGB);
    

    cv::cvtColor(src, src, CV_RGB2GRAY);
    cv::equalizeHist(src,src);
    
    Mat result;
    cv::bilateralFilter(src, result, 10, 50,200);
    
//    result.convertTo(result, -1,1.5);
    
    check(result,@"1");
    check(HistMap(result),@"2");
    
    double min,max;
    cv::minMaxLoc(result, &min,&max);
    cout<<"max="<<max<<" min="<<min<<endl;
    
    check(result,@"mark");
    
    int colorLevel = 10;
    int colorNumber = colorLevel+1;
    float step = max/colorLevel;
    
    Vec3b * color = new Vec3b[colorNumber];
    Mat * matChanels = new Mat[colorNumber];
    
    for(int i = 0; i < colorNumber; i++){
        color[i] = Vec3b(rand()%255,rand()%255,rand()%255);
        matChanels[i] = Mat(result.size(),CV_8UC3,Scalar(0,0,0));
        cout<<"color"<<i<<"="<<color[i]<<endl;
    }
    
    for(int row = 0; row < result.rows; row++){
        for(int col = 0; col < result.cols; col++){
            int index = ceil((255-result.at<uchar>(row,col))/step);
            for(int chanel = 0; chanel <= index; chanel++){
                matChanels[chanel].at<Vec3b>(row,col) = color[chanel];
            }
        }
    }
    
    for(int i = 0; i < colorNumber; i++){
        
        check(matChanels[i],[@"beforeredraw" stringByAppendingFormat:@"%d",i]);
        matChanels[i] = [self redrawAndMakeContours:matChanels[i] color:color[i] stageImageSet:check];
        check(matChanels[i],[@"aflterredraw" stringByAppendingFormat:@"%d",i]);
    }

    Mat display = Mat::zeros(result.size(), CV_8UC3);
    
    for(int i = 0; i < colorNumber;i++){
        cv::addWeighted(display, 1, matChanels[i], 0.1, 0, display);
    }
    
    check(display,@"display");
//    cv::morphologyEx(newMat, newMat, cv::MORPH_CLOSE,cv::getStructuringElement(cv::MORPH_RECT, cv::Size(5,5)),cv::Point(-1,-1),1);
//
//    check(newMat,@"3");
//
    CV_TEST_CODE_END
}

- (Mat)redrawAndMakeContours:(Mat)mat
                       color:(Vec3b)color
 stageImageSet:(void(^)(Mat img,NSString *label))check{
    
    Mat labels,temp,stats;
    
    Mat grayMat;
    cvtColor(mat, grayMat, CV_RGB2GRAY);
    cv::threshold(grayMat, grayMat, 10, 255, cv::THRESH_BINARY);
    
    Mat all = Mat::ones(grayMat.size(),grayMat.type());
    
    cv::subtract(all,grayMat, grayMat);
    cv::abs(grayMat);
    
//    check(grayMat,@"gray");
    
    int total = cv::connectedComponentsWithStats(grayMat, labels,stats,temp);
    
    set<int> delSet;
    
//    cout<<"find:"<<total<<endl;
    
    for(int i = 0; i < total; i++){

        int  size = stats.at<int>(i,cv::CC_STAT_AREA);
        cout<<"size:"<<size<<" index:"<<i<<endl;
        
        if(size < 150){
            delSet.insert(i);
        }
    }
    
    cout<<"set:"<<delSet.size()<<endl;
    
//    Mat result = Mat::zeros(srcMat.size(),CV_8UC3);
//    MatIterator_<int> labelInterator = labels.begin<int>();
//    MatIterator_<Vec3b> resultInterator = result.begin<Vec3b>();
//
//    for(;labelInterator!=labels.end<int>() && resultInterator!=result.end<Vec3b>();
//        labelInterator++,resultInterator++){
//        (*resultInterator) = colors[(*labelInterator)];
//    }
    for(int row = 0; row < labels.rows; row++){
        for(int col = 0; col < labels.cols; col++){
            
            set<int>::iterator iter;
            iter = delSet.find(labels.at<int>(row,col));
            if(iter != delSet.end()){
                mat.at<Vec3b>(row,col) = color;
            }
        }
    }
    
    
    
    return mat;
}

@end
