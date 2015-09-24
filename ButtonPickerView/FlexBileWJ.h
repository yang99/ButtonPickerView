//
//  FlexBileWJ.h
//  WJSpeed
//
//  Created by yangyao on 15/9/9.
//  Copyright (c) 2015年 iWangding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

# define DH_INLINE   static inline
# define SCREEN_SIZE [UIScreen mainScreen].bounds.size
# define ORIGIN_HEIGHT  568.f
# define ORIGIN_WIDTH   320.f

DH_INLINE CGFloat DHFlexibleVerticalMutiplier()
{
    return SCREEN_SIZE.height / ORIGIN_HEIGHT;
}

DH_INLINE CGFloat DHFlexibleHorizontalMutiplier()
{
    return SCREEN_SIZE.width / ORIGIN_WIDTH;
}

DH_INLINE CGPoint DHFlexibleCenter(CGPoint center)
{
    return CGPointMake(center.x * DHFlexibleHorizontalMutiplier(), center.y * DHFlexibleVerticalMutiplier());
}

#define ADAPT_IPHONE4

#ifdef ADAPT_IPHONE4
DH_INLINE CGSize DHFlexibleSize(CGSize size, BOOL adjustWidth)
{
    if (adjustWidth) {
        return CGSizeMake(size.width * DHFlexibleHorizontalMutiplier(), size.height*DHFlexibleHorizontalMutiplier());
    }
    
    return CGSizeMake(size.width * DHFlexibleHorizontalMutiplier(), size.height * DHFlexibleVerticalMutiplier());
    
}

DH_INLINE CGRect DHFlexibleFrame(CGRect frame, BOOL adjustWidth)
{
    CGPoint center = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2);
    
    center = DHFlexibleCenter(center);
    
    CGRect retFrame ;
    CGSize size = DHFlexibleSize(frame.size, adjustWidth);
    retFrame.origin.x = center.x - size.width/2;
    retFrame.origin.y = center.y - size.height/2;
    retFrame.size = size;
    return retFrame;
}

#else
DH_INLINE CGSize DHFlexibleSize(CGSize size)
{
    return CGSizeMake(size.width * DHFlexibleHorizontalMutiplier(), size.height * DHFlexibleVerticalMutiplier());
    
}

DH_INLINE CGRect DHFlexibleFrame(CGRect frame)
{
    CGFloat x = frame.origin.x * DHFlexibleHorizontalMutiplier();
    CGFloat y = frame.origin.y * DHFlexibleVerticalMutiplier();
    
    CGRect retFrame ;
    retFrame.origin.x = x;
    retFrame.origin.y = y;
    CGSize size = DHFlexibleSize(frame.size);
    retFrame.size = size;
    return retFrame;
}

#endif


