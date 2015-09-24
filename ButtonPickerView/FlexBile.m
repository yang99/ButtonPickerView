//
//  FlexBile.m
//  YYX
//
//  Created by rimi on 15-6-11.
//  Copyright (c) 2015年 yangyao. All rights reserved.
//

#import "FlexBile.h"
#define IPONE5_SCREEN CGSizeMake(320,568)
#define IPONE4S_SCREEN CGSizeMake(320,336)
@implementation FlexBile
+(CGFloat)ratio
{

    return [[UIScreen mainScreen] bounds].size.width/IPONE5_SCREEN.width;
}
+(CGFloat)flexibleFloat:(CGFloat)aFloat
{
    return aFloat * [self ratio];

}


+(CGFloat)ratio4S
{
    return [[UIScreen mainScreen] bounds].size.height/IPONE5_SCREEN.height;
}
+(CGFloat)flexibleFloat4S:(CGFloat)aFloat
{
    return aFloat * [self ratio4S];
    
}


+(CGRect)frameIPONE5Frame:(CGRect)ipone5Frame
{
    if ([[UIScreen mainScreen] bounds].size.width == 320.000000 && [[UIScreen mainScreen] bounds].size.height == 480.00000) {
        CGFloat x = [self flexibleFloat:ipone5Frame.origin.x];
        CGFloat y = [self flexibleFloat4S:ipone5Frame.origin.y];
        CGFloat width = [self flexibleFloat:ipone5Frame.size.width];
        CGFloat height = [self flexibleFloat4S:ipone5Frame.size.height];
        return CGRectMake(x, y, width, height);
    }else{
    CGFloat x = [self flexibleFloat:ipone5Frame.origin.x];
    CGFloat y = [self flexibleFloat:ipone5Frame.origin.y];
    CGFloat width = [self flexibleFloat:ipone5Frame.size.width];
    CGFloat height = [self flexibleFloat:ipone5Frame.size.height];
        return CGRectMake(x, y, width, height);
    }
}
@end
