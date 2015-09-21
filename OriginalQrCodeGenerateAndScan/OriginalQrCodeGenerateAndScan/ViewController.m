//
//  ViewController.m
//  OriginalQrCodeGenerateAndScan
//
//  Created by zhanglei on 15/9/21.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//
#define UI_SCREEN_WIDTH                    ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                   ([[UIScreen mainScreen] bounds].size.height)
#define UI_DeviceSystemVersion             [[UIDevice currentDevice].systemVersion intValue]

#import "ViewController.h"
#import "ScanViewController.h"
#import "GenerateViewController.h"
@interface ViewController ()
{
    UILabel * lblTitle;
    UIButton * btnScan;
    UIButton * btnGenerate;
    NSString * data;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    data = @"";
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, UI_SCREEN_WIDTH, 80)];
    [lblTitle setFont:[UIFont systemFontOfSize:16]];
    [lblTitle setText:@"采用IOS原生的框架和库进行二维码生成和扫描Demo"];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setNumberOfLines:3];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lblTitle];
    
    btnScan = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, UI_SCREEN_WIDTH-20, 30)];
    [btnScan setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [btnScan.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnScan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    [btnScan setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btnScan];
    
    btnGenerate = [[UIButton alloc] initWithFrame:CGRectMake(10, 240, UI_SCREEN_WIDTH-20, 30)];
    [btnGenerate setTitle:@"生成二维码" forState:UIControlStateNormal];
    [btnGenerate.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnGenerate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnGenerate addTarget:self action:@selector(generate:) forControlEvents:UIControlEventTouchUpInside];
    [btnGenerate setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btnGenerate];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![data isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫描结果" message:data preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController removeFromParentViewController];
        }];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)scan:(id)sender{
    ScanViewController * view = [[ScanViewController alloc] init];
    view.delegate = self;
    [self presentViewController:view animated:YES completion:^{
        
    }];
}

-(void)scanFinish:(NSString *)d{
    data = d;
}

-(void)generate:(id)sender{
    GenerateViewController * generate = [[GenerateViewController alloc] init];
    [self presentViewController:generate animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
