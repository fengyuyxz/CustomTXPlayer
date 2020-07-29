//
//  YxzLivePlayer.m
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/29.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzLivePlayer.h"
#import "SuspensionWindow.h"
#import "YXZConstant.h"
#import <Masonry/Masonry.h>
#import <SuperPlayer/SuperPlayerModel.h>

#import <TXLiteAVSDK_Player/TXVodPlayer.h>
@interface YxzLivePlayer()<TXLivePlayListener,TXVodPlayListener,UIGestureRecognizerDelegate>


/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@property(nonatomic,strong)TXVodPlayer *vodPlayer;
/** 腾讯直播播放器 */
@property (nonatomic, strong) TXLivePlayer               *livePlayer;
@property (nonatomic,assign) BOOL isLive;

@property(nonatomic,strong)SuperPlayerModel *sPlayerModel;

@end
@implementation YxzLivePlayer
{
    NSURLSessionTask *_currentLoadingTask;
}
- (void)dealloc {
    LOG_ME;
    [self removeGestureRecognizer:self.singleTap];
    [self removeGestureRecognizer:self.doubleTap];
    self.singleTap=nil;
    self.doubleTap=nil;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
//    [self reportPlay];
//    [self.netWatcher stopWatch];
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    self.autoPlay = YES;
    self.backgroundColor=[UIColor blackColor];
    [self addSubview:self.repeatBtn];
    [self addSubview:self.repeatBackBtn];
    [self addSubview:self.controlView];
    
    [self makeSubViewsConstraints];
    [self addNotifications];
    [self createGesture];
}
//设置子视图约束
-(void)makeSubViewsConstraints{
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    [self.repeatBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.width.mas_equalTo(@30);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(60);
        
    }];
}

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    // 监测设备方向
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onDeviceOrientationChange)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onStatusBarOrientationChange)
//                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
//                                               object:nil];
}
/**
 *  创建手势
 */
- (void)createGesture {
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    [self addGestureRecognizer:self.doubleTap];

    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    
    // 加载完成后，再添加平移手势
    // 添加平移手势，用来控制音量、亮度、快进快退
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:panRecognizer];
}
#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        
        if (self.playDidEnd) {
            return;
        }
        if (YxzSuperPlayerWindowShared.isShowing)
            return;
        
        if (self.controlView.hidden) {
            [[self.controlView fadeShow] fadeOut:5];
        } else {
            [self.controlView fadeOut:0.2];
        }
    }
}
/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.playDidEnd) { return;  }
    // 显示控制层
    [self.controlView fadeShow];
    if (self.isPauseByUser) {
        [self resume];
    } else {
        [self pause];
    }
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.playDidEnd){
            return NO;
        }
    }

    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view.superview isKindOfClass:[UISlider class]]) {
        return NO;
    }
  
    if (YxzSuperPlayerWindowShared.isShowing)
        return NO;

    return YES;
}
#pragma mark - UIKit Notifications

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground:(NSNotification *)notify {
    NSLog(@"appDidEnterBackground");
    self.didEnterBackground = YES;
    if (self.isLive) {
        return;
    }
    if (!self.isPauseByUser && (self.state != YxzStateStopped && self.state != YxzStateFailed)) {
        [_vodPlayer pause];
        self.state = YxzStatePause;
    }
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground:(NSNotification *)notify {
    NSLog(@"appDidEnterPlayground");
    self.didEnterBackground = NO;
    if (self.isLive) {
        return;
    }
    if (!self.isPauseByUser && (self.state != StateStopped && self.state != StateFailed)) {
        self.state = StatePlaying;
        [_vodPlayer resume];
    }
}
- (void)setFatherView:(UIView *)fatherView {
    if (fatherView != _fatherView) {
        [self addPlayerToFatherView:fatherView];
    }
    _fatherView = fatherView;
}
- (void)volumeChanged:(NSNotification *)notification
{/*
    if (self.isDragging)
        return; // 正在拖动，不响应音量事件
    
    if (![[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"]) {
        return;
    }
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self fastViewImageAvaliable:SuperPlayerImage(@"sound_max") progress:volume];
    [self.fastView fadeOut:1];
    */
}
/**
 *  设置播放的状态
 *
 *  @param state SuperPlayerState
 */
- (void)setState:(YxzSuperPlayerState)state {
        
    _state = state;
    // 控制菊花显示、隐藏
    if (state == YxzStateBuffering) {
        [self.spinner startAnimating];
    } else {
        [self.spinner stopAnimating];
    }
    if (state == YxzStatePlaying) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeChanged:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
        
        if (self.coverImageView.alpha == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                self.coverImageView.alpha = 0;
            }];
        }
    } else if (state == StateFailed) {
        
    } else if (state == YxzStateStopped) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                      object:nil];
        
        self.coverImageView.alpha = 1;
        
    } else if (state == YxzStatePause) {

    }
}
/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    [self removeFromSuperview];
    if (view) {
        [view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
}
- (void)playWithModel:(YxzPlayerModel *)playerModel{
    _playerModel = playerModel;
    [self configTXPlayer];
    
    self.repeatBtn.hidden = YES;
    self.repeatBackBtn.hidden = YES;
}
-(void)startPaly{
    [self.vodPlayer startPlay:self.playerModel.videoURL];
}
//初始化 播放器
-(void)configTXPlayer{
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    [self.vodPlayer setupVideoWidget:self insertIndex:0];
    self.isPauseByUser = NO;
    self.playDidEnd = NO;

    [self startPaly];
    self.repeatBtn.hidden = YES;
    self.repeatBackBtn.hidden = YES;
    [self.controlView fadeShow];
}

- (void)_removeOldPlayer
{
    for (UIView *w in [self subviews]) {
        if ([w isKindOfClass:NSClassFromString(@"TXCRenderView")])
            [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXIJKSDLGLView")])
            [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXCAVPlayerView")])
            [w removeFromSuperview];
    }
}
// 更新当前播放的视频信息，包括清晰度、码率等
- (void)updateBitrates:(NSArray<TXBitrateItem *> *)bitrates;
{
    if (bitrates.count > 0) {
        

    }
    [self.controlView resetWithResolutionNames:nil currentResolutionIndex:0 isLive:self.isLive isTimeShifting:NO isPlaying:self.autoPlay];
    
}
#pragma mark - 点播进度条
-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        float duration = 0;
        if (self.originalDuration > 0) {
            duration = self.originalDuration;
        } else {
            duration = player.duration;
        }
        if (EvtID == PLAY_EVT_PLAY_BEGIN || EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
             [self setNeedsLayout];
                        [self layoutIfNeeded];
                        self.isLoaded = YES;
                        [self _removeOldPlayer];
                        [self.vodPlayer setupVideoWidget:self insertIndex:0];
                        [self layoutSubviews];  // 防止横屏状态下添加view显示不全
                        self.state = YxzStatePlaying;

            //            if (self.playerModel.playDefinitions.count == 0) {
                        [self updateBitrates:player.supportedBitrates];
            //            }
        }else if(EvtID == PLAY_EVT_PLAY_PROGRESS) {
            self.playCurrentTime  = player.currentPlaybackTime;
            CGFloat totalTime     = duration;
            CGFloat value         = player.currentPlaybackTime / duration;
            [self.controlView setProgressTime:self.playCurrentTime
                totalTime:totalTime
            progressValue:value
            playableValue:player.playableDuration / duration];
        }else if (EvtID == PLAY_EVT_PLAY_END) {
            [self.controlView setProgressTime:[self playDuration]
                                    totalTime:[self playDuration]
                                progressValue:player.duration/duration
                                playableValue:player.duration/duration];
            [self moviePlayDidEnd];
        }
    });
}
/**
 *  重置player
 */
- (void)resetPlayer {
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    self.vodPlayer = nil;
    
    [self.livePlayer stopPlay];
    [self.livePlayer removeVideoWidget];
    self.livePlayer = nil;
    
    
    
    self.state = YxzStateStopped;
}
/**
 * 暂停
 */
- (void)pause {
    LOG_ME;
    if (!self.isLoaded)
        return;
    [self.controlView setPlayState:NO];
    self.isPauseByUser = YES;
    self.state = StatePause;
    if (self.isLive) {
        [_livePlayer pause];
    } else {
        [_vodPlayer pause];
    }
}
/**
 *  播放
 */
- (void)resume {
    LOG_ME;
    [self.controlView setPlayState:YES];
    self.isPauseByUser = NO;
    self.state = StatePlaying;
    if (self.isLive) {
        [_livePlayer resume];
    } else {
        [_vodPlayer resume];
    }
}

- (void)moviePlayDidEnd {
    self.state = YxzStateStopped;
    self.playDidEnd = YES;
    // 播放结束隐藏
    if (YxzSuperPlayerWindowShared.isShowing) {
        [SuperPlayerWindowShared hide];
        [self resetPlayer];
    }
    [self.controlView fadeOut:0.2];
    
//    [self.netWatcher stopWatch];
    self.repeatBtn.hidden = NO;
    self.repeatBackBtn.hidden = NO;
    
    if ([self.delegate respondsToSelector:@selector(superPlayerDidEnd:)]) {
        [self.delegate superPlayerDidEnd:self];
    }
}
#pragma mark - but event ==
-(void)repeatBtnClick:(UIButton *)but{
    [self configTXPlayer];
}
-(void)controlViewBackAction:(UIButton *)but{
    if (self.isFullScreen) {
        self.isFullScreen = NO;
        return;
    }
    if ([self.delegate respondsToSelector:@selector(superPlayerBackAction:)]) {
        [self.delegate superPlayerBackAction:self];
    }
}
#pragma mark - getterr ========
- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img=YxzSuperPlayerImage(@"repeat_video");
        [_repeatBtn setImage:img forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _repeatBtn;
}
- (UIButton *)repeatBackBtn {
    if (!_repeatBackBtn) {
        _repeatBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBackBtn setImage:YxzSuperPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_repeatBackBtn addTarget:self action:@selector(controlViewBackAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _repeatBackBtn;
}
- (YxzLivePlayerControlView *)controlView{
    if (!_controlView) {
        _controlView=[[YxzLivePlayerControlView alloc]init];
    }
    return _controlView;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.alpha = 0;
        /*
        [self insertSubview:_coverImageView belowSubview:self.controlView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
         */
    }
    return _coverImageView;
}
- (MMMaterialDesignSpinner *)spinner {
    if (!_spinner) {
        _spinner = [[MMMaterialDesignSpinner alloc] init];
        _spinner.lineWidth = 1;
        _spinner.duration  = 1;
        _spinner.hidden    = YES;
        _spinner.hidesWhenStopped = YES;
        _spinner.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        /*
        [self addSubview:_spinner];
        [_spinner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.with.height.mas_equalTo(45);
        }];
        */
    }
    return _spinner;
}
-(TXVodPlayer *)vodPlayer{
    if (!_vodPlayer) {
        _vodPlayer = [[TXVodPlayer alloc] init];
        _vodPlayer.vodDelegate=self;
    }
    return _vodPlayer;
}
-(TXLivePlayer *)livePlayer{
    if (!_livePlayer) {
        _livePlayer=[[TXLivePlayer alloc]init];
        _livePlayer.delegate=self;
    }
    return _livePlayer;
}
//-(NetWatcher *)netWatcher{
//    if (!_netWatcher) {
//        _netWatcher=[[NetWatcher alloc]init];
//    }
//    return _netWatcher;
//}
@end
