//
//  ScanViewController.h
//  促利汇_实体店
//
//  Created by zhanglei on 15/5/28.
//  Copyright (c) 2015年 lei.zhang. All rights reserved.
// 
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,assign) id delegate;
@property (nonatomic,strong) AVCaptureDevice * device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput * output;
@property (nonatomic,strong) AVCaptureSession * session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;
@end
@protocol scanDelegate <NSObject>

-(void)scanFinish:(NSString *)data;

@end
