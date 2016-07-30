//
//  ShareViewController.m
//  RealmShare
//
//  Created by Mac on 16/7/30.
//  Copyright © 2016年 com.luohaifang. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ShareModel.h"
#import "UtikIesTool.h"
#import "Identity.h"
#import "ShareErrorController.h"
#import "ShareSelectController.h"

@interface ShareViewController () {
    ShareModel *model;
    UINavigationController *shareNav;
}

@end

@implementation ShareViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [ShareModel shareInstance];
    //创建遮罩视图
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    backGroundView.backgroundColor = [UIColor blackColor];
    backGroundView.alpha = 0.5;
    [self.view addSubview:backGroundView];
    //获取inputItems，在这里itemProvider是你要分享的图片
    NSExtensionItem *firstItem = self.extensionContext.inputItems.firstObject;
    for (NSItemProvider *itemProvider in firstItem.attachments) {
        //这里的kUTTypeURL代指网站链接，如在Safari中打开，则应该拷贝保存当前网页的链接
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                if (!error) {
                    //对itemProvider夹带着的URL进行解析
                    NSURL *url = (NSURL *)item;
                    model.shareUrl = url.absoluteString;
                }
            }];
        }
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeText]) {
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeText options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                if (!error) {
                    //对itemProvider夹带着的图片进行解析
                    NSString *url = (NSString *)item;
                    model.shareText = url;
                }
            }];
        }
    }
    //应用组间共享数据
    NSUserDefaults *sharedDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.lottak.bangbang"];
    Identity *identity = [sharedDefault valueForKey:@"GroupIdentityInfo"];
    if(identity.accessToken)
    {
        shareNav = [[UINavigationController alloc] initWithRootViewController:[ShareSelectController new]];
        model.shareToken = identity.accessToken;
    }
    else
        shareNav = [[UINavigationController alloc] initWithRootViewController:[ShareErrorController new]];
    shareNav.view.frame = CGRectMake(0.5 * (CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT).size.width - 250), 0.5 * (CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT).size.height - 330), MAIN_SCREEN_WIDTH, 330);
    [self addChildViewController:shareNav];
    [self.view addSubview:shareNav.view];
}
@end
