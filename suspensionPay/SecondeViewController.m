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
@interface SecondeViewController ()

@property(nonatomic,strong)UIView *videoContainerView;
@property(nonatomic,strong)YxzLivePlayer *livePlayer;
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
    [self.view addSubview:self.videoContainerView];
    
    [self layoutSubViewConstraint];
    self.livePlayer.fatherView=self.videoContainerView;
    [self startPlayer];
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
-(void)layoutSubViewConstraint{
 
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
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
