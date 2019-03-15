//
//  JFinputPwdView.h
//  CustomerProject
//
//  Created by misterLiu on 2019/3/14.
//  Copyright © 2019 GK_W. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFinputPwdView : UIView

// 输入框
//@property(nonatomic,strong)QMUITextField* mInput;
@property(nonatomic,strong)UITextField * mInput;

@property (nonatomic,strong) NSString * holderStr;//占位的字符串

@property (nonatomic,strong) NSString * encryStr; //加密之后的字符串




@end

NS_ASSUME_NONNULL_END
