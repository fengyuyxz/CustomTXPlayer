//
//  ThiredVC.m
//  suspensionPay
//
//  Created by 颜学宙 on 2020/7/30.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "ThiredVC.h"
#import "SecondeViewController.h"
@interface ThiredVC ()

@end

@implementation ThiredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)butPressed:(id)sender {
    SecondeViewController *vc=[[SecondeViewController alloc]initWithNibName:@"SecondeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
