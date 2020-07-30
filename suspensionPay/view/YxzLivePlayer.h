//
//  YxzLivePlayer.h
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/29.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YxzPlayerModel.h"
#import "YxzLivePlayerControlView.h"
#import "YxzLiveRoomControlDelegate.h"
#import <SuperPlayer/MMMaterialDesignSpinner.h>
#import <SuperPlayer/SuperPlayerViewConfig.h>
#import <SuperPlayer/NetWatcher.h>
@class YxzLivePlayer;
NS_ASSUME_NONNULL_BEGIN
/// 播放器的状态
typedef NS_ENUM(NSInteger, YxzSuperPlayerState) {
    YxzStateFailed,     // 播放失败
    YxzStateBuffering,  // 缓冲中
    YxzStatePlaying,    // 播放中
    YxzStateStopped,    // 停止播放
    YxzStatePause,      // 暂停播放
};

typedef NS_ENUM(NSInteger, YxzButtonAction) {
    YxzActionNone,
    YxzActionRetry,
    YxzActionSwitch,
    YxzActionIgnore,
    YxzActionContinueReplay,
};


@protocol YxzPlayerDelegate <NSObject>
@optional

/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen;

/// 返回事件
- (void)superPlayerBackAction:(YxzLivePlayer *)player;
/// 全屏改变通知
- (void)superPlayerFullScreenChanged:(YxzLivePlayer *)player;
/// 播放开始通知
- (void)superPlayerDidStart:(YxzLivePlayer *)player;
/// 播放结束通知
- (void)superPlayerDidEnd:(YxzLivePlayer *)player;
/// 播放错误通知
- (void)superPlayerError:(YxzLivePlayer *)player errCode:(int)code errMessage:(NSString *)why;
// 需要通知到父view的事件在此添加
@end

@interface YxzLivePlayer : UIView


@property(nonatomic,weak)id<YxzLiveRoomControlDelegate> roomControlDelegate;

@property(nonatomic,weak)id<YxzPlayerDelegate> delegate;

/** 进入后台*/
@property (nonatomic, assign) BOOL                   didEnterBackground;
@property (nonatomic, assign) BOOL                   playDidEnd;


/// 是否是直播流
@property (readonly) BOOL isLive;
@property(nonatomic) BOOL  isLoaded;
/// 播放器的状态
@property (nonatomic, assign) YxzSuperPlayerState state;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                   isPauseByUser;
/// 设置封面图片
@property (nonatomic) UIImageView *coverImageView;
/// 重播按钮
@property (nonatomic, strong) UIButton *repeatBtn;
/// 全屏退出
@property (nonatomic, strong) UIButton *repeatBackBtn;
/// 是否自动播放（在playWithModel前设置)
@property (nonatomic) BOOL autoPlay;
/// 是否全屏
@property (nonatomic, assign) BOOL isFullScreen;

/// 设置播放器的父view。播放过程中调用可实现播放窗口转移
@property (nonatomic, weak) UIView *fatherView;

@property(nonatomic,strong)YxzLivePlayerControlView *controlView;

/// 视频总时长
@property (nonatomic) CGFloat playDuration;
/// 原始视频总时长，主要用于试看场景下显示总时长
@property (nonatomic) NSTimeInterval originalDuration;
/// 视频当前播放时间
@property (nonatomic) CGFloat playCurrentTime;
/// 起始播放时间，用于从上次位置开播
@property CGFloat startTime;

@property (readonly) YxzPlayerModel       *playerModel;

@property(nonatomic,strong)MMMaterialDesignSpinner *spinner;

@property(nonatomic,strong)NetWatcher *netWatcher;
@property (nonatomic) CGFloat videoRatio;
/// 播放配置
@property SuperPlayerViewConfig *plaConfig;

- (void)playWithModel:(YxzPlayerModel *)playerModel;
@end

NS_ASSUME_NONNULL_END
