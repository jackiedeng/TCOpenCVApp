//
//  DrawTestCase1.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/25.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "DrawTestCase1.h"

@interface DrawTestCase1 ()
{
    UIImage * _resultImage;
}
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
                                            image:[UIImage imageNamed:@"test6.png"]],
             [SelectionConfigItem selectConfigWithTitle:@"level"
                                                    key:@"level"
                                             selections:@{@"10":@"10",@"20":@"20",@"30":@"30",@"40":@"40"}
                                           defaultValue:@"10"],
             [SlideConfigItem slideConfigWithTitle:@"light scale"
                                               key:@"scale"
                                             range:NSMakeRange(0,1)
                                      defaultValue:0.5]
             ];
}

- (UIImage*)imageToSave{
    return _resultImage;
}

- (ProcessType)processType{
    return multi_stage;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
    CV_TEST_CODE_BEGIN
//    check([self lineMaskStageImageSet:check],@"linemask");
    NSDictionary * dict = [configs objectForKey:@"mask"];
    UIImage * image = [dict objectForKey:@"image"];
    
    int level = [[configs objectForKey:@"level"] intValue];
    float scale = getFloatValue(@"scale", configs);
    
    Mat src;
    UIImageToMat(image, src);
    
    cv::cvtColor(src, src, CV_RGBA2RGB);

    cv::cvtColor(src, src, CV_RGB2GRAY);
    cv::equalizeHist(src,src);
    
    Mat result;
    cv::bilateralFilter(src, result, 10, 50,200);
    
    check(result,@"1");
    check(HistMap(result),@"2");
    
    double min,max;
    cv::minMaxLoc(result, &min,&max);
//    cout<<"max="<<max<<" min="<<min<<endl;
    
    check(result,@"mark");
    
    int colorLevel = level;
    int colorNumber = colorLevel+1;
    float step = max/colorLevel;
    
    Vec3b * color = new Vec3b[colorNumber];
    Mat * matChanels = new Mat[colorNumber];
    Mat * lineTextures = new Mat[colorNumber];
    Mat * lineOriginTextures = new Mat[colorNumber];
    
    double maxHight = 0.9;
    double depthStep = scale/colorNumber;
    
    for(int i = 0; i < colorNumber; i++){
        color[i] = Vec3b(rand()%255,rand()%255,rand()%255);
        matChanels[i] = Mat(result.size(),CV_8UC3,Scalar(0,0,0));
        lineTextures[i] = [self lineMatWithSize:result.size()
                                          depth:maxHight-i*depthStep];
        
//        check(lineTextures[i],[@"texture1" stringByAppendingFormat:@"%d",i]);
        
        lineOriginTextures[i] = lineTextures[i];
        
        if(i <=5){
        
            lineTextures[i] = [self drawLineToTexture:lineTextures[i]
                                    maskStageImageSet:check];

//            check(lineTextures[i],[@"texture result::" stringByAppendingFormat:@"%d",i]);
        }
    }
    
    for(int row = 0; row < result.rows; row++){
        for(int col = 0; col < result.cols; col++){
            int index = ceil((max-result.at<uchar>(row,col))/step);
            index = index >= colorNumber?(colorNumber-1):index;
            
            for(int chanel = 0; chanel <= index; chanel++){
                matChanels[chanel].at<Vec3b>(row,col) = color[chanel];
            }
        }
    }
    
    for(int i = 0; i < colorNumber; i++){
        
        matChanels[i] = [self redrawAndMakeContours:matChanels[i]
                                              color:color[i]
                                      stageImageSet:check];
        
        cvtColor(matChanels[i], matChanels[i], CV_RGB2GRAY);
//
//        check(matChanels[i],[@"mask" stringByAppendingFormat:@"_level%d",i]);
    }
    
    Mat resultMat = [self renderResultForOrgin:result
                                     maskArray:matChanels
                                  textureArray:lineOriginTextures
                                    depthCount:colorNumber];
    
    check(resultMat,@"result");
    
    check([self renderResultForOrgin2:result
                            maskArray:matChanels
                         textureArray:lineOriginTextures
                           depthCount:colorNumber],@"result2");
    
    _resultImage =  MatToUIImage(resultMat);

    delete[] color;
    delete[] matChanels;
    delete[] lineTextures;
    
    CV_TEST_CODE_END
}

- (Mat)renderResultForOrgin2:(Mat)orginMat
                  maskArray:(Mat*)maskArray
               textureArray:(Mat*)textureArray
                 depthCount:(int)depthCount{
    
    Mat display = Mat(orginMat.size(),CV_8UC1,Scalar(255));
    
    for(int depth =0;depth < depthCount;depth++){
        
        Mat mask = maskArray[depth];
        Mat texture = textureArray[depth];
        
        texture.copyTo(display,mask);
    }
    
    return display;
}

- (Mat)renderResultForOrgin:(Mat)orginMat
                  maskArray:(Mat*)maskArray
              textureArray:(Mat*)textureArray
                depthCount:(int)depthCount{
    
    Mat display = Mat(orginMat.size(), CV_32FC1,Scalar(1.0));
    
    for(int depth =0;depth < depthCount;depth++){
        
        Mat mask = maskArray[depth];
        Mat texture = textureArray[depth];
        Mat textureDisplayMat = Mat(texture.size(),texture.type(),Scalar(255));
        
        texture.copyTo(textureDisplayMat,mask);
        
        Mat texture32FMat;
        textureDisplayMat.convertTo(texture32FMat, CV_32FC1,1/255.0);
        
        cv::multiply(texture32FMat, display, display);
    }
    
    Mat display8UMat;
    display.convertTo(display8UMat, CV_8UC1,255);
    
    return display8UMat;
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
//        cout<<"size:"<<size<<" index:"<<i<<endl;
        
        if(size < 150){
            delSet.insert(i);
        }
    }
    
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

- (Mat)lineMatWithSize:(cv::Size)size
                 depth:(float)depth{
    
    cv::RNG rag(cv::getTickCount());
    
    Mat lineMat = Mat(size,CV_32FC1);
    Mat lineMat2 = Mat(size,CV_32FC1);
    
    rag.fill(lineMat, cv::RNG::UNIFORM, Scalar(depth), Scalar(1));
    
    int count = 0;
    
    if(depth < 0.6){
        count = 7-(depth/0.1);
    }
    
    for(int i = 0; i  < count; i++){
        rag.fill(lineMat2, cv::RNG::UNIFORM, Scalar(depth), Scalar(1));
        cv::multiply(lineMat, lineMat2, lineMat);
    }

    Mat r;
    lineMat.convertTo(r, CV_8UC1,255);
    
    return r;
}

- (Mat)drawLineToTexture:(Mat)textureMat
       maskStageImageSet:(void(^)(Mat img,NSString *label))check{

//    textureMat = textureMat(cv::Rect(5,5,5,5));
//    Mat maskTextureMat = [self lineMatWithSize:cv::Size(5,5) depth:0.5];
    //orgin mask
    Mat maskTextureMat = [self lineMatWithSize:textureMat.size() depth:0.5];
    
    cv::threshold(maskTextureMat, maskTextureMat, 0.3*255, 255, cv::THRESH_BINARY_INV);
    
    Mat mask = Mat::zeros(maskTextureMat.size(),CV_8UC1);
    
    for(int i =0 ; i < mask.size().height; i+=4){
        cv::line(mask, cv::Point(0,i), cv::Point(mask.size().width,i), Scalar(255),1);
    }
    
    Mat lineTextureMask = Mat(maskTextureMat.size(),CV_8UC1,Scalar(255));
    maskTextureMat.copyTo(lineTextureMask, mask);
    
//    cv::threshold(lineTextureMask, lineTextureMask, 0.4*255, 255, cv::THRESH_BINARY_INV);
    
//    check(lineTextureMask,@"mask");
//    cout<<"0"<<textureMat<<endl;
    Mat lineTexture32FMat;
    lineTextureMask.convertTo(lineTexture32FMat, CV_32FC1,1/255.0);
//    cout<<"-1"<<lineTexture32FMat<<endl;
    Mat textureMat32Mat;
    textureMat.convertTo(textureMat32Mat, CV_32FC1,1/255.0);
//    cout<<"1"<<textureMat32Mat<<endl;
    cv::subtract(1,textureMat32Mat, textureMat32Mat);
//    cout<<"2"<<textureMat32Mat<<endl;
    cv::multiply(lineTexture32FMat, textureMat32Mat, textureMat32Mat);
//    cout<<"3"<<textureMat32Mat<<endl;
    cv::subtract(1,textureMat32Mat, textureMat32Mat);
//    cout<<"4"<<textureMat32Mat<<endl;
    Mat final;
    textureMat32Mat.convertTo(final, CV_8UC1,255);
//    cout<<"5"<<final<<endl;

    Mat border;
    cv::copyMakeBorder(final, border, final.size().height/2, final.size().height/2, final.size().width/2, final.size().width/2, cv::BORDER_WRAP);

    int randAngle = rand()%90;

    cv::warpAffine(border,border, cv::getRotationMatrix2D(cv::Point(border.size().width/2,border.size().height/2),
                                                       randAngle, 1.0),border.size());
    final = border(cv::Rect(
                   (border.size().width-final.size().width)/2,
                   (border.size().height-final.size().height)/2,
                    final.size().width,
                    final.size().height
                   ));
    
    return final;
}

@end
