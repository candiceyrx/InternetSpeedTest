//
//  ViewController.m
//  测试网速
//
//  Created by Candice on 16/12/15.
//  Copyright © 2016年 刘灵. All rights reserved.
//

#import "ViewController.h"
#import "FGGDownloadManager.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kCachePath (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])

@interface ViewController ()
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    downloadButton.frame = CGRectMake(150, 100, 100, 80);
    [downloadButton setTitle:@"点击下载" forState:UIControlStateNormal];
    [self.view addSubview:downloadButton];
    [downloadButton addTarget:self action:@selector(downloadFileClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 200, kWidth-20, 0)];
    [self.view addSubview:_progressView];
    
    CGFloat viewW = kWidth/4;
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, viewW, 40)];
    label1.text = @"下载进度:";
    [self.view addSubview:label1];
    
    _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x+label1.frame.size.width, 210, viewW, 40)];
    [self.view addSubview:_sizeLabel];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(_sizeLabel.frame.origin.x+_sizeLabel.frame.size.width, 210, viewW, 40)];
    label2.text = @"下载网速:";
    [self.view addSubview:label2];
    
    _speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width,  210, viewW, 40)];
    [self.view addSubview:_speedLabel];

}

- (void)downloadFileClicked {
    NSLog(@"开始下载");

    if ([self isFileExist:@"测试网速文档"]) {
        NSLog(@"存在,需要删除");
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [kCachePath stringByAppendingPathComponent:@"测试网速文档"];
        BOOL isDelete = [fileManager removeItemAtPath:filePath error:nil];
        if (isDelete) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    } else {
        NSLog(@"不存在");
        return;
    }
    
    NSString *url = @"http://mportal.taiji.com.cn:8080/app/package/download.data";
    NSString *destinationPath = [kCachePath stringByAppendingPathComponent:@"测试网速文档"];
    __weak typeof(self) weakSelf = self;
    [[FGGDownloadManager shredManager] downloadWithUrlString:url toPath:destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
        //更新进度条的进度值
        weakSelf.progressView.progress=progress;
        //更新文件已下载的大小
        weakSelf.sizeLabel.text=sizeString;
        //显示网速
        weakSelf.speedLabel.text=speedString;
        if(speedString)
            weakSelf.speedLabel.hidden=NO;
        
    } completion:^{
        NSLog(@"成功");
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

- (BOOL)isFileExist:(NSString *)fileName {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在:%@",result ? @"是的" : @"不存在");
    
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
