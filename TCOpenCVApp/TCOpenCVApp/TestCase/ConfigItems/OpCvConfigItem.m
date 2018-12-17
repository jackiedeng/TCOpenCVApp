//
//  OpCvConfigItem.m
//  TCOpenCVApp
//
//  Created by jackiedeng on 2018/12/17.
//  Copyright © 2018 jackiedeng. All rights reserved.
//

#import "OpCvConfigItem.h"

@implementation OpCvConfigItem

- (instancetype)initWithTitle:(NSString*)title
                          key:(NSString*)key
                       Config:(void(^)(NSMutableDictionary*))dictBlock{
    self = [super init];
    if(self){
        
        self.title = title;
        self.key = key;
        self.config = [NSMutableDictionary dictionary];
        
        dictBlock(self.config);
    }
    return self;
}
    
- (UIView*)itemView{
    
    if(!self.view){
        self.view = [self createView:self.config];
    }
    return self.view;
}
    
- (UIView* _Nonnull)createView:(NSDictionary* _Nonnull)config{
    return [UIView new];
}
    
- (void)fillValueToDict:(NSMutableDictionary*)dict{
    
    if(self.value){
        [dict setObject:self.value
                 forKey:self.key];
    }
}
    
- (CGRect)rectWithHeight:(float)height{
    CGRect rect = CGRectZero;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    rect.size.height = height;
    return  rect;
}
    
- (void)setNeedUpdate{
    if(self.delegate && [self.delegate respondsToSelector:@selector(opCvConfigItemDidUpdateValue:)]){
        [self.delegate opCvConfigItemDidUpdateValue:self];
    }
}
@end
