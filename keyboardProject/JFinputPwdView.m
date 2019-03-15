//
//  JFinputPwdView.m
//  CustomerProject
//
//  Created by misterLiu on 2019/3/14.
//  Copyright © 2019 GK_W. All rights reserved.
//

#import "JFinputPwdView.h"

#import "Base64KeyBoardView.h"
#import "Masonry.h"

@interface JFinputPwdView()<UITextFieldDelegate,KeyBoardShowViewDelegate>

@property(nonatomic, strong)Base64KeyBoardView * keyBoardView;

@end

@implementation JFinputPwdView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
//        [self initControl];
        
        [self addSubview:self.mInput];
        [self.mInput mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);;
            make.height.mas_equalTo(@40);
        }];
       
    }
    return self;
}

-(UITextField *)mInput{
    if (!_mInput) {
//        _mInput = [QDUIHelper generateInputTextField];
         _mInput = [[UITextField alloc] init];
        _mInput.borderStyle  = UITextBorderStyleRoundedRect;
        _mInput.placeholder = @"请输入登录密码";
        _mInput.secureTextEntry = YES;
        _mInput.delegate = self;
        _mInput.inputAccessoryView =self.keyBoardView.KeyBoardAccessoryView;
        _mInput.inputView = self.keyBoardView.KeyBoardConsoleView;
//        _mInput.clearButtonMode = UITextFieldViewModeAlways;
        _mInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _mInput;
}

-(Base64KeyBoardView *)keyBoardView{
    if(!_keyBoardView){
        _keyBoardView = [Base64KeyBoardView KeyBoardMenu];
        _keyBoardView.delegate = self;
        _keyBoardView.BlockChnagkeyBoard = ^(UIView *v){
            //NSLog(@"改变键盘格式");
        };
    }
    return _keyBoardView;
}

#pragma mark - 清除按钮点击事件
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.keyBoardView base64TextFieldShouldClear];
    return YES;
}

-(void)getKeyBoardViewValueFromButton:(NSString * )ButtonTxt DidSelectButTag:(NSInteger)BtnTag {
    
//    NSLog(@"-键盘传过来的数据-%@--%ld--",ButtonTxt,(long)BtnTag);
    self.holderStr = [Base64KeyBoardView returnByArryCount:ButtonTxt];
    self.mInput.text = self.holderStr;
    self.encryStr = ButtonTxt;
}


-(void)layoutSubviews{
    [super layoutSubviews];
//    [self initLayout];
}

- (void)keyBoardAnmitionDown{
   
    if ([self.mInput isFirstResponder])
    {
        [self.mInput resignFirstResponder];
    }
}


@end
