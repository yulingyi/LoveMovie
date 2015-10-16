//
//  MoreButtonView.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "MoreButtonView.h"
#import "TypeVideoViewController.h"

#define KHIGHT self.frame.size.height
#define KWIDTH self.frame.size.width
@interface MoreButtonView ()

@property (nonatomic, retain) UILabel * topLabel;
@property (nonatomic, retain) NSMutableArray * moreButtonAry;

@end

@implementation MoreButtonView

- (void)dealloc
{
    self.delegate = nil;
    self.topLabel = nil;
    self.moreButtonAry = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topLabel];
        [self getMoreButton];
    }
    return self;
}

- (UILabel *)topLabel
{
    if (_topLabel == nil) {
        self.topLabel = [[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 200, 50)] autorelease];
        _topLabel.text = @"更多频道";
    }
    return [[_topLabel retain] autorelease];
}

- (NSMutableArray *)moreButtonAry
{
    if (_moreButtonAry == nil) {
        self.moreButtonAry = [@[] mutableCopy];
    }
    return [[_moreButtonAry retain] autorelease];
}

- (void)getMoreButton
{
    NSArray * titleAry = @[@"爱情", @"校园", @"温情", @"搞笑", @"悬疑", @"励志", @"职场", @"社会", @"刑侦", @"战争", @"古装", @"科幻", @"动作", @"穿越", @"广告", @"公益", @"恐怖", @"文艺", @"记录", @"动画", @"剧情", @"其他"];
    
//    for (int i = 0; i < 5; i++) {
//        for (int j = 0; j < 4; j++) {
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setFrame:CGRectMake(10 + (KWIDTH - 50) / 4 * j, self.topLabel.frame.size.height * (i + 1), (KWIDTH - 50) / 4, 50)];
//            [self addSubview:button];
//            [self.moreButtonAry addObject:button];
//            }
//        }
//    for (int k = 0; k < 2; k++) {
//        UIButton * MoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [MoreButton setFrame:CGRectMake(10 + (KWIDTH - 50) / 4 * k, self.topLabel.frame.size.height * 6, (KWIDTH - 50) / 4, 50)];
//        [self addSubview:MoreButton];
//        [self.moreButtonAry addObject:MoreButton];
//    }

    for (int i = 0; i < titleAry.count ; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1]];
        [button.layer setCornerRadius:10];

        [button setFrame:CGRectMake((i % 4) * (KWIDTH - 20) / 4 + 10, 50 + (i / 4) * 60, (KWIDTH - 40) / 4, 50)];
        [self.moreButtonAry addObject:button];
        [self addSubview:button];
    }
    
    
    for (int i = 0; i < self.moreButtonAry.count; i++) {
        
        [self.moreButtonAry[i] setTag:(1000 + i)];
        [self.moreButtonAry[i] addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.moreButtonAry[i] setTitle:titleAry[i] forState:UIControlStateNormal];
         [self.moreButtonAry[i] setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
}

- (void)clickButton:(UIButton *)sender
{
    for (UIButton * but in self.moreButtonAry) {
        but.tag == sender.tag ? [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal] : [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    [self.delegate getClickedButton:sender];
}






@end
