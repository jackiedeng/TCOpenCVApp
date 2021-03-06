//
//  OpCVBaseViewController.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "OpCVBaseViewController.h"
#import "SlideConfigItem.h"
#import "OpResultImagePreview.h"

@interface OpCVBaseViewController ()<OpCvConfigItemUpdateProtocol>
{
    NSMutableDictionary * _dicts;
    UIScrollView * _contentView;
    NSArray      * _controlItems;
    NSMutableArray  * _controlViews;
    //保存上一次结果的items
    NSArray      * _resultImageItems;
    UILabel      * _mainLabel;
}
@end

@implementation OpCVBaseViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    _dicts = [NSMutableDictionary dictionary];
    _controlViews = [NSMutableArray array];
    _controlItems = [self controlItems];
    [self createControls];
    [self updateTargetImage];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onScrollNotification:)
                                                 name:@"scrollControlNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGetImageFromAlbumNotification:)
                                                 name:@"getImageFromAlbumNotification"
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"save"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onSaveImage)];
}
    

- (NSString*)title{
    return @"hello world";
}
    
- (NSArray*)controlItems{
    return @[
//             [SlideConfigItem slideConfigWithTitle:@"alpha"
//                                               key:@"alpha"
//                                             range:NSMakeRange(0, 1)
//                                      defaultValue:0.5]
             ];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark create controls
- (UILabel*)titleLabel:(NSString*)title
                height:(float)height{
    
    UILabel * label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:17];
    [label sizeToFit];
//    label.frame = CGRectInset(label.frame, 0, -5);
    label.layer.anchorPoint = CGPointZero;
    label.center = CGPointMake(0, height);
    
    return  label;
}

- (float)subViewWithItem:(OpCvConfigItem*)item
             contentView:(UIView*)contentView
                    height:(float)height{
    
    UIView * subView = [item itemView];
    
    if(subView){
        
        UILabel * label = [self titleLabel:item.title
                                    height:height];
        [_contentView addSubview:label];
        
        height += label.frame.size.height;
        
        subView.layer.anchorPoint = CGPointZero;
        subView.center = CGPointMake(0, height);
        [_contentView addSubview:subView];
        
        item.displayLabel = label;
        
        height += subView.frame.size.height;
        
        [_controlViews addObject:label];
        [_controlViews addObject:subView];
    }
    
    return height;
}
    
- (void)createControls{
    
    _contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    _mainLabel = [UILabel new];
    _mainLabel.layer.anchorPoint = CGPointZero;
    [self.view addSubview:_mainLabel];
    _mainLabel.layer.zPosition = 1000;
    _mainLabel.backgroundColor = [UIColor blackColor];
    _mainLabel.font = [UIFont systemFontOfSize:16];
    _mainLabel.textColor = [UIColor whiteColor];
    [_contentView setAlwaysBounceVertical:YES];
    
    float height = 0;
    
    for(OpCvConfigItem * item in _controlItems){
        
        item.delegate = self;
        
        height = [self subViewWithItem:item
                           contentView:_contentView
                                height:height];
    }
    
    [_contentView setContentSize:CGSizeMake(self.view.frame.size.width, height)];
    
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_contentView];
    [self.view bringSubviewToFront:_mainLabel];
}

    
- (void)viewWillLayoutSubviews{
 
    [super viewWillLayoutSubviews];
    
    _contentView.frame = self.view.bounds;
    
    _mainLabel.center = CGPointMake(self.view.frame.size.width/2, 0);
}
#pragma mark -
#pragma mark scroll notification
- (void)onScrollNotification:(NSNotification*)notification{
     [_contentView setScrollEnabled:![notification.object boolValue]];
}

- (void)onGetImageFromAlbumNotification:(NSNotification*)notification{
    
    UIImagePickerController * picker = [UIImagePickerController new];
    
//    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self.navigationController presentViewController:picker
                                            animated:YES
                                          completion:^{
                                              
                                          }];
}
#pragma mark -
#pragma mark image get
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(image.size.width > 1000 || image.size.height > 1000){
        
        float scalew = 1000/image.size.width;
        float scaleh = 1000/image.size.height;
        
        float scale = scaleh > scalew?scalew:scaleh;
        
        CGRect rect = CGRectMake(0, 0, image.size.width*scale, image.size.height*scalew);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onGetAlbumImageBackNotification"
                                                        object:image
                                                      userInfo:nil];
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                               }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                               }];
}
    
#pragma mark -
#pragma mark main process
- (void)cleanLastResult{
    if(_resultImageItems){
        for(OpResultImageItem * item in _resultImageItems){
            [item clean];
        }
    }
}

- (void)layoutWithAllItemWithResultItems:(NSArray*)resultItems{
    
    [self cleanLastResult];
    
    float height =  20;
    //layout new
    for(OpResultImageItem * item in resultItems){
       height = [item createDisplayViewToContentView:_contentView
                                    withLayoutHeight:height];
    }
    //layout controls
    height += 10;
    for(UIView * view in _controlViews){
        view.center = CGPointMake((self.view.frame.size.width-view.frame.size.width)/2, height);
        height += view.frame.size.height;
    }
    
    [_contentView setContentSize:CGSizeMake(self.view.frame.size.width, height)];

    //保存当前
    _resultImageItems = resultItems;
}

#pragma mark -
#pragma mark main process

- (void)getMultiStageProcess:(NSDictionary*)config
             resultItemArray:(NSMutableArray*)resultItemArray{
    
    __block int stageCount = 1;
    
    __block double t = (double)getTickCount();
    
    [self processImageWithConfigs:config
                    stageImageSet:^(Mat img,NSString * _Nonnull label) {
                        
                        double cost = ((double)getTickCount() - t)/getTickFrequency();
                        t = (double)getTickCount();
                        
                        if(!img.empty()){
                            
                            label = [NSString stringWithFormat:@"%d.%@ 耗时:%lf",stageCount++,label,cost];
                        
                            [resultItemArray addObject:[OpResultImageItem
                                                        itemWithImage:MatToUIImage(img)
                                                        label:label]];
                        }
                        
                    }
                  uiimageStageSet:^(UIImage * _Nonnull img, NSString * _Nonnull label) {
                      
                      double cost = ((double)getTickCount() - t)/getTickFrequency();
                      t = (double)getTickCount();
                      
                        if(img){
                            
                            label = [NSString stringWithFormat:@"%d.%@ 耗时:%lf",stageCount++,label,cost];
                            
                            [resultItemArray addObject:[OpResultImageItem
                                                        itemWithImage:img
                                                        label:label]];
                        }
                        
                    }];
    
}

- (void)getSingleResultProcess:(NSDictionary*)config
               resultItemArray:(NSMutableArray*)resultItemArray{
    
    cv::Mat resultMat = [self prcessImageWithConfigs:config];
    
    if(!resultMat.empty()){
        
        [resultItemArray addObject:[OpResultImageItem
                                    itemWithImage:MatToUIImage(resultMat)
                                    label:@"result"]];
    }
}

- (void)updateTargetImage{
    
    NSMutableDictionary * config = [NSMutableDictionary dictionary];
    
    NSMutableArray * resultImageItem = [NSMutableArray array];
    
     for(OpCvConfigItem * item in _controlItems){
         [item fillValueToDict:config];
     }
    double t = (double)getTickCount();
    
    //根据处理流程选择
    switch([self processType]){
        case single_image:
        {
            [self getSingleResultProcess:config
                         resultItemArray:resultImageItem];
        }
            break;
        case multi_stage:
        {
            [self getMultiStageProcess:config
                       resultItemArray:resultImageItem];
        }
            break;
        default:
            break;
    }

    t = ((double)getTickCount() - t)/getTickFrequency();
    
    _mainLabel.text = [NSString stringWithFormat:@"%@ 耗时:%.5f",[self title],t];
    [_mainLabel sizeToFit];
    _mainLabel.layer.anchorPoint = CGPointMake(0.5, 0);
    
    //fresh all
    [self layoutWithAllItemWithResultItems:resultImageItem];
}
#pragma mark -
#pragma mark deletate
- (void)opCvConfigItemDidUpdateValue:(OpCvConfigItem* _Nonnull)item{
    [self updateTargetImage];
}
#pragma mark -
#pragma mark overwrite to load
- (cv::Mat)prcessImageWithConfigs:(NSDictionary*)configs{
    
    UIImage * image = [UIImage imageNamed:@"test.png"];
    
    Mat src;
    
    UIImageToMat(image, src);
    
    return src;
}


- (ProcessType)processType{
    return single_image;
}

- (void)processImageWithConfigs:(NSDictionary*)configs
                  stageImageSet:(void(^)(Mat img,NSString *label))check
                uiimageStageSet:(void(^)(UIImage* img,NSString *label))uiCheck{
}

- (cv::Mat)imageNamed:(NSString*_Nonnull)image{
    
    Mat src;
    UIImageToMat([UIImage imageNamed:image], src);
    return src;
}

- (NSString*)valueFromConfig:(NSString*)key
                         config:(NSDictionary*)config{
    
    return [config objectForKey:key];
}

- (float)floatValueFromConfig:(NSString*)key config:(NSDictionary*)config{
    
    id obj = [self valueFromConfig:key config:config];
    
    if([obj isKindOfClass:[NSNumber class]]){
        return [obj floatValue];
    }
    
    return 0;
}

- (void)onSaveImage{
    
    if([self imageToSave]){
     
        UIImageWriteToSavedPhotosAlbum([self imageToSave], nil, nil, nil);
        
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        
        
        NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"demo.png"]];  // 保存文件的名称
        
        BOOL result =[UIImagePNGRepresentation([self imageToSave]) writeToFile:filePath
                                                                    atomically:YES]; // 保存成功会返回YES
        if (result == YES) {
            NSLog(@"保存成功:%@",filePath);
        }
        
    }
    
}

- (UIImage*)imageToSave{
    return nil;
}

@end
