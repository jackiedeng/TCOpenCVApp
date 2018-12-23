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

- (NSString* _Nonnull)displayText{
    if([self.value isKindOfClass:[NSString class]]){
        return [NSString stringWithFormat:@"%@ : %@",self.title,self.value];
    }else{
        return self.title;
    }
}
    
- (void)fillValueToDict:(NSMutableDictionary*)dict{
    
    self.value = [self getCurrentValue];
    
    if(self.value){
        
        [dict setObject:self.value
                 forKey:self.key];
        
        if(self.displayLabel){
            
            self.displayLabel.text = [self displayText];
            
            [self.displayLabel sizeToFit];
        }
    }
}
    
- (CGRect)rectWithHeight:(float)height{
    CGRect rect = CGRectZero;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    rect.size.height = height;
    rect = CGRectInset(rect, 20, 0);
    return  rect;
}
    
- (void)setNeedUpdate{
    if(self.delegate && [self.delegate respondsToSelector:@selector(opCvConfigItemDidUpdateValue:)]){
        [self.delegate opCvConfigItemDidUpdateValue:self];
    }
}

- (id)getCurrentValue{
    return nil;
}
@end
