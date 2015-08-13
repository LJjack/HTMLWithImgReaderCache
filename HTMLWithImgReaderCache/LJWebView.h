//
//  LJWebView.h
//  HTMLWithImgReaderCache
//
//  Created by liujunjie on 15-8-12.
//  Copyright (c) 2015年 rj. All rights reserved.
//
/*
 1、如何让HTML文本onLoad的时候，禁用自身的图片加载而是从本地获取图片？2、如何把native端下载好的图片返回给网页？
 */

#import <UIKit/UIKit.h>
@protocol LJWebViewDelegate <NSObject>

- (void)webViewOnHTMLAllImage:(NSArray *)allImage selectedDict:(NSDictionary *)dict;

@end
@interface LJWebView : UIWebView
/*
 * html加载本地缓存图片
 * 第一次加载html：先把html的图片缓存到本地，再把缓存的图片添加到html上；
 * 第二次加载html：直接把缓存中的图片添加到html。
 * @param url 是html 的url
 */
- (void)lj_HTMLOnLoadTheNativeCacheWithURL:(NSURL *)url;
@property (weak,nonatomic)id<LJWebViewDelegate> imgDelegate;
@end
