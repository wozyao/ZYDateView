//
//  ZYDateView.h
//  PKA
//
//  Created by 郑遥 on 15/11/9.
//  Copyright © 2015年 JPY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYDateView;

@protocol ZYDateViewDegate <NSObject>

/** 左按钮被点击 */
- (void)dateView:(ZYDateView *)dateView LeftClick:(UIButton *)leftBtn;
/** 右按钮被点击 */
- (void)dateView:(ZYDateView *)dateView rightClick:(UIButton *)righttBtn dateStr:(NSString *)dateStr;

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
@property (strong, nonatomic) NSString *defaultmonth;


/** ZYDateView的代理 */
@property (weak, nonatomic) id<ZYDateViewDegate> dateViewDelegate;

/** 类方法生成年月选择控件 */
+ (instancetype)dateViewWithYears:(NSArray *)years months:(NSArray *)months;

@end