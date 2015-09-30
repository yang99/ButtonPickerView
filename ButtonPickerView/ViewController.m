//
//  ViewController.m
//  ButtonPickerView
//
//  Created by yangyao on 15/9/24.
//  Copyright © 2015年 yangyao. All rights reserved.
//

#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define App_Frame_Height        [UIScreen mainScreen].bounds.size.height
#define App_Frame_Width         [UIScreen mainScreen].bounds.size.width


#import "ViewController.h"
#import "WJMyTimePickerView.h"
#import "FlexBile.h"
#import "FlexBileWJ.h"
@interface ViewController ()<WJMyTimePickerViewDelegate>
{
    UILabel            *titleLabel;
    UILabel            *speedTimeLabel;
    WJMyTimePickerView *dayPickerView;
    WJMyTimePickerView *hourPickerView;
    WJMyTimePickerView *mintePickerView;
}
@property (nonatomic,strong)UIView     *upVIew;
@property (nonatomic,strong)UIButton   *buttonUp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(0xF0, 0xF1, 0xF3, 1.0);
    [self initializeUserInterface];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //加载开场动画
    [dayPickerView openingAnimation];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC);
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, 0.10 * NSEC_PER_SEC);
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [hourPickerView openingAnimation];
    });
    dispatch_after(popTime1, dispatch_get_main_queue(), ^{
        [mintePickerView openingAnimation];
    });
    dispatch_after(popTime2, dispatch_get_main_queue(), ^{
        [hourPickerView hourFirstAnimation];
    });
}

- (void)initializeUserInterface{
    _upVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds)*0.11)];
    _upVIew.backgroundColor = RGBACOLOR(0xF8, 0xF8, 0xF8, 1.0);
    [self.view addSubview:_upVIew];
    
    UILabel *labelUp = [[UILabel alloc]initWithFrame:CGRectMake(0,self.upVIew.frame.size.height, CGRectGetMaxX(self.view.bounds), 1)];
    labelUp.backgroundColor = RGBACOLOR(0xAD, 0xAD, 0xAD, 1.0);
    labelUp.alpha = 0.6;
    [self.view addSubview:labelUp];
    
    UILabel *labelText = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 84,CGRectGetMaxY(self.view.bounds)*0.03 ,CGRectGetMaxX(self.view.bounds), 60)];
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.center = self.upVIew.center;
    labelText.text = @"请选择时间";
    labelText.font = [UIFont fontWithName:@"Helvetica-Bold" size:[FlexBile flexibleFloat:17]];
    labelText.textColor = [UIColor blackColor];
    [self.upVIew addSubview:labelText];
    
    
    speedTimeLabel = [[self class] applySpeedTimeLabel];
    int leftSeconds = (int)[self getLeftTime]*60;
    NSString *strDateEnd = [self dateSinceNow:leftSeconds];
    speedTimeLabel.text = [NSString stringWithFormat:@"选择时间到%@",strDateEnd];//@"将于4月10日 23 : 22停止提速";
    [self.view addSubview:speedTimeLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:speedTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:speedTimeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.70 constant:0]];
    
    //分别加载三个时间pickerview
    dayPickerView = [[WJMyTimePickerView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width/3.0, self.view.bounds.size.height *0.7-64)];
    dayPickerView.delegate = self;
    dayPickerView.center = CGPointMake(App_Frame_Width/6.0,App_Frame_Height*0.35+32);
    dayPickerView.toValue = 6;
    dayPickerView.fromValue = 0;
    dayPickerView.currentValue = 1;
    dayPickerView.styleColor = RGBACOLOR(0x20, 0xe5, 0x00, 1.0);
    [dayPickerView updatePickerStatus];
    dayPickerView.timeStyleString = @"天";
    [self.view addSubview:dayPickerView];
    
    hourPickerView = [[WJMyTimePickerView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width/3.0, self.view.bounds.size.height *0.7-64)];
    hourPickerView.delegate = self;
    hourPickerView.center = CGPointMake(App_Frame_Width/2.0,App_Frame_Height*0.35+32);
    hourPickerView.toValue = 23;
    hourPickerView.fromValue = 0;
    hourPickerView.currentValue = 3;
    [hourPickerView updatePickerStatus];
    hourPickerView.timeStyleString = @"小时";
    hourPickerView.styleColor = RGBACOLOR(0x16, 0x9b, 0xf8, 1.0);
    [self.view addSubview:hourPickerView];
    
    mintePickerView = [[WJMyTimePickerView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width/3.0, self.view.bounds.size.height *0.7-64)];
    mintePickerView.delegate = self;
    mintePickerView.center = CGPointMake(App_Frame_Width*5/6.0,App_Frame_Height*0.35+32);
    mintePickerView.toValue = 59;
    mintePickerView.fromValue = 0;
    mintePickerView.styleColor = RGBACOLOR(0x0d, 0xcd, 0xda, 1.0);
    mintePickerView.currentValue = 0;
    mintePickerView.timeStyleString = @"分钟";
    [mintePickerView updatePickerStatus];
    [self.view addSubview:mintePickerView];
    
    
    //确定按钮
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 130, 45)];
    sureButton.center = CGPointMake(CGRectGetMidX(self.view.bounds),CGRectGetMaxY(self.view.bounds)*0.80);
    sureButton.backgroundColor = RGBACOLOR(0xFF, 0x4D, 0x6E, 1.0);
    sureButton.layer.cornerRadius = 4.0;
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 130, 45)];
    cancelButton.center = CGPointMake(CGRectGetMidX(self.view.bounds),CGRectGetMaxY(self.view.bounds)*0.88);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

//timebutton的点击事件
- (void)timePickerViewDidTap:(WJMyTimePickerView *)pickerView
{
    if (pickerView == hourPickerView) {
        [dayPickerView updatePickerStatus];
        [mintePickerView updatePickerStatus];
    }else if(pickerView == dayPickerView){
        [hourPickerView updatePickerStatus];
        [mintePickerView updatePickerStatus];
    }else {
        [dayPickerView updatePickerStatus];
        [hourPickerView updatePickerStatus];
    }
}

//选中的时间到什么时候
- (void)timePickerViewDidSelected:(WJMyTimePickerView *)pickerView value:(NSInteger)value
{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    NSString *strDateEnd = [self dateSinceNow:(int)(dayPickerView.currentValue*3600*24+hourPickerView.currentValue*3600+mintePickerView.currentValue*60)];
    NSString *strTips = [NSString stringWithFormat:@"选择时间到%@",strDateEnd];
    speedTimeLabel.text = strTips;
}


- (IBAction)sureButtonPressed:(id)sender
{
    NSLog(@"确定");
}

//取消按钮点击
- (void)cancelButtonPressed:(UIButton *)sender{
    NSLog(@"取消");
}


+(UILabel *)applySpeedTimeLabel
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont fontWithName:@"Arial" size:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0x96/255.0 green:0x96/255.0 blue:0x96/255.0 alpha:1.0];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    return label;
}

+(UIButton *)applySpeedTimeBtn:(NSString *)title color:(UIColor *)color
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    [btn setBackgroundColor:color];
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 5.0;
    btn.exclusiveTouch = YES;
    btn.clipsToBounds = YES;
    return btn;
}

-(NSString *)dateSinceNow:(int)second
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM月dd日 HH时mm分"];// 数据的日期格式
    NSDate *dateNowTime = [NSDate date];
    NSDate *dateEnd = [NSDate dateWithTimeInterval:second sinceDate:dateNowTime];
    
    NSString *strDateEnd = [format stringFromDate:dateEnd];
    
    return strDateEnd;
}


//获取用户当次提速的剩余的分钟数目
-(NSInteger)getLeftTime
{
    return  1620;//1天3个小时
}

@end
