//
//  YXZConstant.h
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/29.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#ifndef YXZConstant_h
#define YXZConstant_h
// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define YxzSuperPlayerImage(file)              [UIImage imageNamed:[@"YxzPlayer.bundle" stringByAppendingPathComponent:file]]
#define TintColor RGBA(252, 89, 81, 1)


// 小窗单例
#define YxzSuperPlayerWindowShared             [SuspensionWindow shareInstance]

#endif /* YXZConstant_h */
