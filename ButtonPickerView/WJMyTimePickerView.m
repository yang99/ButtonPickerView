//
//  WJMyTimePickerView.m

//  Created by yangyao on 15/9/24.
//  Copyright © 2015年 yangyao. All rights reserved.

#import "WJMyTimePickerView.h"
#import "FlexBile.h"
#import "FlexBileWJ.h"

static const CGFloat distance = 50;

@interface WJMyTimePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIPickerView     *pickerView;
@property (nonatomic,strong) NSMutableArray   *pickerDataSource;
@property (nonatomic,strong) UILabel          *titleLabel;
@property (nonatomic,strong) UIButton         *actionButton;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,readwrite) BOOL isStoped;
@property (nonatomic,strong) UILabel*  timeStyleLabel;
@end

@implementation WJMyTimePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self addSubview:self.actionButton];
        [self addSubview:self.pickerView];
       
    }
    return self;
}

//设置button的颜色
- (void)setStyleColor:(UIColor *)styleColor
{
  self.actionButton.backgroundColor = styleColor;
}


//button的点击事件
-(IBAction)handleTap:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(timePickerViewDidTap:)]){
        [self.delegate timePickerViewDidTap:self];
    }
    [self.pickerView selectRow:self.currentValue inComponent:0 animated:YES];
    self.isStoped = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _backView.bounds = CGRectMake(0, 0,[FlexBile flexibleFloat:distance],[FlexBile flexibleFloat:200]);
        _backView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    } completion:^(BOOL finished) {
        [self.pickerView reloadAllComponents];
        self.pickerView.userInteractionEnabled = YES;
    }];
}

//第一次hour的动画
- (void)hourFirstAnimation{
    [self.pickerView selectRow:self.currentValue inComponent:0 animated:YES];
    self.isStoped = NO;

    [UIView animateWithDuration:0.3 animations:^{
        _backView.bounds = CGRectMake(0, 0,[FlexBile flexibleFloat:distance],[FlexBile flexibleFloat:200]);
        _backView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    } completion:^(BOOL finished) {
        [self.pickerView reloadAllComponents];
    }];
}

//开场动画
- (void)openingAnimation{
    self.actionButton.alpha = 1.0;
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animation];
    //初始化路径
    CGMutablePathRef aPath = CGPathCreateMutable();
    //动画起始点
    CGFloat x = self.backView.center.x;
    CGFloat y = self.backView.center.y;
    CGPathMoveToPoint(aPath, nil, x, y + 50);
    CGPathAddCurveToPoint(aPath, nil,
                          x, y + 10,//控制点
                          x, y - 15,//控制点
                          x, y);//控制点
    
    ani.path=aPath;
    ani.duration=0.15;
    //设置为渐出
    ani.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //自动旋转方向
    ani.rotationMode=@"auto";
    [self.actionButton.layer addAnimation:ani forKey:@"position"];
    self.pickerView.alpha = 1.0;
}

//收起动画
- (void)updatePickerStatus
{
    [self.pickerView selectRow:self.currentValue inComponent:0 animated:YES];
    self.pickerView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
       self.backView.bounds = CGRectMake(0, 0,[FlexBile flexibleFloat:distance],0);
        self.isStoped = YES;
         [self.pickerView reloadAllComponents];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -- pickerview协议方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerDataSource.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    WJTimeView *view = (WJTimeView *)[pickerView viewForRow:row forComponent:0];
    view.titleLabel.textColor = [UIColor whiteColor];
    view.titleLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:[FlexBile flexibleFloat:30]];
    self.currentValue = row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(timePickerViewDidSelected:value:)]) {
            [self.delegate timePickerViewDidSelected:self value:self.currentValue];
    }
    [self.pickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return [FlexBile flexibleFloat:50];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    WJTimeView *timeView = [[WJTimeView alloc]init];
    if(self.isStoped){
        timeView.titleLabel.textColor = [UIColor clearColor];
    }else {
        timeView.titleLabel.textColor = [UIColor blackColor];
    }
    timeView.titleLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:[FlexBile flexibleFloat:22]];
    timeView.frame = CGRectMake(0, 0, pickerView.frame.size.width, [FlexBile flexibleFloat:50]);
    timeView.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)((NSNumber *)self.pickerDataSource[row]).integerValue];
    if(self.currentValue == row){
        timeView.titleLabel.textColor = [UIColor whiteColor];
        timeView.titleLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:[FlexBile flexibleFloat:30]];
    }
    for(UIView *view in pickerView.subviews)
    {
        if(view.frame.size.height<=1.0)
        {
            view.backgroundColor = [UIColor clearColor];
        }
    }
    return timeView;
}


#pragma mark -- setter & getter方法
- (void)setTimeStyleString:(NSString *)timeStyleString
{
    if (!_timeStyleLabel) {
        _timeStyleLabel = [[UILabel alloc]init];
        [_timeStyleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _timeStyleLabel.text = timeStyleString;
        _timeStyleLabel.font = [UIFont fontWithName:@"Arial" size:[FlexBile flexibleFloat:11]];
        _timeStyleLabel.textColor = [UIColor blackColor];
        [self addSubview:_timeStyleLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeStyleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.actionButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:2]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_timeStyleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
}

- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc]init];
        _backView.bounds = CGRectMake(0, 0,[FlexBile flexibleFloat:distance],200 * DHFlexibleVerticalMutiplier());
        _backView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds  = YES;
        _backView.layer.cornerRadius = [FlexBile flexibleFloat:200]/8.0;
    }
    return _backView;
}
- (UIButton *)actionButton
{
    if (_actionButton == nil) {
        _actionButton = [[UIButton alloc]initWithFrame:DHFlexibleFrame(CGRectMake(0, 0, distance, distance), YES)];
        _actionButton.center = self.backView.center;
        _actionButton.alpha = 0.0;
        _actionButton.layer.cornerRadius = _actionButton.bounds.size.height/2.0;
        [_actionButton addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}
- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:self.bounds];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.alpha = 0.0;
        self.pickerView.frame = self.backView.frame;
    }
    return _pickerView;
}

- (NSMutableArray *)pickerDataSource
{
    if (_pickerDataSource == nil) {
        _pickerDataSource = [NSMutableArray array];
        for (NSInteger t = self.fromValue;t<= self.toValue;t++) {
            [_pickerDataSource addObject:[NSNumber numberWithInteger:t]];
        }
    }
    return _pickerDataSource;
}

- (void)setCurrentValue:(NSInteger)currentValue
{
    _currentValue = currentValue;
    [self.pickerView selectRow:self.currentValue inComponent:0 animated:YES];
}


@end





#pragma mark -- WJTimeView类

@implementation WJTimeView

-(id)init
{
    if(self = [super init])
    {
        self.titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    
    return self;
}


-(void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    self.titleLabel = nil;
}
@end



