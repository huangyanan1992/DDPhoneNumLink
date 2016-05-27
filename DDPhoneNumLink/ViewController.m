//
//  ViewController.m
//  DDPhoneNumLink
//
//  Created by 丁丁 on 16/1/6.
//  Copyright © 2016年 huangyanan. All rights reserved.
//

#import "ViewController.h"
#import "TTTAttributedLabel.h"
#define PHONEREGULAR @"\\d{3,4}[- ]?\\d{7,8}"
#import "DDUtil.h"
@interface ViewController ()<TTTAttributedLabelDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *ddLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *content = @"这是手机号：17089538589\n这是手机号：18049284890\n不是手机号：20483829382\n这是固话号：4007701616\n没有连字符的固话0105342123";
    self.ddLabel.delegate = self;
    [self addLinkWithStr:content];
}

- (void)addLinkWithStr:(NSString *)content {
    //添加链接样式
    self.ddLabel.linkAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
    
    //设置段落，文字样式
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 6.0;
    NSDictionary *paragraphDic = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSParagraphStyleAttributeName:paragraphstyle};
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:content attributes:paragraphDic];
    
    [tempStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, content.length)];
    
    self.ddLabel.text = tempStr;
    
    NSRange stringRange = NSMakeRange(0, tempStr.length);
    //正则匹配
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:PHONEREGULAR options:0 error:&error];
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:[tempStr string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            //添加链接
            NSString *actionString = [NSString stringWithFormat:@"%@",[self.ddLabel.text substringWithRange:result.range]];
            
            if ([DDUtil isMobilePhoneOrtelePhone:actionString] || [[actionString substringToIndex:3] isEqualToString:@"400"]) {
                [self.ddLabel addLinkToPhoneNumber:actionString withRange:result.range];
            }
        }];
    }
}

#pragma mark  ---------------TTTAttributedLabelDelegate--------------

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    //点击手机号
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",phoneNumber];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:phoneNumber message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dialAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:dialAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:phoneNumber message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        
        [alertView show];
    }
    
}

#pragma mark  ---------------UIAlertViewDelegate--------------

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",alertView.title];
    if (buttonIndex == 0) {
        
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }
}

@end
