//
//  ZYDateView.h
//  PKA
//
//  Created by 郑遥 on 15/11/9.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYDateView;
@class WHBKProvAddress;
@class WHBKCityAddress;

@protocol ZYDateViewDegate <NSObject>

/** 左按钮被点击 */
- (void)dateView:(ZYDateView *)dateView LeftClick:(UIButton *)leftBtn;

/** 右按钮被点击 */
@optional
- (void)dateView:(ZYDateView *)dateView rightClick:(UIButton *)rightBtn dateStr:(NSString *)dateStr;

/** 右按钮被点击 */
- (void)dateView:(ZYDateView *)dateView rightClick:(UIButton *)rightBtn pa:(WHBKProvAddress *)pa ca:(WHBKCityAddress *)ca;

@end

@interface ZYDateView : UIView

/** 年月选择工具栏 */
@property (weak, nonatomic) IBOutlet UIView *toolBar;
/** 左按钮 */
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
/** 右按钮 */
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
/** 年月选择控件 */
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
/** 设置默认年 */
@property (strong, nonatomic) NSString *defaultYear;
/** 设置默认月 */
@property (strong, nonatomic) NSString *defaultMonth;
/** 设置默认月 */
@property (strong, nonatomic) NSString *defaultDay;

/** ZYDateView的代理 */
@property (weak, nonatomic) id<ZYDateViewDegate> dateViewDelegate;

/** 类方法生成年月日选择控件 */
+ (instancetype)dateViewWithYears:(NSArray *)years months:(NSArray *)months days:(NSArray *)days;
/** 类方法生成内容选择控件 */
+ (instancetype)dateViewWithContentArray1:(NSArray *)array1 array2:(NSArray *)array2;
/** 类方法生成省市选择控件 */
+ (instancetype)dateViewWithPros:(NSArray *)pros cities:(NSArray *)cities;
/** 弹出选择框 */
- (void)show;
/** 移除选择框 */
- (void)dismis;

@end