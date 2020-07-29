//
//  YxzLivePlayerControlView.m
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/29.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzLivePlayerControlView.h"
#import "YXZConstant.h"
#import <Masonry/Masonry.h>

#import <SuperPlayer/StrUtils.h>
@implementation YxzLivePlayerControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.backgroundColor=[UIColor clearColor];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
//    [self addSubview:self.centerPlayBtn];
    
    [self.bottomView addSubview:self.startBtn];
    [self.bottomView addSubview:self.currentTimeLabel];
    [self.bottomView addSubview:self.totalTimeLabel];
    [self.bottomView addSubview:self.videoSlider];
    [self addSubview:self.fullScreenBtn];
    [self makeSubViewsConstraints];
}
-(void)makeSubViewsConstraints{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(50));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
//    [self.centerPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.width.height.equalTo(@(50));
//    }];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mas_leading).offset(5);
        make.top.equalTo(self.bottomView.mas_top).offset(10);
        make.width.height.mas_equalTo(30);
    }];
   
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(5);
           make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
       }];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.leading.equalTo(self.startBtn.mas_trailing);
             
              make.centerY.equalTo(self.startBtn.mas_centerY);
              make.width.mas_equalTo(50);
       }];
       [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.trailing.equalTo(self.mas_trailing).offset(-50);
           make.leading.equalTo(self.videoSlider.mas_trailing).offset(4);
           make.centerY.equalTo(self.startBtn.mas_centerY);
           make.width.mas_equalTo(50);
       }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.height.mas_equalTo(40);
    }];
    
}
-(void)playBtnClick:(UIButton *)sender{
    sender.selected=!sender.selected;
    if (sender.selected) {
        [self.delegate controlViewPlay:self];
    } else {
        [self.delegate controlViewPause:self];
    }
    [self cancelFadeOut];
}
-(void)fullScreenBtnClick:(UIButton *)but{
    [self.delegate controlViewChangeScreen:self withFullScreen:YES];
    [self fadeOut:3];
}

#pragma mark - public method =======
/** 播放按钮状态 */
- (void)setPlayState:(BOOL)state {
    self.startBtn.selected = state;
}

- (void)setProgressTime:(NSInteger)currentTime
    totalTime:(NSInteger)totalTime
progressValue:(CGFloat)progress
          playableValue:(CGFloat)playable{
    
    if (!self.isDragging) {
        // 更新slider
        self.videoSlider.value           = progress;
    }
     
    // 更新当前播放时间
    self.currentTimeLabel.text = [StrUtils timeFormat:currentTime];
    // 更新总时间
    self.totalTimeLabel.text = [StrUtils timeFormat:totalTime];
    [self.videoSlider.progressView setProgress:playable animated:NO];
//    self.videoSlider.progressView.progress=playable;
}
- (void)resetWithResolutionNames:(NSArray<NSString *> *)resolutionNames
currentResolutionIndex:(NSUInteger)currentResolutionIndex
                isLive:(BOOL)isLive
        isTimeShifting:(BOOL)isTimeShifting
                       isPlaying:(BOOL)isPlaying{
    self.isLive=isLive;
    if (isLive) {
        self.bottomView.hidden=YES;
        self.fullScreenBtn.hidden=NO;
    }else{
        self.bottomView.hidden=NO;
        self.fullScreenBtn.hidden=NO;
    }
    [self setPlayState:isPlaying];
}
-(void)isSuspensionPlay:(BOOL)isSuspension{
    if (isSuspension) {
        self.bottomView.hidden=YES;
        self.fullScreenBtn.hidden=YES;
    }else{
        self.fullScreenBtn.hidden=NO;
        if (self.isLive) {
            
            self.bottomView.hidden=YES;
        }else{
            self.bottomView.hidden=NO;
            
        }
    }
}
#pragma mark - 滑杆 事件
- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.isDragging = YES;
    [self cancelFadeOut];
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    /*
    if (self.maxPlayableRatio > 0 && sender.value > self.maxPlayableRatio) {
        sender.value = self.maxPlayableRatio;
    }
     */
    [self.delegate controlViewPreview:self where:sender.value];
     
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    
    
    self.isDragging = NO;
     
    [self.delegate controlViewSeek:self where:sender.value];
    [self fadeOut:5];
}
#pragma mark -  getter =======
-(UIView *)topView{
    if (!_topView) {
        _topView=[[UIView alloc]init];
        _topView.backgroundColor=[UIColor clearColor];
    }
    return _topView;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[UIView alloc]init];
        _bottomView.backgroundColor=[UIColor clearColor];
    }
    return _bottomView;
}
-(UIButton *)centerPlayBtn{
    if (!_centerPlayBtn) {
        _centerPlayBtn=[self getBut];
        [_centerPlayBtn setImage:YxzSuperPlayerImage(@"play") forState:UIControlStateNormal];
    }
    return _centerPlayBtn;
}
-(UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn=[self getBut];
        [_startBtn setImage:YxzSuperPlayerImage(@"play") forState:UIControlStateNormal];
        [_startBtn setImage:YxzSuperPlayerImage(@"pause") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}
- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.text=@"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.text=@"10:00";
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
- (PlayerSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[PlayerSlider alloc] init];
        [_videoSlider setThumbImage:YxzSuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];
        _videoSlider.minimumTrackTintColor = TintColor;
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        _videoSlider.delegate = self;
    }
    return _videoSlider;
}
- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:YxzSuperPlayerImage(@"fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}
-(UIButton *)getBut{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}
@end
