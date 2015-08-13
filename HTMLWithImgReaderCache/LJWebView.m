//
//  LJWebView.m
//  HTMLWithImgReaderCache
//
//  Created by liujunjie on 15-8-12.
//  Copyright (c) 2015年 rj. All rights reserved.
//
#import "SDWebImageManager.h"
#import "WebViewJavascriptBridge.h"
#import "LJWebView.h"

@interface LJWebView ()
@property WebViewJavascriptBridge *bridge;
@property (strong,nonatomic)NSMutableArray *allImages;
@end
@implementation LJWebView

- (void)lj_HTMLOnLoadTheNativeCacheWithURL:(NSURL *)url {
    
    NSString *startHTML = @"<!DOCTYPE html>\
    <html>\
    <head>\
    <meta charset=\"utf-8\" />\
    <title>UIWebView与JS的深度交互</title>\
    <style type='text/css'>\
    img {width:300px;height:300px}\
    </style>\
    </head>\
    <body onload=\"onLoaded()\">";
    NSString *endHTML = @"</body></html>";
    
    NSError __autoreleasing *error;
    NSString *html = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    html = [html stringByReplacingOccurrencesOfString:@"src" withString:@"esrc"];
    html = [[startHTML stringByAppendingString:html] stringByAppendingString:endHTML];
    __weak typeof(self) wSelf = self;
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self webViewDelegate:nil handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isKindOfClass:[NSArray class]]) {
            [wSelf downloadAllImagesInNative:(NSArray *)data];
        }
    }];
    html = [html stringByReplacingOccurrencesOfString:@"<img esrc" withString:@"<img  onClick=\"javascript:onImageClick(this)\" esrc"];
    [_bridge registerHandler:@"imageDidClicked" handler:^(NSDictionary *dict, WVJBResponseCallback responseCallback) {
        if ([_imgDelegate respondsToSelector:@selector(webViewOnHTMLAllImage:selectedDict:)]) {
            [_imgDelegate webViewOnHTMLAllImage:_allImages selectedDict:dict];
        }

        
        
    }];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"js"];
    NSString *js =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
   
    [self stringByEvaluatingJavaScriptFromString:js];
    [self loadHTMLString:html baseURL:nil];
    
}
#pragma mark -点击图片
- (void)onImageClickWithURL:(NSString *)html {
   
}

#pragma mark -下载全部图片
- (void)downloadAllImagesInNative:(NSArray *)imageUrls {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    _allImages = [NSMutableArray arrayWithCapacity:imageUrls.count];
    for (NSUInteger i = 0; i < imageUrls.count; i ++) {
        NSString *_url = imageUrls[i];
        NSString *qinUrl = @"http://192.168.254.78:8080/seeImg/";
        _url = [qinUrl stringByAppendingString:_url];

        [manager downloadImageWithURL:[NSURL URLWithString:_url] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [_allImages addObject:image];
                    NSString *imgB64 = [UIImageJPEGRepresentation(image, 1.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    //把图片在磁盘中的地址传回给JS
                    NSString *key = [manager cacheKeyForURL:imageURL];
                    key = [key substringFromIndex:qinUrl.length];
                    NSString *source = [NSString stringWithFormat:
                                        @"data:image/png;base64,%@",imgB64];
                    [_bridge callHandler:@"imagesDownloadComplete" data:@[key,source]];
                });
            }
        }];
    }
}
@end

