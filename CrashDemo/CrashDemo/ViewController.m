//
//  ViewController.m
//  CrashDemo
//
//  Created by 康起军 on 16/4/27.
//  Copyright © 2016年 康起军. All rights reserved.
//

#import "ViewController.h"
#import "LockController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <LocalAuthentication/LAError.h>
#import "NSString+QDTouchID.h"
#import "NoteCollectViewController.h"

#define key_shakeFlag    @"key_shakeFlag"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, LockControllerDelegate, UIDocumentInteractionControllerDelegate>
{
    NSMutableArray *dataArr;
    UITableView *m_tableview;
    
    UIProgressView *m_progressView;
}

@property (strong, nonatomic) UIDocumentInteractionController *docCpntroller;

@end

@implementation ViewController

@synthesize docCpntroller, imageView, titleLab;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Setting";
    
#ifdef TARGET_DEBUG
    NSLog(@"TARGET_DEBUG");
#elif TARGET_APPSTORE
    NSLog(@"TARGET_APPSTORE");
#endif
    
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnClick)];
    self.navigationItem.rightBarButtonItems = @[item0];

    /*
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didNavOneBtnClick:)];
    self.navigationItem.leftBarButtonItems = @[item0];

    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"写入" style:UIBarButtonItemStylePlain target:self action:@selector(didNavOneBtnClick:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didNavOneBtnClick:)];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
*/
    /*
    NSArray *arr1 = [NSArray arrayWithObjects:@"手势密码", @"Touch ID", @"字母密码", nil];
    
    NSArray *arr2 = [NSArray arrayWithObjects:@"更改密码", @"设置伪装密码", nil];
    
    NSArray *arr3 = [NSArray arrayWithObjects:@"摇一摇关闭应用", @"摇一摇锁屏", nil];
    
    NSArray *arr4 = [NSArray arrayWithObjects:@"更改App图标", @"设置伪装", nil];
     
    NSArray *arr5 = [NSArray arrayWithObjects:@"入侵抓拍",@"抓拍记录",nil];
     
    NSArray *arr6 = [NSArray arrayWithObjects:@"意见反馈",@"评价",nil];
     
    NSArray *arr7 = [NSArray arrayWithObjects:@"关于我们",nil];
     
    NSArray *arr8 = [NSArray arrayWithObjects:@"销毁账户",nil];
    
    dataArr = [[NSMutableArray alloc] initWithObjects:arr1, arr2, arr3, arr4, arr5, arr6, arr7, arr8, nil];
    
    m_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20)];
    m_tableview.delegate = self;
    m_tableview.dataSource = self;
    [self.view addSubview:m_tableview];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    */
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(150, 64+200, 200, 40)];
    titleLab.textColor = [UIColor yellowColor];
    [self.view addSubview:titleLab];
    
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/test.png"];
    UIImage *image = [UIImage imageNamed:@"touchID_green.png"];
    NSData *data = UIImagePNGRepresentation(image);
    BOOL success = [data writeToFile:path atomically:YES];
    NSLog(@"%d", success);
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(20, 64+20, 100, 40);
    [openBtn addTarget:self action:@selector(openFile) forControlEvents:UIControlEventTouchUpInside];
    openBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:openBtn];
    
    
    UIButton *openBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn1.frame = CGRectMake(20, 64+20+50, 100, 40);
    [openBtn1 addTarget:self action:@selector(openFile1) forControlEvents:UIControlEventTouchUpInside];
    openBtn1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:openBtn1];
    
    
    UIButton *openBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn2.frame = CGRectMake(20, 64+20+100, 100, 40);
    [openBtn2 addTarget:self action:@selector(openFile2) forControlEvents:UIControlEventTouchUpInside];
    openBtn2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:openBtn2];

    UIButton *openBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn3.frame = CGRectMake(20, 64+20+150, 100, 40);
    [openBtn3 addTarget:self action:@selector(openFile3) forControlEvents:UIControlEventTouchUpInside];
    openBtn3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:openBtn3];
    
    m_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    m_progressView.frame = CGRectMake(20, 64+20+250, 225, 40);
    [self.view addSubview:m_progressView];
}

- (void)addnClick
{
    NoteCollectViewController *viewController = [[NoteCollectViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)openFile
{
    /*
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/test.png"];
    self.docCpntroller = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
    self.docCpntroller.delegate = self;
    
    CGRect navRect =self.navigationController.navigationBar.frame;
    navRect.size =CGSizeMake(1500.0f,40.0f);
    
    //显示包含预览的菜单项
    [self.docCpntroller presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
    
    //显示不包含预览菜单项
//[docController presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
    */
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"zip"];
    
    NSData *data1 = [NSData dataWithContentsOfFile:path];
    NSString *string1 = [data1 base64EncodedStringWithOptions:0];
    
    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:string1 options:0];
    
    if ([data1 isEqual:data2])
    {
        NSLog(@"=");
    }
    
    
}

- (void)openFile1
{
    /*
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/test.png"];
    self.docCpntroller = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
    self.docCpntroller.delegate = self;
    
    CGRect navRect =self.navigationController.navigationBar.frame;
    navRect.size =CGSizeMake(1500.0f,40.0f);
    
    //显示包含预览的菜单项
    //[self.docCpntroller presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
    
    //显示不包含预览菜单项
    [self.docCpntroller presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
    */
    
    NSLog(@"--------start");

    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"zip"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *localPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/test.pdf"];
    m_progressView.progress = 0.0;

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
         BOOL success = [data writeToFile:localPath atomically:YES];
         NSLog(@"--------%d", success);
     });
     
     
     [self writeBigFileToLocalPath:localPath fileSize:data.length progress:^(float progress) {
     
         [m_progressView setProgress:progress animated:YES];
     }];
}


- (void)openFile2
{
    /*
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/test.png"];
    self.docCpntroller = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
    self.docCpntroller.delegate = self;
    
    [self.docCpntroller presentPreviewAnimated:YES];
    */
    NSLog(@"--------start");
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"zip"];
    NSString *localPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/test.pdf"];
    m_progressView.progress = 0.0;

    [self copyFileFromPath:path toPath:localPath progress:^(float progress) {
        [m_progressView setProgress:progress animated:YES];
        
        if (progress == 1.0)
        {
            NSDictionary *fileAttrs = [[NSFileManager defaultManager] attributesOfItemAtPath:localPath error:nil];
            NSLog(@"%@", fileAttrs);
        }
    }];
    
}

- (void)writeBigFileToLocalPath:(NSString *)path fileSize:(long long)size progress:(void (^)(float progress))update
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *fileAttrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        NSInteger fileSize = [[fileAttrs objectForKey:NSFileSize] intValue];
        
        do {
            
//            [NSThread sleepForTimeInterval:0.5];
            
            fileAttrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            fileSize = [[fileAttrs objectForKey:NSFileSize] intValue];
            
            float progress = (fileSize*1.0)/(size*1.0);
            
            NSLog(@"%ld---%lld===进度：%f", fileSize, size, progress);
            
            dispatch_sync(dispatch_get_main_queue(), ^()
            {
                update(progress);
            });
            
        } while (fileSize < size);
        
    });
}


-(void)copyFileFromPath:(NSString *)path1 toPath:(NSString *)path2 progress:(void (^)(float progress))update
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileHandle * fh1 = [NSFileHandle fileHandleForReadingAtPath:path1];//读到内存
        [[NSFileManager defaultManager] createFileAtPath:path2 contents:nil attributes:nil];//写之前必须有该文件
        NSFileHandle * fh2 = [NSFileHandle fileHandleForWritingAtPath:path2];//写到文件
        NSData * _data = nil;
        unsigned long long ret = [fh1 seekToEndOfFile];//返回文件大小
        if (ret < 1024 * 1024 * 5) {//小于5M的文件一次读写
            [fh1 seekToFileOffset:0];
            _data = [fh1 readDataToEndOfFile];
            [fh2 writeData:_data];
        }else{
            NSUInteger n = ret / (1024 * 1024 * 5);
            if (ret % (1024 * 1024 * 5) != 0) {
                n++;
            }
            NSUInteger offset = 0;
            NSUInteger size = 1024 * 1024 * 5;
            for (NSUInteger i = 0; i < n - 1; i++) {
                //大于5M的文件多次读写
                [fh1 seekToFileOffset:offset];
                @autoreleasepool {
                    /*该自动释放池必须要有否则内存一会就爆了
                     原因在于readDataOfLength方法返回了一个自动释放的对象,它只能在遇到自动释放池的时候才释放.如果不手动写这个自动释放池,会导致_data指向的对象不能及时释放,最终导致内存爆了.
                     */
                    _data = [fh1 readDataOfLength:size];
                    unsigned long long e = [fh2 seekToEndOfFile];
                    [fh2 writeData:_data];
                    NSLog(@"%lu/%lu", i + 1, n - 1);
                    
                    float progress = (e*1.0)/(ret*1.0);
                    NSLog(@"%ld---%lld===进度：%f", e, ret, progress);
                    dispatch_sync(dispatch_get_main_queue(), ^()
                                  {
                                      update(progress);
                                  });
                }
                offset += size;
            }
            //最后一次剩余的字节
            [fh1 seekToFileOffset:offset];
            _data = [fh1 readDataToEndOfFile];
            unsigned long long e = [fh2 seekToEndOfFile];
            [fh2 writeData:_data];
            
            float progress = (e*1.0)/(ret*1.0);
            NSLog(@"%ld---%lld===进度：%f", e, ret, progress);
            dispatch_sync(dispatch_get_main_queue(), ^()
                          {
                              update(progress);
                          });
        }
        [fh1 closeFile];
        [fh2 closeFile];
        
        dispatch_sync(dispatch_get_main_queue(), ^()
                      {
                          update(1.0);
                          NSLog(@"finish");
                      });
    });
}

- (void)openFile3
{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/test.png"];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[path] applicationActivities:nil];
    
    // 不想展示哪个就把那个写在数组中
    activity.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypePostToVimeo];
    
    // incorrect usage
    // [self.navigationController pushViewController:activity animated:YES];
    
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover) {
//        popover.sourceView = self.activityButton;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [self presentViewController:activity animated:YES completion:NULL];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return  self.view.frame;
}

//点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    
}

- (void)didNavOneBtnClick:(UIBarButtonItem *)item
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.duration = 0.25;
    anim.values = @[@(1.2),@(0.8),@(1.1),@(0.9),@(1.0)];
    [self.view.layer addAnimation:anim forKey:@""];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1];
    
    UILabel *detailLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 45)];
    [detailLb setFont:[UIFont systemFontOfSize:14]];
    [detailLb setTextAlignment:NSTextAlignmentLeft];
    [detailLb setTextColor:[UIColor colorWithRed:87.f/255.f green:87.f/255.f blue:87.f/255.f alpha:1]];
    [view addSubview:detailLb];
    detailLb.numberOfLines = 0;
    
    if (section == 2)
    {
        detailLb.text = @"Shake your device to close CoverMe and go back to the home screen.";
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 20;
    
    if (section == 2)
    {
        height = 60;
    }
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [dataArr objectAtIndex:section];
    return arr.count;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    NSArray *arr = [dataArr objectAtIndex:indexPath.section];
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    switch (indexPath.section)
    {
        case 0:
        {
            UISwitch *switchFlag = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 78 - 10, 8, 78, 28)];
            [switchFlag setOn:NO];
            cell.accessoryView = switchFlag;
            
            if (indexPath.row == 0)
            {
                [switchFlag addTarget:self action:@selector(gestureSwitchAction:) forControlEvents:UIControlEventValueChanged];
            }
            else if (indexPath.row == 1)
            {
                [switchFlag addTarget:self action:@selector(touchSwitchAction:) forControlEvents:UIControlEventValueChanged];
                
                cell.imageView.image = [UIImage imageNamed:@"touchID_green.png"];
            }
            else if (indexPath.row == 2)
            {
                switchFlag.on = YES;
                [switchFlag addTarget:self action:@selector(wordSwitchAction:) forControlEvents:UIControlEventValueChanged];
            }
            
            break;
        }
        case 1:
        {
            UIImageView *accessoryImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_access.png"]];
            cell.accessoryView = accessoryImg;
            
            break;
        }
        case 2:
        {
            UISwitch *switchFlag = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 78 - 10, 8, 78, 28)];
            [switchFlag addTarget:self action:@selector(shakeSwitchAction) forControlEvents:UIControlEventValueChanged];
            [switchFlag setOn:NO];
            cell.accessoryView = switchFlag;
            
            break;
        }
        case 3:
        {
            UIImageView *accessoryImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_access.png"]];
            cell.accessoryView = accessoryImg;
            break;
        }
        case 4:
        {
            if (indexPath.row == 0)
            {
                UISwitch *switchFlag = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 78 - 10, 8, 78, 28)];
                [switchFlag addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
                [switchFlag setOn:NO];
                cell.accessoryView = switchFlag;
            }
            else
            {
                UIImageView *accessoryImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_access.png"]];
                cell.accessoryView = accessoryImg;
            }
            
            break;
        }
        case 5:
        case 6:
        {
            UIImageView *accessoryImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_access.png"]];
            cell.accessoryView = accessoryImg;
            
            break;
        }
        case 7:
        {
            cell.accessoryView = nil;
            cell.textLabel.textColor = [UIColor redColor];

            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)gestureSwitchAction:(UISwitch *)switchBtn
{
//    switchBtn.on = !switchBtn.on;
    
    UITableViewCell *touchcell = [m_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UISwitch *touchSwitch = (UISwitch *)touchcell.accessoryView;
    
    UITableViewCell *wordcell = [m_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UISwitch *wordSwitch = (UISwitch *)wordcell.accessoryView;
    
    if (switchBtn.on)
    {
        touchSwitch.on = NO;
        wordSwitch.on = NO;
        
        LockController *lockController = [[LockController alloc]init];
        [self presentViewController:lockController animated:YES completion:NULL];
    }
}

- (void)touchSwitchAction:(UISwitch *)switchBtn
{
//    switchBtn.on = !switchBtn.on;
    
    UITableViewCell *gesturecell = [m_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UISwitch *gestureSwitch = (UISwitch *)gesturecell.accessoryView;
    
    UITableViewCell *wordcell = [m_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UISwitch *wordSwitch = (UISwitch *)wordcell.accessoryView;
    
    if (switchBtn.on)
    {
        gestureSwitch.on = NO;
        wordSwitch.on = NO;
        
        [self authrizeAction1];
    }
}

- (void)wordSwitchAction:(UISwitch *)switchBtn
{
//    switchBtn.on = !switchBtn.on;
    
    UITableViewCell *gesturecell = [m_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UISwitch *gestureSwitch = (UISwitch *)gesturecell.accessoryView;

    UITableViewCell *touchcell = [m_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UISwitch *touchSwitch = (UISwitch *)touchcell.accessoryView;
    
    if (switchBtn.on)
    {
        touchSwitch.on = NO;
        gestureSwitch.on = NO;
    }
}

- (void)switchAction
{
    
}

- (void)shakeSwitchAction
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key_shakeFlag];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section)
    {
        case 0:
        {
            
            break;
        }
        case 1:
        {
            
            break;
        }
        case 2:
        {
            
            break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            
            break;
        }
        case 5:
        case 6:
        {
            break;
        }
        case 7:
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passwordone"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key_shakeFlag];

            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
            
        default:
            break;
    }

}

- (void)authrizeAction
{
    
    
    //这个 demo 是以目前的支付宝为例子写的
    
    if ([NSString judueIPhonePlatformSupportTouchID])
    {
        [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
        
    }
    else
    {
        NSLog(@"您的设置硬件暂时不支持指纹识别");
    }
    
}

- (void)startTouchIDWithPolicy:(LAPolicy )policy
{
    
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"输入密码";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:policy localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        //SVProgressHUD dismiss 需要 0.15才会消失;所以dismiss 后进行下一步操作;但是0.3是适当延长时间;留点余量
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (success)
            {
                NSLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //成功操作--马上调用纯指纹验证方法
                    
                    if (policy == LAPolicyDeviceOwnerAuthentication)
                    {
                        [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
                    }
                    else
                    {
                        
                    }
                    
                });
            }
            
            if (error) {
                //指纹识别失败，回主线程更新UI
                NSLog(@"指纹识别成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败操作
                    [self handelWithError:error];
                    
                });
            }
        });
    }];
    
}



/**
 处理错误数据
 
 @param error 错误信息
 */
- (void)handelWithError:(NSError *)error{
    
    if (error) {
        
        NSLog(@"%@",error.domain);
        NSLog(@"%zd",error.code);
        NSLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
        
        LAError errorCode = error.code;
        switch (errorCode) {
                
            case LAErrorTouchIDLockout: {
                //touchID 被锁定--ios9才可以
                
                [self handleLockOutTypeAliPay];
                
                
                break;
            }
        }
    }
}



/**
 支付宝处理锁定
 */
- (void)handleLockOutTypeAliPay{
    
    //开启验证--调用非全指纹指纹验证
    [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthentication];
    
}


#pragma mark - 最基本使用的 Demo

- (void)authrizeAction1 {
    
    if([NSString judueIPhonePlatformSupportTouchID]){
        
        [self BaseDemo];
        
    }else{
        
        NSLog(@"您的设置硬件不支持指纹识别");
    }
}

- (void)BaseDemo{
    
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"输入密码";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        //SVProgressHUD dismiss 需要 0.15才会消失;所以dismiss 后进行下一步操作;但是0.3是适当延长时间;留点余量
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (success)
            {
                NSLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //成功操作
                    
                    UIAlertView *resetalertview = [[UIAlertView alloc]initWithTitle:@"指纹识别成功" message:@"指纹识别成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [resetalertview show];

                });
            }
            
            if (error) {
                //指纹识别失败，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败操作
                    LAError errorCode = error.code;
                    switch (errorCode) {
                            
                        case LAErrorAuthenticationFailed:
                        {
                            NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                        }
                            break;
                        case LAErrorUserCancel: // Authentication was canceled by user (e.g. tapped Cancel button)
                        {
                            NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮
                        }
                            break;
                        case LAErrorUserFallback: // Authentication was canceled, because the user tapped the fallback button (Enter Password)
                        {
                            NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                        }
                            break;
                        case LAErrorSystemCancel: // Authentication was canceled by system (e.g. another application went to foreground)
                        {
                            NSLog(@"取消授权，如其他应用切入"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                        }
                            break;
                        case LAErrorPasscodeNotSet: // Authentication could not start, because passcode is not set on the device.
                            
                        {
                            NSLog(@"设备系统未设置密码"); // -5
                        }
                            break;
                        case LAErrorTouchIDNotAvailable: // Authentication could not start, because Touch ID is not available on the device
                        {
                            NSLog(@"设备未设置Touch ID"); // -6
                            
                            UIAlertView *resetalertview = [[UIAlertView alloc]initWithTitle:@"指纹识别失败" message:@"设备未设置Touch ID" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                            [resetalertview show];

                        }
                            break;
                        case LAErrorTouchIDNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                        {
                            NSLog(@"用户未录入指纹"); // -7
                            
                            UIAlertView *resetalertview = [[UIAlertView alloc]initWithTitle:@"指纹识别失败" message:@"用户未录入指纹" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                            [resetalertview show];
                        }
                            break;
                        case LAErrorTouchIDLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                        {
                            NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        }
                            break;
                        case LAErrorAppCancel: // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
                        {
                            NSLog(@"用户不能控制情况下APP被挂起"); // -9
                        }
                            break;
                        case LAErrorInvalidContext: // LAContext passed to this call has been previously invalidated.
                        {
                            NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                        }
                            break;
                    }
                    
                });
            }
        });
    }];
    
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:key_shakeFlag])
        {
            exit(0);
        }
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


/*
 1. google analytics:
 账号：qq邮箱
 
 https://analytics.google.com/analytics/web/?hl=zh-CN#embed/report-home/a112271169w167343202p167602249/
 
 左下测 管理 -> 媒体资源 -> 跟踪代码 -> iOS SDK入门指南
 
 文档：
 https://developers.google.com/analytics/devguides/collection/ios/v3/
 
 
 
 2. crashlytic:
 账号：qq邮箱
 https://fabric.io/kits?show_signup=true&utm_campaign=fabric-marketing&utm_medium=natural
 
 
 
 文档：https://fabric.io/kits/ios/crashlytics/install
 
 */

