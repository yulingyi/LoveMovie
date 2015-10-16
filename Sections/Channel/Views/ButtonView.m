//
//  ButtonView.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ButtonView.h"
#import "TypeVideoViewController.h"


#define KWIDTH self.frame.size.width / 3
#define KHIGHT self.frame.size.height
@interface ButtonView ()

@property (nonatomic, retain) NSMutableArray * buttonAry;

@end

@implementation ButtonView

- (void)dealloc
{
    self.buttonAry = nil;
    self.delegate = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getButton];
    }
    return self;
}

- (NSMutableArray *)buttonAry
{
    if (_buttonAry == nil) {
        self.buttonAry = [@[] mutableCopy];
    }
    return [[_buttonAry retain] autorelease];
}

- (void)getButton
{
    NSArray * titleAry = @[@"最新", @"最热", @"评论"];
    for (int i = 0; i < titleAry.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(KWIDTH * i + 20, 0, KWIDTH - 40, 50);
        [button setTitle:titleAry[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1]];
        [button.layer setCornerRadius:10];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
        [self addSubview:button];
        [self.buttonAry addObject:button];
    }
}

- (void)clickButton:(UIButton *)sender
{
    for (UIButton * but in self.buttonAry) {
        but.tag == sender.tag ? [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal] : [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    [self.delegate buttonClicked:sender];
}





@end
