//
//  ViewController.m
//  ZYDateView
//
//  Created by 郑遥 on 15/11/18.
//  Copyright © 2015年 郑遥. All rights reserved.
//

#import "ViewController.h"
#import "ZYDateView.h"
#import <objc/runtime.h>

@interface ViewController ()<ZYDateViewDegate>

@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) NSMutableArray *months;
@property (weak, nonatomic) ZYDateView *dateView;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@end

@implementation ViewController

- (NSMutableArray *)years
{
    if (!_years) {
        _years = [NSMutableArray array];
        for (int i=2011; i<2101; i++) {
            [_years addObject:[NSString stringWithFormat:@"%d年", i]];
        }
    }
    return _years;
}

- (NSMutableArray *)months
{
    if (!_months) {
        _months = [NSMutableArray array];
        for (int i=1; i<13; i++) {
            [_months addObject:[NSString stringWithFormat:@"%d月", i]];
        }
    }
    return _months;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getCurrentBatteryLevel];
}

#pragma mark --获取电池
- (int)getCurrentBatteryLevel
{
    
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0)
                {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar)
                    {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        //这种方式也可以
                        /*ptrdiff_t offset = ivar_getOffset(ivar);
                         unsigned char *stuffBytes = (unsigned char *)(__bridge void *)bview;
                         batteryLevel = * ((int *)(stuffBytes + offset));*/
                        NSLog(@"电池电量:%d",batteryLevel);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                            
                        } else {
                            return 0;
                        }
                    }
                    
                }
                
            }
        }
    }
    
    return 0;
}

- (IBAction)dateButtonClick:(UIButton *)sender {
    // 传入年月数组创建日期选择控件，传入其中一个数组亦可
    ZYDateView *dateView = [ZYDateView dateViewWithYears:self.years months:self.months];
    dateView.frame = CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200);
    dateView.dateViewDelegate = self;
//     默认选中当年当月，可以自定义
//    dateView.defaultYear = @"2014";
//    dateView.defaultmonth = @"8";
    [self.view addSubview:dateView];
    self.dateView = dateView;
}

#pragma mark -- ZYDateViewDelegate
- (void)dateView:(ZYDateView *)dateView LeftClick:(UIButton *)leftBtn
{
    [self removeDateView];
    NSLog(@"%s", __func__);
}

- (void)dateView:(ZYDateView *)dateView rightClick:(UIButton *)righttBtn dateStr:(NSString *)dateStr
{
    [self removeDateView];
    [self.dateButton setTitle:dateStr forState:UIControlStateNormal];
    NSLog(@"日期：%@", dateStr);
}

- (void)removeDateView
{
    [self.dateView removeFromSuperview];
    self.dateView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end