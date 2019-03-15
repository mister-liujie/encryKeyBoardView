//
//  Base64KeyBoardView.m
//  ZSCSafeKeyBoard
//
//  Created by jrjc on 17/2/16.
//  Copyright © 2017年 jrjc. All rights reserved.
//

#import "Base64KeyBoardView.h"
#import "UIControl+Category.h"
#import "HZCommanFunc.h"
#import "Masonry.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ButtonBgColor   RGB(144, 156, 168)

// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@interface Base64KeyBoardView ()

/**字符按钮*/
@property(nonatomic,strong)UIButton * CharacterBtn;

/** 数字键盘数据源*/
@property (nonatomic, strong) NSMutableArray * numberArray;
/** 符号键盘数据源*/
@property (nonatomic, strong) NSMutableArray * CalculaSignArry;
/** 字符加盘数据源*/
@property (nonatomic, strong) NSMutableArray * BigCharacterArry;  //大写字符数组
@property (nonatomic, strong) NSMutableArray * SmallCharacterArry;//小写字符数组

@end

@implementation Base64KeyBoardView


/**
 *  数字键盘
 */
-(NSMutableArray *)numberArray {
    if (!_numberArray){
        
        _numberArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"-",@"/",@":",@";",@"(",@")",@"$",@"&",@"@",@"#+=",@"\"",@".",@",",@"?",@"!",@"'",@"~",@"",@"abc",@"space",@"return"].mutableCopy;
    }
    return _numberArray;
}

-(NSMutableArray *)CalculaSignArry {
    if (!_CalculaSignArry) {
        _CalculaSignArry = @[@"[",@"]",@"{",@"}",@"*",@"#",@"%",@"+",@"-",@"=",@"_",@"\\",@"|",@"/",@"<",@">",@"€",@"￡",@"￥",@"123",@"^",@"?",@"~",@"!",@"’",@":",@"·",@"",@"abc",@"space",@"return"].mutableCopy;
    }
    return _CalculaSignArry;
}

-(NSMutableArray *)BigCharacterArry {
    if (!_BigCharacterArry) {
        _BigCharacterArry = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"<-",@"123",@"space",@"return"].mutableCopy;
    }
    return _BigCharacterArry;
}

-(NSMutableArray *)SmallCharacterArry {
    if (!_SmallCharacterArry) {
         _SmallCharacterArry = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"<-",@"123",@"space",@"return"].mutableCopy;  //↑
    }
    return _SmallCharacterArry;
}



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 清除颜色
        self.backgroundColor = [UIColor clearColor];
        self.OtherConnectStr = self.ConnectStr = @"";
        self.OtherJumpStr = self.JumpStr = @"";
        self.DeleteDone = NO;
        self.SecondSelectState = self.selectState = YES;  //使用这个参数 判断是选择的大小写
        /**默认为选项一*/
//        NSLog(@"---self.TextSelectPostion---");
         self.TextSelectPostion = TextFiledFirst;
//       self.TextSelectPostion = TextFiledSecond;
    }
    return self;
}


+ (instancetype)KeyBoardMenu {
    return [[self alloc] init];
}

#pragma mark - 英文键盘被点击
-(void)CharacterDidSelect:(UIButton *)sender {
    
    NSArray * countArray = [self.JumpStr componentsSeparatedByString:@","];
    if(countArray.count== 18 && sender.tag != 27 && sender.tag != 28 && sender.tag != 30 && sender.tag != 19){
//        [QMUITips showWithText:@"最大密码长度18位"];
        return;
    }
    
    //切换大小写键盘
    if(sender.tag == 19){
        self.SecondSelectState = self.selectState = !self.selectState;

        [self changeTheValueOfTheKeyBoard];
        //切换大小写键盘
        if (self.delegate && [self.delegate respondsToSelector:@selector(getKeyBoardViewValueFromButton:DidSelectButTag:)]) {
            [self.delegate  getKeyBoardViewValueFromButton:self.JumpStr DidSelectButTag:[sender.OrderTags integerValue]];
            __weak typeof(self) weakSelf = self;
            if (self.BlockChnagkeyBoard) {
                weakSelf.BlockChnagkeyBoard(weakSelf.KeyBoardConsoleView);
            }
        }
        //删除
    }else if (sender.tag == 27){
        
        switch (self.TextSelectPostion) {
            case TextFiledFirst:
            case TextFiledSecond:
            {
                if (![self.ConnectStr isEqualToString:@""]){
                    NSArray * tempArry = [[self.ConnectStr substringWithRange:NSMakeRange(0, self.ConnectStr.length - 1)] componentsSeparatedByString:@","];
                    /**截取非最后一位*/
                    NSString * NotInlastObjc = @"";
                    for (NSInteger index = 0; index < tempArry.count - 1; index++) {
                        NotInlastObjc = [[NotInlastObjc stringByAppendingString:tempArry[index]] stringByAppendingString:@","];
                    }
                    /**截取完赋值给connectStr*/
                    self.ConnectStr = NotInlastObjc;
                    self.JumpStr = self.ConnectStr;
                    
                    NSString * resShowStr = IsStrEmpty(self.JumpStr)  ? @"~" : [self.JumpStr substringWithRange:NSMakeRange(0, self.JumpStr.length - 1)] ;
                    /**赋值删除完标志*/
                    self.DeleteDone = IsStrEmpty(self.JumpStr);
                    [self runDelegateFromButtonTag:resShowStr andButtonTage:sender.tag];
                }
            }
                break;
                
            default:
                break;
        }
    }else if (sender.tag == 28){
        NSLog(@"改变键盘类型");
        //切换键盘类型 字符键盘和 符号键盘互相切换
        self.SecondSelectState = self.selectState = YES;
        if(self.TextSelectPostion==TextFiledFirst){
            self.TextSelectPostion=TextFiledSecond;
             [self.CharacterBtn setImage:nil forState:UIControlStateNormal];
        }else if(self.TextSelectPostion==TextFiledSecond){
            self.TextSelectPostion=TextFiledFirst;
             [self.CharacterBtn setImage:[UIImage imageNamed:@"ShiftSmall"] forState:UIControlStateNormal];
        }
        
        [self changeTheValueOfTheKeyBoard];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(getKeyBoardViewValueFromButton:DidSelectButTag:)]) {
            [self.delegate  getKeyBoardViewValueFromButton:self.JumpStr DidSelectButTag:[sender.OrderTags integerValue]];
            __weak typeof(self) weakSelf = self;
            if (self.BlockChnagkeyBoard) {
                weakSelf.BlockChnagkeyBoard(weakSelf.KeyBoardConsoleView);
            }
        }
    }
    else if (sender.tag == 29){
        NSLog(@"---sender--29--空格--");
        switch (self.TextSelectPostion) {
            case TextFiledFirst:
            {
            }
                break;
            case TextFiledSecond:
            {
            }
                break;
            default:
                break;
        }
    }else if(sender.tag == 30){
         NSLog(@"---sender--30--完--");
        //隐藏按钮
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardAnmitionDown)]){
            [self.delegate  keyBoardAnmitionDown];
        }
    }else{
        // 正常点击  正常点击  正常点击  正常点击
        switch (self.TextSelectPostion) {
            case TextFiledFirst:
            {
                if (self.selectState){
                    NSString * baseStr = __BASE64([self.SmallCharacterArry objectAtIndex:sender.tag]);
//                    NSLog(@"--TextFiledFirst--1--%@-----",[self.SmallCharacterArry objectAtIndex:sender.tag]);
                    self.JumpStr = [[self.ConnectStr stringByAppendingString:baseStr] stringByAppendingString:@","];
                    self.ConnectStr = self.JumpStr;
                    self.JumpStr = [self.JumpStr substringWithRange:NSMakeRange(0, self.JumpStr.length - 1)];
                    [self runDelegateFromButtonTag:self.JumpStr andButtonTage:[sender.OrderTags integerValue]];
                }else{
                    
                    NSString * baseStr = __BASE64([self.BigCharacterArry objectAtIndex:sender.tag]);
//                  NSLog(@"---TextFiledFirst--2----%@---",[self.BigCharacterArry objectAtIndex:sender.tag]);
                    self.JumpStr = [[self.ConnectStr stringByAppendingString:baseStr] stringByAppendingString:@","];
                    self.ConnectStr = self.JumpStr;
                    self.JumpStr = [self.JumpStr substringWithRange:NSMakeRange(0, self.JumpStr.length - 1)];
                    [self runDelegateFromButtonTag:self.JumpStr andButtonTage:[sender.OrderTags integerValue]];
                 }
            }
                break;
            case TextFiledSecond:{
                if (self.SecondSelectState){
                    NSString * baseStr = __BASE64([self.numberArray objectAtIndex:sender.tag]);
//                      NSLog(@"--TextFiledSecond---1---%@----",[self.numberArray objectAtIndex:sender.tag]);
                    
                    self.JumpStr = [[self.ConnectStr stringByAppendingString:baseStr] stringByAppendingString:@","];
                    self.ConnectStr = self.JumpStr;
                    self.JumpStr = [self.JumpStr substringWithRange:NSMakeRange(0, self.JumpStr.length - 1)];
                     [self runDelegateFromButtonTag:self.JumpStr andButtonTage:[sender.OrderTags integerValue]];

                }else{
                
                    NSString * baseStr = __BASE64([self.CalculaSignArry objectAtIndex:sender.tag]);
                    NSLog(@"---TextFiledSecond---2----%@---",[self.CalculaSignArry objectAtIndex:sender.tag]);
                    self.JumpStr = [[self.ConnectStr stringByAppendingString:baseStr] stringByAppendingString:@","];
                    self.ConnectStr = self.JumpStr;
                    self.JumpStr = [self.JumpStr substringWithRange:NSMakeRange(0, self.JumpStr.length - 1)];
                     [self runDelegateFromButtonTag:self.JumpStr andButtonTage:[sender.OrderTags integerValue]];
                 }
            }
                break;
            default:
                break;
                
        }
    }
}

//改变键盘上显示的数据
-(void)changeTheValueOfTheKeyBoard{
    
    NSMutableArray * titleArr = [NSMutableArray arrayWithCapacity:0];
    if(self.TextSelectPostion==TextFiledFirst){
        //字符键盘
        if (self.selectState) {//小写
            titleArr = self.SmallCharacterArry;
        }else{//大写
            titleArr = self.BigCharacterArry;
        }
    }else if (self.TextSelectPostion==TextFiledSecond){
        //数字 符号键盘
        if (self.selectState) {
            titleArr = self.numberArray;
        }else{
            titleArr = self.CalculaSignArry;
        }
    }
    
    for (UIView * subView in self.KeyBoardConsoleView.subviews) {
        UIButton * titleBtn =(UIButton *)subView;
        [titleBtn setTitle:[titleArr objectAtIndex:titleBtn.tag] forState:UIControlStateNormal];
        if(titleBtn.tag==19){
            
            if(self.TextSelectPostion == TextFiledFirst){
                if(self.selectState == YES){
                    [titleBtn setImage:[UIImage imageNamed:@"ShiftSmall"] forState:UIControlStateNormal];
                }else{
                    [titleBtn setImage:[UIImage imageNamed:@"ShiftBig"] forState:UIControlStateNormal];
                }
            }else if(self.TextSelectPostion == TextFiledSecond){
                [titleBtn setImage:nil forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - 获取第一个文本框内容
-(void)runDelegateFromButtonTag:(NSString *)ButtonText andButtonTage:(NSInteger)TageValue {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getKeyBoardViewValueFromButton:DidSelectButTag:)]){
//         NSLog(@"第一个文本输入框加密后获取文本框内容%@",ButtonText);
        [self.delegate getKeyBoardViewValueFromButton:ButtonText DidSelectButTag:TageValue];
    }
}

-(UIView *)KeyBoardConsoleView {
    
    if (!_KeyBoardConsoleView) {
        _KeyBoardConsoleView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-KeyBoardHeightScale, SCREEN_WIDTH, KeyBoardHeightScale)];
        _KeyBoardConsoleView.backgroundColor = [UIColor colorWithRed:210/255.0f green:213/255.0f blue:219/255.0f alpha:1];
//         _KeyBoardConsoleView.backgroundColor = [UIColor redColor];
        

        for (int i =0; i < 10; i++){
            for (int j = 0; j < 4; j++){
                self.CharacterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (j == 0 && i < 10) {
                    [self.CharacterBtn setFrame:CGRectMake(MarddingLeftSclae + i * (CharBtnWidthScale + PaddingRightScale), PaddingTopScale, CharBtnWidthScale, CharBtnHeightScale)];
                    self.CharacterBtn.tag = i ;
                    [self.CharacterBtn setOrderTags: [NSString stringWithFormat:@"%d",(int)self.CharacterBtn.tag + CharacterKey]];
                    
                }else if (j == 1 && i <9 ){
                    
                    CGFloat secY = PaddingTopScale + (CharBtnHeightScale + PaddingButtomScale) * j;
                    [self.CharacterBtn setFrame:CGRectMake(MarddingSecondLeftSclae + i * (CharBtnWidthScale + PaddingRightScale), secY, CharBtnWidthScale, CharBtnHeightScale)];
                    self.CharacterBtn.tag = i +10 *j;
                    [self.CharacterBtn setOrderTags: [NSString stringWithFormat:@"%d",(int)self.CharacterBtn.tag + CharacterKey]];
                }
                else if (j == 2 && i <9){
                    
                    CGFloat thirdY = PaddingTopScale + (CharBtnHeightScale + PaddingButtomScale) * j;
                   
                    if (j== 2 && i == 0) {
                        [self.CharacterBtn setFrame:CGRectMake(PaddingRightScale, thirdY , BigToSmallWidthScale , CharBtnHeightScale)];
                        self.CharacterBtn.tag = i +9 *j +1;
                        [self.CharacterBtn setOrderTags: [NSString stringWithFormat:@"%d",(int)self.CharacterBtn.tag + CharacterKey]];
                        [self.CharacterBtn setImage:[UIImage imageNamed:@"ShiftSmall"] forState:UIControlStateNormal];
                        
                    }else if(j== 2 && i == 8){
                        
                        [self.CharacterBtn setFrame:CGRectMake(SCREEN_WIDTH - PaddingRightScale - BigToSmallWidthScale,thirdY , BigToSmallWidthScale , CharBtnHeightScale)];
                        self.CharacterBtn.tag = i +9 *j+1;
                        [self.CharacterBtn setOrderTags: [NSString stringWithFormat:@"%ld",self.CharacterBtn.tag + CharacterKey]];
                        self.CharacterBtn.layer.cornerRadius = 3;
                        self.CharacterBtn.layer.masksToBounds = YES;
                        self.CharacterBtn.backgroundColor = ButtonBgColor;
                        //删除按钮
//                        [self.CharacterBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [self.CharacterBtn setTitle:@"<-" forState:UIControlStateNormal];
                        UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnLongPress:)];
                        longPressGesture.minimumPressDuration=1.0f;//设置长按 时间
                        [self.CharacterBtn addGestureRecognizer:longPressGesture];
                    
                    }else{
                        
                        CGFloat padding = i !=1? PaddingRightScale :0.0;
                        CGFloat leftDistance = MarddingLeftSclae + BigToSmallWidthScale + PaddingThirdRightScale;
                        [self.CharacterBtn setFrame:CGRectMake(leftDistance+ (i - 1)* (CharBtnWidthScale + padding ), thirdY, CharBtnWidthScale , CharBtnHeightScale)];
                        self.CharacterBtn.tag = i +9 *j+1;
                        [self.CharacterBtn setOrderTags: [NSString stringWithFormat:@"%ld",self.CharacterBtn.tag + CharacterKey]];
                    }
                }
                
                else if(j ==3 && i < 3){
                    CGFloat fourthY = PaddingTopScale + (CharBtnHeightScale + PaddingButtomScale) * j;
                    if (j == 3 && i== 0) {
                        [self.CharacterBtn setFrame:CGRectMake(MarddingLeftSclae ,fourthY , NumberChnageWidthScale , CharBtnHeightScale)];
                        self.CharacterBtn.tag = i +9 *j+1;
                        [self.CharacterBtn setOrderTags: [NSString stringWithFormat:@"%ld",self.CharacterBtn.tag + CharacterKey]];
                    }else if (j == 3 && i == 1){
                        [self.CharacterBtn setFrame:CGRectMake(MarddingLeftSclae + i * (NumberChnageWidthScale + PaddingRightScale), fourthY, SpeaceButtonWidthScale, CharBtnHeightScale)];
                        self.CharacterBtn.tag = i +9 *j+1;
                        [self.CharacterBtn setOrderTags: [NSString stringWithFormat:@"%ld",self.CharacterBtn.tag + CharacterKey]];
                    }else if(j == 3 && i == 2){
                        [self.CharacterBtn setFrame:CGRectMake(SCREEN_WIDTH - MarddingLeftSclae - ReturnButtonWidthScale, fourthY, ReturnButtonWidthScale,CharBtnHeightScale)];
                        self.CharacterBtn.tag = i +9 *j+1;
                        [self.CharacterBtn setOrderTags: [NSString stringWithFormat:@"%ld",self.CharacterBtn.tag + CharacterKey]];
                    }
                }
                
                //按键背景
                UIImage * CharacterBtnImage = [UIImage imageNamed:@"whiteBack"];
                CharacterBtnImage = [CharacterBtnImage stretchableImageWithLeftCapWidth:CharacterBtnImage.size.width * 0.5 topCapHeight:CharacterBtnImage.size.height * 0.5];
                
                if(self.CharacterBtn.tag ==27 ||self.CharacterBtn.tag ==28||self.CharacterBtn.tag ==30){
                    self.CharacterBtn.layer.cornerRadius = 3;
                    self.CharacterBtn.layer.masksToBounds = YES;
                    self.CharacterBtn.backgroundColor = ButtonBgColor;
                }else{
                     [self.CharacterBtn setBackgroundImage:CharacterBtnImage forState:UIControlStateNormal];
                }
                
                //按键高亮背景
                UIImage * CharacterBtnHightedImage = [UIImage imageNamed:@"congsoleImage"];
                CharacterBtnHightedImage = [CharacterBtnHightedImage stretchableImageWithLeftCapWidth:CharacterBtnHightedImage.size.width * 0.5 topCapHeight:CharacterBtnHightedImage.size.height * 0.5];
                [self.CharacterBtn setBackgroundImage:CharacterBtnHightedImage forState:UIControlStateHighlighted];
                
                [self.CharacterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.CharacterBtn.titleLabel.font = KeyBoardFont;
                self.CharacterBtn.adjustsImageWhenHighlighted = NO;
                [self.CharacterBtn setTitle:[self.SmallCharacterArry objectAtIndex:self.CharacterBtn.tag]forState:UIControlStateNormal];
                [self.KeyBoardConsoleView addSubview:self.CharacterBtn];
                [self.CharacterBtn addTarget:self action:@selector(CharacterDidSelect:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    return _KeyBoardConsoleView;
}


-(void)btnLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        [self base64TextFieldShouldClear];
    }
}

//键盘的 KeyBoardAccessoryView
-(UIView *)KeyBoardAccessoryView {
    
    if (!_KeyBoardAccessoryView) {
        _KeyBoardAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-KeyBoardHeightScale-45, SCREEN_WIDTH, 45)];
        _KeyBoardAccessoryView.backgroundColor = [UIColor whiteColor];

        UILabel * codeLabel = [[UILabel alloc] init];
        codeLabel.text = @"安全键盘";
//        codeLabel.font = sizeFont7;
        codeLabel.textAlignment = NSTextAlignmentCenter;
        [codeLabel sizeToFit];
//        codeLabel.frame = CGRectMake(80, 0, SCREEN_WIDTH-2*80, 45);
        [_KeyBoardAccessoryView addSubview:codeLabel];
        [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(45);
            make.centerX.equalTo(_KeyBoardAccessoryView.mas_centerX);
        }];
        
        
        UIImageView * codeImage= [[UIImageView alloc] init];
        codeImage.image = [UIImage imageNamed:@"WechatIMG673"];
        [_KeyBoardAccessoryView addSubview:codeImage];
        [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(codeLabel.mas_left).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(30,30));
            make.centerY.equalTo(codeLabel.mas_centerY);
        }];
        
        
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.frame = CGRectMake(SCREEN_WIDTH-51, 2, 1, 41);
        [_KeyBoardAccessoryView addSubview:lineView];
        
        UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(SCREEN_WIDTH-50, 0, 50, 45);
        sureButton.tag = 100;
        [sureButton addTarget:self action:@selector(sureButtonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        sureButton.adjustsImageWhenHighlighted = NO;
        [sureButton setImage:[UIImage imageNamed:@"arrowDown_icon"] forState:UIControlStateNormal];
        [_KeyBoardAccessoryView addSubview:sureButton];
        
    }
    return _KeyBoardAccessoryView;
}

//隐藏按钮
-(void)sureButtonDidSelect:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardAnmitionDown)]){
        [self.delegate  keyBoardAnmitionDown];
    }
}

#pragma mark - 清除按钮点击事件
- (void)base64TextFieldShouldClear{
    
    switch (self.TextSelectPostion){
        case TextFiledFirst:
        case TextFiledSecond:
        {
            if (![self.ConnectStr isEqualToString:@""]){
                /**截取非最后一位*/
                NSString * NotInlastObjc = @"";
                /**截取完赋值给connectStr*/
                self.ConnectStr = NotInlastObjc;
                self.JumpStr = self.ConnectStr;
                
                NSString * resShowStr = IsStrEmpty(self.JumpStr)  ? @"~" : [self.JumpStr substringWithRange:NSMakeRange(0, self.JumpStr.length - 1)] ;
                /**赋值删除完标志*/
                self.DeleteDone = IsStrEmpty(self.JumpStr);
                [self runDelegateFromButtonTag:resShowStr andButtonTage:11];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark- 解码
+ (NSString *)tranceBaseToString :(NSString *)str{
    
    NSString * resStr = @"";
    NSLog(@"self.phoneTextPleace===%@",str);
    for (NSString * item in [str componentsSeparatedByString:@","]) {
        resStr = [resStr stringByAppendingString:__TEXT(item)];
        //NSLog(@"resStr解码后的字符串%@",resStr);
    }
    return resStr;
}

#pragma mark - *加密
+ (NSString *)returnByArryCount:(NSString *)text{
    
    NSString * strRetun = @"";
    if ([text isEqualToString:@"~"]) {
        strRetun = @"";
    }else {
        if ([text isEqualToString:@""]) {
            strRetun = @"";
        }else{
            NSArray * tempArry = [text componentsSeparatedByString:@","];
            for (NSInteger index = 0; index < tempArry.count; index++) {
                strRetun = [strRetun stringByAppendingString:@"*"];
            }
        }
    }
    return strRetun;
}

@end
