//
//  DDUtil.h
//  DDPhoneNumLink
//
//  Created by 丁丁 on 16/1/6.
//  Copyright © 2016年 huangyanan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDUtil : NSObject

/**
 *  // 验证是固话或者手机号
 *
 *  @param mobileNum 手机号
 *
 *  @return 是否
 */
+ (BOOL)isMobilePhoneOrtelePhone:(NSString *)mobileNum;

@end
