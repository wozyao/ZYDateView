//
//  ZYDateView.m
//  PKA
//
//  Created by 郑遥 on 15/11/9.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import "ZYDateView.h"
#import "WHBKProvAddress.h"
#import "WHBKCityAddress.h"
#define Height 200

@interface ZYDateView ()

/** 年数组 */
@property (strong, nonatomic) NSArray *years;
/** 月数组 */
@property (strong, nonatomic) NSArray *months;
/** 日数组 */
@property (strong, nonatomic) NSArray *days;
/** 选中的年 */
@property (copy, nonatomic) NSString *yearStr;
/** 选中的月 */
@property (copy, nonatomic) NSString *monthStr;
/** 选中的日 */
@property (copy, nonatomic) NSString *dayStr;
/** 内容数组1 */
@property (strong, nonatomic) NSArray *contentArray1;
/** 内容数组2 */
@property (strong, nonatomic) NSArray *contentArray2;
/** 选中的内容1 */
@property (copy, nonatomic) NSString *selectContent1;
/** 选中的内容2 */
@property (copy, nonatomic) NSString *selectContent2;
/** 省数组 */
@property (strong, nonatomic) NSArray *pros;
/** 市数组 */
@property (strong, nonatomic) NSArray *cities;
/** 当前选中城市数组 */
@property (strong, nonatomic) NSMutableArray *selectedCities;
/** 选中的省模型 */
@property (strong, nonatomic) WHBKProvAddress *pa;
/** 选中的市模型 */
@property (strong, nonatomic) WHBKCityAddress *ca;
/** 蒙版 */
@property (nonatomic, strong) UIView *becloudView;

@end

@implementation ZYDateView

- (NSMutableArray *)selectedCities
{
    if (!_selectedCities) {
        _selectedCities = [NSMutableArray array];
    }
    return _selectedCities;
}

+ (instancetype)dateViewWithYears:(NSArray *)years months:(NSArray *)months days:(NSArray *)days
{
    ZYDateView *dateView = [[[NSBundle mainBundle] loadNibNamed:@"ZYDateView" owner:nil options:nil] lastObject];
    dateView.years = years;
    dateView.months = months;
    dateView.days = days;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *dateStr = nil;
    NSString *year = nil;
    NSString *month = nil;
    NSString *day = nil;
    if (years && months && days) {
        [df setDateFormat:@"yyyyMMdd"];
        dateStr = [df stringFromDate:[NSDate date]];
        year = [dateStr substringToIndex:4];
        month = [dateStr substringWithRange:NSMakeRange(4, 2)];
        day = [dateStr substringFromIndex:6];
    } else if (years && months) {
        [df setDateFormat:@"yyyyMM"];
        dateStr = [df stringFromDate:[NSDate date]];
        year = [dateStr substringToIndex:4];
        month = [dateStr substringFromIndex:4];
    } else if (months && days) {
        [df setDateFormat:@"MMdd"];
        dateStr = [df stringFromDate:[NSDate date]];
        month = [dateStr substringWithRange:NSMakeRange(4, 2)];
        day = [dateStr substringFromIndex:6];
    }  else {
        if (years) {
            [df setDateFormat:@"yyyy"];
            dateStr = [df stringFromDate:[NSDate date]];
            year = dateStr;
        } else if (months) {
            [df setDateFormat:@"MM"];
            dateStr = [df stringFromDate:[NSDate date]];
            month = dateStr;
        } else {
            [df setDateFormat:@"dd"];
            dateStr = [df stringFromDate:[NSDate date]];
            day = dateStr;
        }
    }
        
    [dateView setDefaultSelectYear:year month:month day:day];
    return dateView;
}

+ (instancetype)dateViewWithContentArray1:(NSArray *)array1 array2:(NSArray *)array2
{
    ZYDateView *dateView = [[[NSBundle mainBundle] loadNibNamed:@"ZYDateView" owner:nil options:nil] lastObject];
    dateView.contentArray1 = array1;
    dateView.contentArray2 = array2;
    [dateView.pickerView selectRow:0 inComponent:0 animated:YES];
    [dateView pickerView:dateView.pickerView didSelectRow:0 inComponent:0];
    [dateView pickerView:dateView.pickerView didSelectRow:0 inComponent:1];
    
    return dateView;
}

+ (instancetype)dateViewWithPros:(NSArray *)pros cities:(NSArray *)cities
{
    ZYDateView *dateView = [[[NSBundle mainBundle] loadNibNamed:@"ZYDateView" owner:nil options:nil] lastObject];
    dateView.pros = pros;
    dateView.cities = cities;
    [dateView.pickerView selectRow:0 inComponent:0 animated:YES];
    [dateView pickerView:dateView.pickerView didSelectRow:0 inComponent:0];
    
    return dateView;
}

- (void)awakeFromNib
{
    self.pickerView.backgroundColor = [Helper hexStringToColor:@"#f5f9fb"];
    self.toolBar.backgroundColor = [UIColor whiteColor];
    [self.leftBtn setTitleColor:[Helper hexStringToColor:@"#b8b8b8"] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[Helper hexStringToColor:@"#f76c4d"] forState:UIControlStateNormal];

}

- (void)setDefaultSelectYear:(NSString *)year month:(NSString *)month day:(NSString *)day
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
    
    if (day) { // 如果设置日
        NSUInteger dayIndex = [self.days indexOfObject:[[NSString stringWithFormat:@"%d",[day intValue]] stringByAppendingString:@"日"]];
        if (self.years && self.months) {
            [self.pickerView selectRow:dayIndex inComponent:2 animated:YES];
            [self pickerView:self.pickerView didSelectRow:dayIndex inComponent:2];
        } else {
            [self.pickerView selectRow:dayIndex inComponent:0 animated:YES];
            [self pickerView:self.pickerView didSelectRow:dayIndex inComponent:0];
        }
    }
}

- (void)setDefaultYear:(NSString *)defaultYear
{
    // 当前年数组为空，则不能设置默认年
    if (!self.years) return;
    
    _defaultYear = defaultYear;
    if (defaultYear && ![defaultYear isEqualToString:@""]) {
        [self setDefaultSelectYear:defaultYear month:nil day:nil];
    }
}

- (void)setDefaultmonth:(NSString *)defaultMonth
{
    // 当前月数组为空，则不能设置默认月
    if (!self.months) return;
    
    _defaultMonth = defaultMonth;
    if (defaultMonth && ![defaultMonth isEqualToString:@""]) {
        [self setDefaultSelectYear:nil month:defaultMonth day:nil];
    }
}

- (void)setDefaultDay:(NSString *)defaultDay
{
    // 当前月数组为空，则不能设置默认月
    if (!self.days) return;
    
    _defaultDay = defaultDay;
    if (defaultDay && ![defaultDay isEqualToString:@""]) {
        [self setDefaultSelectYear:nil month:nil day:defaultDay];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([ZYTool sharedZYTool].proAndCity) {
        return 2;
    } else {
        if (self.years && self.months && self.days) {
            return 3;
        } else if (self.years && self.months) {
            return 2;
        } else if (self.months && self.days) {
            return 2;
        } else if (self.contentArray1 && self.contentArray2){
            return 2;
        } else {
            return 1;
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if ([ZYTool sharedZYTool].proAndCity) {
        if (component == 0) {
            return self.pros.count;
        } else {
            return self.selectedCities.count;
        }
    } else {
        if (self.years && self.months && self.days) {
            if (component == 0) {
                return self.years.count;
            } else if (component == 1) {
                return self.months.count;
            } else {
                return self.days.count;
            }
        } else if (self.years && self.months) {
            if (component == 0) {
                return self.years.count;
            } else {
                return self.months.count;
            }
        } else if (self.months && self.days) {
            if (component == 0) {
                return self.months.count;
            } else {
                return self.days.count;
            }
        } else if (self.contentArray1 && self.contentArray2) {
            if (component == 0) {
                return self.contentArray1.count;
            } else {
                return self.contentArray2.count;
            }
        } else {
            if (self.years) {
                return self.years.count;
            } else if (self.months) {
                return self.months.count;
            } else if (self.days) {
                return self.days.count;
            } else if (self.contentArray1) {
                return self.contentArray1.count;
            } else {
                return self.contentArray2.count;
            }
        }
    }

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if ([ZYTool sharedZYTool].proAndCity) {
        if (component == 0) {
            return [self.pros[row] provName];
        } else {
            return [self.selectedCities[row] cityName];
        }
    } else {
        if (self.years && self.months && self.days) {
            if (component == 0) {
                return self.years[row];
            } else if (component == 1) {
                return self.months[row];
            } else {
                return self.days[row];
            }
        } else if (self.years && self.months) {
            if (component == 0) {
                return self.years[row];
            } else {
                return self.months[row];
            }
        } else if (self.months && self.days) {
            if (component == 0) {
                return self.months[row];
            } else {
                return self.days[row];
            }
        } else if (self.contentArray1 && self.contentArray2) {
            if (component == 0) {
                return self.contentArray1[row];
            } else {
                return self.contentArray2[row];
            }
        } else {
            if (self.years) {
                return self.years[row];
            } else if (self.months) {
                return self.months[row];
            } else if (self.days) {
                return self.days[row];
            } else if (self.contentArray1) {
                return self.contentArray1[row];
            } else {
                return self.contentArray2[row];
            }
        }
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([ZYTool sharedZYTool].proAndCity) {
        if (component == 0) {
            [self.selectedCities removeAllObjects];
            [self.cities enumerateObjectsUsingBlock:^(WHBKCityAddress *ca, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[self.pros[row] provId] isEqualToString:ca.provId]) {
                    [self.selectedCities addObject:ca];
                }
            }];
            self.pa = self.pros[row];
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [self pickerView:pickerView didSelectRow:0 inComponent:1];
        } else {
            if (self.selectedCities.count > 0) {
                self.ca = self.selectedCities[row];
            }        
        }
    } else {
        if (self.years && self.months && self.days) {
            if (component == 0) {
                NSString *year = self.years[row];
                self.yearStr = [year substringToIndex:4];
            } else if (component == 1) {
                NSString *month = self.months[row];
                self.monthStr = [month substringWithRange:NSMakeRange(0, month.length - 1)];
                self.monthStr = self.monthStr.length == 1 ? [@"0" stringByAppendingString:self.monthStr] : self.monthStr;
            } else {
                NSString *day = self.days[row];
                self.dayStr = [day substringWithRange:NSMakeRange(0, day.length - 1)];
                self.dayStr = self.dayStr.length == 1 ? [@"0" stringByAppendingString:self.dayStr] : self.dayStr;
            }
        } else if (self.years && self.months) {
            if (component == 0) {
                NSString *year = self.years[row];
                self.yearStr = [year substringToIndex:4];
            } else {
                NSString *month = self.months[row];
                self.monthStr = [month substringWithRange:NSMakeRange(0, month.length - 1)];
                self.monthStr = self.monthStr.length == 1 ? [@"0" stringByAppendingString:self.monthStr] : self.monthStr;
            }
        } else if (self.months && self.days) {
            if (component == 0) {
                NSString *month = self.months[row];
                self.monthStr = [month substringWithRange:NSMakeRange(0, month.length - 1)];
                self.monthStr = self.monthStr.length == 1 ? [@"0" stringByAppendingString:self.monthStr] : self.monthStr;
            } else {
                NSString *day = self.days[row];
                self.dayStr = [day substringWithRange:NSMakeRange(0, day.length - 1)];
                self.dayStr = self.dayStr.length == 1 ? [@"0" stringByAppendingString:self.dayStr] : self.dayStr;
            }
        } else if (self.contentArray1 && self.contentArray2) {
            if (component == 0) {
                self.selectContent1 = self.contentArray1[row];
            } else {
                self.selectContent2 = self.contentArray2[row];
            }
        } else {
            if (self.years) {
                NSString *year = self.years[row];
                self.yearStr = [year substringToIndex:4];
            } else if (self.months) {
                NSString *month = self.months[row];
                self.monthStr = [month substringWithRange:NSMakeRange(0, month.length - 1)];
                self.monthStr = self.monthStr.length == 1 ? [@"0" stringByAppendingString:self.monthStr] : self.monthStr;
            } else if (self.days) {
                NSString *day = self.days[row];
                self.dayStr = [day substringWithRange:NSMakeRange(0, day.length - 1)];
                self.dayStr = self.dayStr.length == 1 ? [@"0" stringByAppendingString:self.dayStr] : self.dayStr;
            } else if (self.contentArray1) {
                self.selectContent1 = self.contentArray1[row];
            } else {
                self.selectContent2 = self.contentArray2[row];
            }
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
    if ([ZYTool sharedZYTool].proAndCity) {
        if ([self.dateViewDelegate respondsToSelector:@selector(dateView:rightClick:pa:ca:)]) {
            [self.dateViewDelegate dateView:self rightClick:sender pa:self.pa ca:self.ca];
        }
    } else {
        if ([self.dateViewDelegate respondsToSelector:@selector(dateView:rightClick:dateStr:)]) {
            if (self.years && self.months && self.days) {
                [self.dateViewDelegate dateView:self rightClick:sender dateStr:[[self.yearStr stringByAppendingString:self.monthStr] stringByAppendingString:self.dayStr]];
            } else if (self.years && self.months) {
                [self.dateViewDelegate dateView:self rightClick:sender dateStr:[self.yearStr stringByAppendingString:self.monthStr]];
            } else if (self.months && self.days) {
                [self.dateViewDelegate dateView:self rightClick:sender dateStr:[self.monthStr stringByAppendingString:self.dayStr]];
            }  else if (self.contentArray1 && self.contentArray2) {
                [self.dateViewDelegate dateView:self rightClick:sender dateStr:[NSString stringWithFormat:@"%@ —— %@", self.selectContent1, self.selectContent2]];
            } else {
                if (self.years) {
                    [self.dateViewDelegate dateView:self rightClick:sender dateStr:self.yearStr];
                } else if (self.months) {
                    [self.dateViewDelegate dateView:self rightClick:sender dateStr:self.monthStr];
                } else if (self.days) {
                    [self.dateViewDelegate dateView:self rightClick:sender dateStr:self.dayStr];
                } else if (self.selectContent1) {
                    [self.dateViewDelegate dateView:self rightClick:sender dateStr:self.selectContent1];
                } else {
                    [self.dateViewDelegate dateView:self rightClick:sender dateStr:self.selectContent2];
                }
            }
            
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *becloudView = [[UIView alloc] init];
    becloudView.frame = window.bounds;
    becloudView.backgroundColor = [UIColor lightGrayColor];
    becloudView.alpha = 0.2;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMyself)];
    [becloudView addGestureRecognizer:tapGR];
    self.becloudView = becloudView;
    [window addSubview:becloudView];
    self.frame = CGRectMake(0, window.height - Height, window.width, Height);
    [window addSubview:self];
}

- (void)dismis
{
    [self removeFromSuperview];
    [self.becloudView removeFromSuperview];
}

- (void)removeMyself
{
    if ([self.dateViewDelegate respondsToSelector:@selector(dateView:LeftClick:)]) {
        [self.dateViewDelegate dateView:self LeftClick:nil];
    }
}

@end