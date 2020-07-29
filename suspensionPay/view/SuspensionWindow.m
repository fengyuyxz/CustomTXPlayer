//
//  SuspensionWindow.m
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/28.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "SuspensionWindow.h"
#define sus_w 150
#define sus_h 100
@interface SuspensionWindow()
{
    
}
@property(nonatomic,assign)CGRect firstRect;
@property(nonatomic,strong)UIView *contianerView;
@property(nonatomic,strong)UIButton *backBut;
@property(nonatomic,assign)CGPoint lastPoint;
@property(nonatomic,assign)CGPoint pointInSelf;
@property (weak) UIView *origFatherView;


@end
@implementation SuspensionWindow

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static SuspensionWindow *instance=nil;
    dispatch_once(&onceToken, ^{
        instance=[[SuspensionWindow alloc]init];
    });
    return instance;;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor=[UIColor redColor];
        [self setupView];
        self.frame=_firstRect;
    }
    
    return self;
}
-(void)setupView{
    _isShowing=NO;
    CGSize size=[UIScreen mainScreen].bounds.size;
    _firstRect=CGRectMake(size.width-sus_w, size.height-sus_h-60, sus_w, sus_h);
    _contianerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, sus_w, sus_h)];
    _backBut=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBut.frame=CGRectMake(0, 0, sus_w, sus_h);
    [_backBut addTarget:self action:@selector(backButPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_contianerView];
//    [self addSubview:_backBut];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    self.lastPoint=[touch locationInView:self.superview];
    self.pointInSelf=[touch locationInView:self];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint currentPoint=[touch locationInView:self.superview];
    CGFloat centerX=currentPoint.x+(self.frame.size.width/2.0f-self.pointInSelf.x);
    CGFloat centerY=currentPoint.y+(self.frame.size.height/2.0f-self.pointInSelf.y);
    
    CGFloat x=MAX(sus_w/2.0f, MIN([UIScreen mainScreen].bounds.size.width-sus_w/2, centerX));
    CGFloat y=MAX(sus_h/2.0f, MIN([UIScreen mainScreen].bounds.size.height-sus_h/2, centerY));
    
    
    self.center=CGPointMake(x, y);
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.superview];
    if (CGPointEqualToPoint(point, self.lastPoint)) {
        [self backButPressed];
        return;
    }
}

-(void)backButPressed{
    if (self.backHandler) {
        self.backHandler();
    } else {
        [self hidden];
        [self.topNavigationController pushViewController:self.backController animated:YES];
        self.backController = nil;
    }
}
-(void)hidden{
    _isShowing=NO;
    [self.superPlayer.controlView isSuspensionPlay:NO];
    [self removeFromSuperview];
    
    
    
    
    self.hidden = YES;
    
    self.superPlayer.fatherView = self.origFatherView;
    
    _isShowing = NO;
    
}
-(void)show{
    _isShowing=YES;
    self.hidden=NO;
    self.frame=_firstRect;
    self.origFatherView = self.superPlayer.fatherView;
    if (self.origFatherView!=self) {
        self.superPlayer.fatherView=self;
        [self.superPlayer.controlView isSuspensionPlay:YES];
    }
    UIWindow *wid=nil;
    if (@available(ios 13.0,*)) {
        wid= [[[UIApplication sharedApplication] windows] firstObject];
        if(!wid){
            NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *windowScene = (UIWindowScene *)array[0];
            wid=[windowScene.windows firstObject];

            
        }
    }else{
        wid=[UIApplication sharedApplication].keyWindow;
    }
    if (!self.superview) {
        [wid addSubview:self];
        [wid bringSubviewToFront:self];
    }
    
}
-(UIWindow *)getWindow{
    UIWindow *wid=nil;
    if (@available(ios 13.0,*)) {
        wid= [[[UIApplication sharedApplication] windows] firstObject];
        if(!wid){
            NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *windowScene = (UIWindowScene *)array[0];
            wid=[windowScene.windows firstObject];

            
        }
    }else{
        wid=[UIApplication sharedApplication].keyWindow;
    }
    return wid;
}
- (UINavigationController *)topNavigationController {
    UIWindow *window = [self getWindow];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController.navigationController;
}
@end
