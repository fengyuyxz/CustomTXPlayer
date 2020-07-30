//
//  SecondeViewController.m
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "SecondeViewController.h"
#import "SuspensionWindow.h"
#import "YxzLivePlayer.h"
#import <Masonry/Masonry.h>
@interface SecondeViewController ()<YxzPlayerDelegate>

@property(nonatomic,strong)UIView *videoContainerView;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)YxzLivePlayer *livePlayer;
@property(nonatomic,strong)UIView *containerView;
@end

@implementation SecondeViewController
- (instancetype)init
{
    SuspensionWindow *window=[SuspensionWindow shareInstance];
    if (window.backController) {
        return (SecondeViewController *)window.backController;
    }else{
        self = [super init];
           if (self) {
               
           }
           return self;
    }
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    _containerView=[[UIView alloc]init];
    _containerView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:_containerView];
    [_containerView addSubview:self.videoContainerView];
    _textField=[[UITextField alloc]init];
    _textField.backgroundColor=[UIColor grayColor];
    [_containerView addSubview:_textField];
    
    [self layoutSubViewConstraint];
    self.livePlayer.delegate=self;
    self.livePlayer.fatherView=self.videoContainerView;
    [self startPlayer];
}
-(void)onDeviceOrientationChange{
    [self adjustTransform];
}
-(void)onStatusBarOrientationChange{
    
}
- (void)adjustTransform{
    /*
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];

    self.containerView.transform=CGAffineTransformMakeRotation(M_PI_2);
    [UIView commitAnimations];
     */
}
// 设备支持方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait|UIInterfaceOrientationLandscapeLeft;
}
// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait; // 或者其他值 balabala~
}
/**
 * 获取变换的旋转角度
 *
 * @return 变换矩阵
 */
- (CGAffineTransform)getTransformRotationAngleOfOrientation:(UIDeviceOrientation)orientation {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (interfaceOrientation == (UIInterfaceOrientation)orientation) {
        return CGAffineTransformIdentity;
    }
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

-(void)startPlayer{
    YxzPlayerModel *playModel=[[YxzPlayerModel alloc]init];
    playModel.videoURL=@"http://200024424.vod.myqcloud.com/200024424_810ea00ebdf811e6ad39991f76a4df69.f30.mp4";
    [self.livePlayer playWithModel:playModel];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen{
    if (isFullScreen) {
        [self setInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
    }else{
        [self setInterfaceOrientation:UIDeviceOrientationPortrait];
    }
}

- (void)setInterfaceOrientation:(UIDeviceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
    }
}
/*
- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}
-(void)layoutSubViewConstraint{
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.top.equalTo(self.videoContainerView.mas_bottom);
        make.right.equalTo(self.containerView.mas_right);
        make.height.equalTo(@(40));
    }];
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.top.equalTo(self.containerView.mas_top);
        make.right.equalTo(self.containerView.mas_right);
        make.height.equalTo(@(320));
    }];
  
}
- (IBAction)popSus:(id)sender {
    
    SuspensionWindow *wind=[SuspensionWindow shareInstance];
    wind.superPlayer=self.livePlayer;
    wind.backController=self;
    [wind show];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(UIView *)videoContainerView{
    if (!_videoContainerView) {
        _videoContainerView=[[UIView alloc]init];
    }
    return _videoContainerView;
}
-(YxzLivePlayer *)livePlayer{
    if (!_livePlayer) {
        _livePlayer=[[YxzLivePlayer alloc]init];
    }
    return _livePlayer;
}
@end
