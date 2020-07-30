//
//  YxzLivePlayerControlView.h
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/29.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SuperPlayer/PlayerSlider.h>
#import <SuperPlayer/UIView+Fade.h>
#import "YxzLiveRoomControlDelegate.h"
@class YxzLivePlayerControlView;
@protocol YxzPlayerControlViewDelegate <NSObject>

/** 返回按钮事件 */
- (void)controlViewBack:(UIView *)controlView;
/** 播放 */
- (void)controlViewPlay:(UIView *)controlView;
/** 暂停 */
- (void)controlViewPause:(UIView *)controlView;
/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen;
- (void)controlViewDidChangeScreen:(UIView *)controlView;
/** 锁定屏幕方向 */
- (void)controlViewLockScreen:(UIView *)controlView withLock:(BOOL)islock;
/** 截屏事件 */
- (void)controlViewSnapshot:(UIView *)controlView;
/** 切换分辨率按钮事件 */
- (void)controlViewSwitch:(UIView *)controlView withDefinition:(NSString *)definition;
/** 修改配置 */
- (void)controlViewConfigUpdate:(YxzLivePlayerControlView *)controlView withReload:(BOOL)reload;
/** 重新播放 */
- (void)controlViewReload:(UIView *)controlView;
/** seek事件，pos 0~1 */
- (void)controlViewSeek:(UIView *)controlView where:(CGFloat)pos;
/** 滑动预览，pos 0~1 */
- (void)controlViewPreview:(UIView *)controlView where:(CGFloat)pos;

@end



@interface YxzLivePlayerControlView : UIView

@property(nonatomic,weak)id<YxzPlayerControlViewDelegate> delegate;

@property(nonatomic,weak)id<YxzLiveRoomControlDelegate> roomControlDelegate;

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;
/**中间播放按钮*/
@property(nonatomic,strong)UIButton *centerPlayBtn;
/**开始播放按钮*/
@property(nonatomic,strong)UIButton *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;

/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 跟多选择 */
@property(nonatomic,strong)UIButton *moreBut;
/** 小窗按钮 */
@property(nonatomic,strong)UIButton *suspensionBut;

/** 滑杆 */
@property (nonatomic, strong) PlayerSlider   *videoSlider;

/// 是否在拖动进度
@property BOOL  isDragging;
@property(nonatomic,assign)BOOL isLive;
-(void)isSuspensionPlay:(BOOL)isSuspension;

//设置播放进度事件
- (void)setProgressTime:(NSInteger)currentTime
              totalTime:(NSInteger)totalTime
          progressValue:(CGFloat)progress
          playableValue:(CGFloat)playable;
- (void)setPlayState:(BOOL)isPlay;
// 设置播放状态
- (void)resetWithResolutionNames:(NSArray<NSString *> *)resolutionNames
currentResolutionIndex:(NSUInteger)currentResolutionIndex
                isLive:(BOOL)isLive
        isTimeShifting:(BOOL)isTimeShifting
                       isPlaying:(BOOL)isPlaying;
@end


