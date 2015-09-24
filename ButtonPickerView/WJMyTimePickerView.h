//
//  WJMyTimePickerView.h
//  WJSpeed
//
//  Created by yangyao on 15/9/11.
//  Copyright (c) 2015年 iWangding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJMyTimePickerView;

@protocol WJMyTimePickerViewDelegate <NSObject>

- (void)timePickerViewDidSelected:(WJMyTimePickerView *)pickerView value:(NSInteger)value;

- (void)timePickerViewDidTap:(WJMyTimePickerView *)pickerView;

@end

@interface WJMyTimePickerView : UIView

@property (nonatomic,weak) id<WJMyTimePickerViewDelegate> delegate;

@property (nonatomic,readwrite) NSInteger fromValue;
@property (nonatomic,readwrite) NSInteger toValue;
@property (nonatomic,readwrite) NSInteger currentValue;
@property (nonatomic,strong) NSString     *timeStyleString;
@property (nonatomic,strong)    UIColor *styleColor;
- (void)updatePickerStatus;
- (void)hourFirstAnimation;
- (void)openingAnimation;
@end

@interface WJTimeView : UIView

@property (nonatomic,strong)  UILabel  *titleLabel;

@end