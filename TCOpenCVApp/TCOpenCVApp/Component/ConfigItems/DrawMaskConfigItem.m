//
//  DrawMaskConfigItem.m
//  TCOpenCVApp
//
//  Created by Chao Deng on 2018/12/22.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "DrawMaskConfigItem.h"
#define kImage @"kImage"
#import "DrawMaskView.h"
#import "DrawRectMaskView.h"


@implementation DrawMaskConfigItem
{
    BOOL _isDrawAble;
    DrawMaskType _type;
}

+ (instancetype)drawMask:(NSString* _Nonnull)title
                     key:(NSString* _Nonnull) key
                   image:(UIImage* _Nonnull)image{
    return [DrawMaskConfigItem drawMaskWithType:DRAW_MASK
                                          title:title
                                            key:key
                                          image:image];
}

+ (instancetype)drawMaskWithType:(DrawMaskType)type
                           title:(NSString* _Nonnull)title
                             key:(NSString* _Nonnull) key
                           image:(UIImage* _Nonnull)image{
    
    DrawMaskConfigItem * newItem = [[DrawMaskConfigItem alloc] initWithTitle:title
                                                                         key:key
                                                                        type:type
                                                                      Config:^(NSMutableDictionary * _Nonnull dict) {
                                                                          
                                                                          [dict setObject:image
                                                                                   forKey:kImage];
                                                                          
                                                                      }];
    
    return newItem;
}

- (id)initWithTitle:(NSString *)title
                key:(NSString *)key
               type:(DrawMaskType)type
             Config:(void (^)(NSMutableDictionary * _Nonnull))dictBlock{
    
    self = [super initWithTitle:title
                            key:key
                         Config:dictBlock];
    
    if(self){
    
        _type = type;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onGetAlbumImageNofitication:)
                                                     name:@"onGetAlbumImageBackNotification"
                                                   object: nil];
    }
    
    return self;
    
}

- (void)updateButtonTitle:(UIButton*)button{
    
    [button setTitle:_isDrawAble?@"点击完成":@"点击开始绘制蒙版"
            forState:   UIControlStateNormal];
}

- (UIView* _Nonnull)createView:(NSDictionary* _Nonnull)config{
    
    _isDrawAble = NO;
    //get segementArray from selections
    UIView * toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width+30)];
    
    DrawMaskView * dmv = nil;
    
    if(_type == DRAW_MASK){
        dmv = [[DrawMaskView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    }else if(_type == RECT_MASK){
        dmv = [[DrawRectMaskView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    }else{
        dmv = [[DrawMaskView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    }
    
    dmv.image = [config objectForKey:kImage];
    dmv.tag = 999;
    [toolView addSubview:dmv];
    
    
    [dmv setUserInteractionEnabled:_isDrawAble];
    
    if(_type !=NONE_MASK){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [button addTarget:self
                   action:@selector(action:)
         forControlEvents: UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(5,[UIScreen mainScreen].bounds.size.width+5, 150, 20);
        
        [toolView addSubview:button];
        
        [self updateButtonTitle:button];
         
        UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [button2 addTarget:self
                   action:@selector(cleanAction:)
         forControlEvents: UIControlEventTouchUpInside];
        
        button2.frame = CGRectMake(155,[UIScreen mainScreen].bounds.size.width+5, 100, 20);
        
        [button2 setTitle:@"clean"
                forState:UIControlStateNormal];
        
        [toolView addSubview:button2];
    
     }
         
         
    UIButton* button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button3 addTarget:self
                action:@selector(selectFromAlbum:)
      forControlEvents: UIControlEventTouchUpInside];
    
    button3.frame = CGRectMake(260,[UIScreen mainScreen].bounds.size.width+5, 100, 20);
    
    [button3 setTitle:@"album"
             forState:UIControlStateNormal];
    
    [toolView addSubview:button3];
    
    
    return toolView;
}

- (void)selectFromAlbum:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getImageFromAlbumNotification"
                                                        object:nil];
}


- (void)cleanAction:(id)sender{
    
    [(DrawMaskView*)[self.view viewWithTag:999] clean];
    
    [self setNeedUpdate];
}

- (void)action:(id)sender{
    
    _isDrawAble = !_isDrawAble;
    
    [[self.view viewWithTag:999] setUserInteractionEnabled:_isDrawAble];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollControlNotification"
                                                        object:[NSNumber numberWithBool:_isDrawAble]];
    
    [self updateButtonTitle:sender];
    
    if(!_isDrawAble){
        [self setNeedUpdate];
    }
}

- (id)getCurrentValue{
    
    DrawMaskView * maskview = (DrawMaskView*)[self.view viewWithTag:999];
    return [maskview maskValue];
}

- (void)onGetAlbumImageNofitication:(NSNotification*)no{
    
    DrawMaskView * maskview = (DrawMaskView*)[self.view viewWithTag:999];
    
    [maskview setImage:no.object];
    
    [maskview setNeedsDisplay];
    
    [self setNeedUpdate];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
