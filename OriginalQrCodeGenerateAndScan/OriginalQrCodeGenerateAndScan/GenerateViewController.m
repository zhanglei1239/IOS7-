//
//  GenerateViewController.m
//  OriginalQrCodeGenerateAndScan
//
//  Created by zhanglei on 15/9/21.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//
#define UI_SCREEN_WIDTH                    ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                   ([[UIScreen mainScreen] bounds].size.height)
#define UI_DeviceSystemVersion             [[UIDevice currentDevice].systemVersion intValue]
#import "GenerateViewController.h"

@interface GenerateViewController ()
{
    UITextField * utfContent;
    UIButton * btnGenerate;
    UIImageView * imgQrCode;
    UIButton * btnBack;
}
@end

@implementation GenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //     Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    
    UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 40)];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setFont:[UIFont systemFontOfSize:16]];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setText:@"二维码生成"];
    [self.view addSubview:lblTitle];
    
    btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnBack];
    
    utfContent = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, UI_SCREEN_WIDTH-20, 30)];
    [utfContent.layer setMasksToBounds:YES];
    [utfContent.layer setCornerRadius:1];
    [utfContent.layer setBorderColor:[UIColor redColor].CGColor];
    [utfContent.layer setBorderWidth:.5];
    [utfContent setFont:[UIFont systemFontOfSize:14]];
    [utfContent setTextColor:[UIColor blackColor]];
    utfContent.placeholder = @"输入二维码生成内容!";
    utfContent.delegate = self;
    [self.view addSubview:utfContent];
    
    btnGenerate = [[UIButton alloc] initWithFrame:CGRectMake(10, 260, UI_SCREEN_WIDTH-20, 30)];
    [btnGenerate addTarget:self action:@selector(generate:) forControlEvents:UIControlEventTouchUpInside];
    [btnGenerate setTitle:@"生成" forState:UIControlStateNormal];
    [btnGenerate setBackgroundColor:[UIColor redColor]];
    [btnGenerate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btnGenerate];
    
    imgQrCode = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2, 300, 200, 200)];
    [self.view addSubview:imgQrCode];
}

-(void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)generate:(id)sender{
    [utfContent resignFirstResponder];
    if (![utfContent.text isEqualToString:@""]) {
        imgQrCode.image = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:utfContent.text] withSize:imgQrCode.frame.size.width];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"扫描结果" message:@"请输入生成内容" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController removeFromParentViewController];
        }];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
