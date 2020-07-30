//
//  ViewController.m
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "ViewController.h"
#import "ThiredVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)push:(id)sender {
    ThiredVC *vc=[[ThiredVC alloc]initWithNibName:@"ThiredVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
