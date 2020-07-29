//
//  SuspensionWindow.h
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/28.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YxzLivePlayer.h"

#import <SuperPlayer/SuperPlayer.h>
@interface SuspensionWindow : UIView
typedef void(^SuspensionWindowEventHandler)(void);

@property (nonatomic,copy) SuspensionWindowEventHandler backHandler;
@property (nonatomic,copy) SuspensionWindowEventHandler closeHandler;  // 默认关闭

@property YxzLivePlayer *superPlayer;
@property UIViewController *backController;
/// 小窗是否显示
@property (readonly) BOOL isShowing;  //

+(instancetype)shareInstance;
-(void)show;
-(void)hidden;
@end


