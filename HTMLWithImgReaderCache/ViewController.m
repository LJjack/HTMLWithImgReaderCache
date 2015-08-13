//
//  ViewController.m
//  HTMLWithImgReaderCache
//
//  Created by liujunjie on 15-8-11.
//  Copyright (c) 2015年 rj. All rights reserved.
//

#import "ViewController.h"
#import "LJShowScrollPicture.h"
#import "LJWebView.h"
@interface ViewController ()<LJWebViewDelegate>

@property (weak, nonatomic) IBOutlet LJWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pathURL = @"http://192.168.254.78:8080/seeImg/hello.html";
    [self.webView lj_HTMLOnLoadTheNativeCacheWithURL:[NSURL URLWithString:pathURL]];
    [self.webView setImgDelegate:self];
    
}
- (void)webViewOnHTMLAllImage:(NSArray *)allImage selectedDict:(NSDictionary *)dict{

    NSInteger x      = [dict[@"x"] integerValue];
    NSInteger y      = [dict[@"y"] integerValue];
    NSInteger width  = [dict[@"width"] integerValue];
    NSInteger height = [dict[@"height"] integerValue];
    LJShowScrollPicture *showSPView = [[LJShowScrollPicture alloc] init];
    showSPView.allImages = allImage;
    showSPView.picFrame = CGRectMake(x, y, width, height);
    showSPView.index = [dict[@"index"] integerValue];
    [self.view addSubview:showSPView];
    [showSPView clickPicture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
