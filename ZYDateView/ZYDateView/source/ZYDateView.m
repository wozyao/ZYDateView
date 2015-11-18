//
//  ZYDateView.m
//  PKA
//
//  Created by 郑遥 on 15/11/9.
//  Copyright © 2015年 JPY. All rights reserved.
//

#import "ZYDateView.h"

@interface ZYDateView ()

/** 年数组 */
@property (strong, nonatomic) NSArray *years;
/** 年月数组 */
@property (strong, nonatomic) NSArray *months;
/** 选中的年 */
@property (copy, nonatomic) NSString *yearStr;
/** 选中的月 */
@property (copy, nonatomic) NSString *monthStr;

@end

@implementation ZYDateView

+ (instancetype)dateViewWithYears:(NSArray *)years months:(NSArray *)months
{
    ZYDateView *dateView = [[[NSBundle mainBundle] loadNibNamed:@"ZYDateView" owner:nil options:nil] lastObject];
    dateView.years = years;
    dateView.months = months;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *dateStr = nil;
    NSString *year = nil;
    NSString *month = nil;
    if (years && months) {
        [df setDateFormat:@"yyyyMM"];
        dateStr = [df stringFromDate:[NSDate date]];
        year = [dateStr substringToIndex:4];
        month = [dateStr substringFromIndex:4];
    } else {
        if (years) {
            [df setDateFormat:@"yyyy"];
            dateStr = [df stringFromDate:[NSDate date]];
            year = dateStr;
        } else {
            [df setDateFormat:@"MM"];
            dateStr = [df stringFromDate:[NSDate date]];
            month = dateStr;
        }
    }
        
    [dateView setDefaultSelectYear:year month:month];
    return dateView;
}

- (void)awakeFromNib
{
    [self.leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];;
    self.pickerView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setDefaultSelectYear:(NSString *)year month:(NSString *)month
{
    if (year) { // 如果设置年
        NSUInteger yearIndex = [self.years indexOfObject:[year stringByAppendingString:@"年"]];
        [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
        [self pickerView:self.pickerView didSelectRow:yearIndex inComponent:0];
    }
    
    if (month) { // 如果设置月
        NSUInteger monthIndex = [self.months indexOfObject:[[NSString stringWithFormat:@"%d",[month intValue]] stringByAppendingString:@"月"]];
        if (self.years && self.months) {
            [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
            [self pickerView:self.pickerView didSelectRow:monthIndex inComponent:1];
        } else {
            [self.pickerView selectRow:monthIndex inComponent:0 animated:YES];
            [self pickerView:self.pickerView didSelectRow:monthIndex inComponent:0];
        }
    }
}

- (void)setDefaultYear:(NSString *)defaultYear
{
    // 当前年数组为空，则不能设置默认年
    if (!self.years) return;
    
    _defaultYear = defaultYear;
    if (defaultYear && ![defaultYear isEqualToString:@""]) {
        [self setDefaultSelectYear:defaultYear month:nil];
    }
}

- (void)setDefaultmonth:(NSString *)defaultmonth
{
    // 当前月数组为空，则不能设置默认月
    if (!self.months) return;
    
    _defaultmonth = defaultmonth;
    if (defaultmonth && ![defaultmonth isEqualToString:@""]) {
        [self setDefaultSelectYear:nil month:defaultmonth];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.years && self.months) {
        return 2;
    } else {
        return 1;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.years && self.months) {
        if (component == 0) {
            return self.years.count;
        } else {
            return self.months.count;
        }
    } else {
        if (self.years) {
            return self.years.count;
        } else {
            return self.months.count;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.years && self.months) {
        if (component == 0) {
            return self.years[row];
        } else {
            return self.months[row];
        }
    } else {
        if (self.years) {
            return self.years[row];
        } else {
            return self.months[row];
        }
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.years && self.months) {
        if (component == 0) {
            NSString *year = self.years[row];
            self.yearStr = [year substringToIndex:4];
        } else {
            NSString *month = self.months[row];
            self.monthStr = [month substringWithRange:NSMakeRange(0, month.length - 1)];
            self.monthStr = self.monthStr.length == 1 ? [@"0" stringByAppendingString:self.monthStr] : self.monthStr;
        }
    } else {
        if (self.years) {
            NSString *year = self.years[row];
            self.yearStr = [year substringToIndex:4];
        } else {
            NSString *month = self.months[row];
            self.monthStr = [month substringWithRange:NSMakeRange(0, month.length - 1)];
            self.monthStr = self.monthStr.length == 1 ? [@"0" stringByAppendingString:self.monthStr] : self.monthStr;
        }
    }
}

#pragma 工具栏左按钮被点击
- (IBAction)leftButtonClick:(UIButton *)sender {
    if ([self.dateViewDelegate respondsToSelector:@selector(dateView:LeftClick:)]) {
        [self.dateViewDelegate dateView:self LeftClick:sender];
    }
}

#pragma 工具栏右按钮被点击
- (IBAction)rightButtonClick:(UIButton *)sender {
    if ([self.dateViewDelegate respondsToSelector:@selector(dateView:rightClick:dateStr:)]) {
        if (self.years && self.months) {
           [self.dateViewDelegate dateView:self rightClick:sender dateStr:[self.yearStr stringByAppendingString:self.monthStr]];
        } else {
            if (self.years) {
                [self.dateViewDelegate dateView:self rightClick:sender dateStr:self.yearStr];
            } else {
                [self.dateViewDelegate dateView:self rightClick:sender dateStr:self.monthStr];
            }
        }
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end