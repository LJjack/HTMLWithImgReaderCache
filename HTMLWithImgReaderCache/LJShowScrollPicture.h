//
//  LJShowScrollPicture.h
//  HTMLWithImgReaderCache
//
//  Created by liujunjie on 15-8-13.
//  Copyright (c) 2015年 rj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJShowScrollPicture : UIView
@property (copy,nonatomic) NSArray *allImages;
@property (assign,nonatomic) NSInteger index;
@property (assign,nonatomic) CGRect picFrame;

- (void)clickPicture;
@end
