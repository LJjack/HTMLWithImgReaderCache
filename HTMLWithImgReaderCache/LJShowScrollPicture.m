//
//  LJShowScrollPicture.m
//  HTMLWithImgReaderCache
//
//  Created by liujunjie on 15-8-13.
//  Copyright (c) 2015年 rj. All rights reserved.
//

#import "LJShowScrollPicture.h"
@interface LJShowScrollPicture ()
@property (weak,nonatomic) UIScrollView *scrollView;
@property (weak,nonatomic) UIView *maskingView;
@property (weak,nonatomic) UIImageView *picImageView;
@property (weak,nonatomic) UIButton *backbtn;
@end
@implementation LJShowScrollPicture

- (instancetype)init {
    if (self = [super init]) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
        [self setBackgroundColor:[UIColor clearColor]];
        //1.maskingView
        UIView *maskingView = [[UIView alloc] initWithFrame:frame];
        [maskingView setHidden:YES];
        [maskingView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:maskingView];
        _maskingView = maskingView;
        
        //2.picImageView
        UIImageView *picImageView = [[UIImageView alloc] init];
        [picImageView setHidden:NO];
        [self addSubview:picImageView];
        //3. scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:
                                    CGRectMake(0, 64, frame.size.width, frame.size.height - 64)];
        [scrollView setHidden:YES];
        [scrollView setPagingEnabled:YES];
        
        [self addSubview:scrollView];
        _scrollView = scrollView;
        //4.backBtn
        UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setHidden:YES];
        [backbtn setTitle:@"返回" forState:UIControlStateNormal];
        [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backbtn setFrame:CGRectMake(0, 64, 50, 50)];
        [backbtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backbtn];
        _backbtn = backbtn;
        
        
    }
    return self;
}
#pragma mark - btnClick
- (void)backBtn {
    __weak typeof(self) wSeft = self;
    [UIView animateWithDuration:0.5 animations:^{
        [wSeft.maskingView setHidden:NO];
        [wSeft.backbtn setHidden:NO];
        [wSeft.scrollView setHidden:NO];
        [wSeft.picImageView setHidden:NO];
        [wSeft.picImageView setContentMode:UIViewContentModeScaleAspectFill];
        [wSeft.picImageView setFrame:wSeft.picFrame];
        
    } completion:^(BOOL finished) {
        [wSeft removeFromSuperview];
    }];
}
#pragma mark -方法
- (void)clickPicture {
    [_picImageView setFrame:_picFrame];
    [_picImageView setImage:_allImages[_index]];
    [_picImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    __weak typeof(self) wSeft = self;
    [UIView animateWithDuration:0.5 animations:^{
        [wSeft.picImageView setContentMode:UIViewContentModeScaleAspectFit];
        [wSeft.picImageView setFrame:wSeft.scrollView.bounds];
        
    } completion:^(BOOL finished) {
        [wSeft.maskingView setHidden:NO];
        [wSeft.backbtn setHidden:NO];
        [wSeft.scrollView setHidden:NO];
    }];
    NSInteger imageCount = _allImages.count;
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width*imageCount, 0)];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*_index, 0) animated:NO];
    for (NSInteger i = 0; i < imageCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scrollView.frame];
        
        [imageView setCenter:CGPointMake(_scrollView.frame.size.width*0.5+i*_scrollView.frame.size.width, CGRectGetHeight(_scrollView.frame)*0.5)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:_allImages[i]];
        [_scrollView addSubview:imageView];
    }
    [_picImageView setHidden:YES];
}

@end
