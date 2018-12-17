//
//  OpCVBaseViewController.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "OpCVBaseViewController.h"
#import "SlideConfigItem.h"


@interface OpCVBaseViewController ()<OpCvConfigItemUpdateProtocol>
{
    NSMutableDictionary * _dicts;
    UIScrollView * _contentView;
    NSArray      * _controlItems;
    NSMutableArray  * _controlViews;
    
    UIImageView  * _targetImageView;
    UILabel      * _targetLabel;
}
@end

@implementation OpCVBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dicts = [NSMutableDictionary dictionary];
    _controlViews = [NSMutableArray array];
    _controlItems = [self controlItems];
    [self createControls];
    [self updateTargetImage];
}
    

- (NSString*)title{
    return @"defalut";
}
    
- (NSArray*)controlItems{
    return @[
             [SlideConfigItem slideConfigWithTitle:@"alpha"
                                               key:@"alpha"
                                             range:NSMakeRange(0, 1)
                                      defaultValue:0.5]
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
    
    _targetLabel = [UILabel new];
    _targetLabel.layer.anchorPoint = CGPointZero;
    [_contentView addSubview:_targetLabel];
    _targetLabel.layer.zPosition = 1000;
    _targetLabel.backgroundColor = [UIColor blackColor];
    _targetLabel.font = [UIFont systemFontOfSize:16];
    _targetLabel.textColor = [UIColor whiteColor];
    [_contentView setAlwaysBounceVertical:YES];
    
    _targetImageView = [UIImageView new];
    [_contentView addSubview:_targetImageView];
    
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
}

    
- (void)viewWillLayoutSubviews{
 
    [super viewWillLayoutSubviews];
    
    _contentView.frame = self.view.bounds;
}
    
#pragma mark -
#pragma mark main process
- (void)layoutWithAllItem{
    
    [_targetImageView sizeToFit];
    
    CGRect rect = _targetImageView.frame;
    
    rect.size.height *=  (self.view.frame.size.width/rect.size.width);
    
    rect.size.width = self.view.frame.size.width;

    _targetImageView.frame = rect;

    float height = rect.size.height + 5;
    
    for(UIView * view in _controlViews){
        view.center = CGPointMake(0, height);
        height += view.frame.size.height;
    }
    
    [_contentView setContentSize:CGSizeMake(self.view.frame.size.width, height)];
}
    
- (void)updateTargetImage{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
     for(OpCvConfigItem * item in _controlItems){
         [item fillValueToDict:dict];
     }
    double t = (double)getTickCount();
    
    cv::Mat resultMat = [self prcessImageWithConfigs:dict];
    
    t = ((double)getTickCount() - t)/getTickFrequency();
    
    _targetLabel.text = [NSString stringWithFormat:@"%@ cost:%.5f",[self title],t];
    [_targetLabel sizeToFit];
    
    if(!resultMat.empty()){
        
        UIImage * image = MatToUIImage(resultMat);
        
        [_targetImageView setImage:image];
    
        [self layoutWithAllItem];
    }else{
        NSLog(@"is empty!");
    }
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

- (cv::Mat)imageNamed:(NSString*_Nonnull)image{
    
    Mat src;
    UIImageToMat([UIImage imageNamed:image], src);
    return src;
}

- (instancetype)valueFromConfig:(NSString*)key
                         config:(NSDictionary*)config{
    
    return [config objectForKey:key];
}
@end
