//
//  ZSCSafeKeyBoard
//
//  Created by jrjc on 17/2/16.
//  Copyright © 2017年 jrjc. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define DEVICE [[UIDevice currentDevice].systemVersion integerValue] < 7.0
#define IS_IOS7 (BOOL)([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0 ? YES : NO)

#define KWidthScale ([UIScreen mainScreen].bounds.size.width / 320.0)
#define KHeightScale ([UIScreen mainScreen].bounds.size.height / 568.0)

#define KeyBoardHeight (216)
#define KeyBoardHeightScale ((KeyBoardHeight) * (KHeightScale))

#define KeyBoardAccessHeight (40)
#define KeyBoardAccessHeightScale ((KeyBoardAccessHeight) * (KHeightScale))

#define KeyBoardTitleColor [UIColor blackColor]

#define KeyBoardNumberFont [UIFont systemFontOfSize:22]
#define KeyBoardFont [UIFont systemFontOfSize:20]

/* 数字键盘*/
#define HNumberCount (3)
#define VNumberCount (4)

#define NumberPadding (0.6)
#define NumberPaddingHScale (NumberPadding *  (KHeightScale))
#define NumberPaddingVScale (NumberPadding *  (KWidthScale))

#define NumberButtonWidth (106.3)
#define NumberButtonWidthScale (NumberButtonWidth *  (KWidthScale))

#define NumberButtonHeight (53)
#define NumberButtonHeightScale (NumberButtonHeight *  (KHeightScale))

/* 英文字符键盘 第一行*/
// 距离父试图头部间距
#define PaddingTop (12)
#define PaddingTopScale  ((12) * (KHeightScale))

// 距离左边距
#define MarddingLeft (2)
#define MarddingLeftSclae ((2) * (KWidthScale))

/**
距离右边距
*/
#define PaddingRight (4)
#define PaddingRightScale ((4) * (KWidthScale))

/**
 * 距离下边距
 */
#define PaddingButtom (14)
#define PaddingButtomScale ((14) * (KHeightScale))

/**
 *  按钮宽
 */
#define CharBtnWidth (28)
#define CharBtnWidthScale ((28) * (KWidthScale))

/**
 *  按钮高
 */
#define CharBtnHeight (40)
#define CharBtnHeightScale ((40) * (KHeightScale))

/* 英文字符键盘 第二行*/

/**
 *  第二行距离左边距
 */
#define MarddingSecondLeft (19)
#define MarddingSecondLeftSclae ((19) * (KWidthScale))


/**
 *  大小写切换
 */
#define BigToSmallWidth (36)
#define BigToSmallWidthScale ((BigToSmallWidth) * (KWidthScale))

#define PaddingThirdRight (12)
#define PaddingThirdRightScale ((PaddingThirdRight) * (KWidthScale))

/**
 *  数字切换
 */
#define NumberChnageWidth (80)
#define NumberChnageWidthScale ((NumberChnageWidth) * (KWidthScale))

/**
 *  空格切换
 */
#define SpeaceButtonWidth (148)
#define SpeaceButtonWidthScale ((SpeaceButtonWidth) * (KWidthScale))

/**
 *  换行
 */
#define ReturnButtonWidth (80)
#define ReturnButtonWidthScale ((ReturnButtonWidth) * (KWidthScale))

/**
 *  键盘OrderTages基数
 */
#define CharacterKey 20
#define EnglishKey (30)


#endif /* Config_h */
