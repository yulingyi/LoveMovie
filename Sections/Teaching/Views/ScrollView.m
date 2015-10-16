//
//  ScrollView.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ScrollView.h"

@interface ScrollView ()<UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray * titleAry;

@end


@implementation ScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.TopScrollView];
        [self addSubview:self.centerScrollView];
    }
    return self;
}

#pragma mark - lazyloading
- (NSMutableArray *)titleAry
{
    if (_titleAry == nil) {
        self.titleAry = [@[@"推荐", @"剧作教程", @"微影拍摄", @"影视后期", @"拍摄器材"] mutableCopy];
        
    }
    return [[_titleAry retain] autorelease];
}

- (NSMutableArray *)buttonAry
{
    if (_buttonAry == nil) {
        self.buttonAry = [@[] mutableCopy];
    }
    return [[_buttonAry retain] autorelease];
}

- (UIScrollView *)TopScrollView
{
    if (_TopScrollView == nil) {
        self.TopScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _TopScrollView.contentSize = CGSizeMake(_TopScrollView.frame.size.width / 4 * 5, _TopScrollView.frame.size.height);
        self.TopScrollView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < 5; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:self.titleAry[i] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(self.TopScrollView.frame.size.width / 4 * i, 0, self.TopScrollView.frame.size.width / 4, 50)];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.tag = 1000 + i;
            [self.buttonAry addObject:button];
            [self.TopScrollView addSubview:button];
            
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.buttonAry[0] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return [[_TopScrollView retain] autorelease];
}

- (UIScrollView *)centerScrollView
{
    if (_centerScrollView == nil) {
        self.centerScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.TopScrollView.frame.size.height, self.frame.size.width, self.frame.size.height - self.TopScrollView.frame.size.height)] autorelease];
        _centerScrollView.contentSize = CGSizeMake(_centerScrollView.frame.size.width * 5, _centerScrollView.frame.size.height);
        _centerScrollView.pagingEnabled = YES;
        _centerScrollView.delegate = self;
       
    }
    return [[_centerScrollView retain] autorelease];
}


#pragma mark = button关联方法
- (void)buttonClick:(UIButton *)sender
{
    [self.centerScrollView setContentOffset:CGPointMake(self.centerScrollView.frame.size.width * (sender.tag - 1000), 0)];
    [self changeColorWithButton:sender];
    if (sender.tag > 1000 && sender.tag < 1003) {
       
            self.TopScrollView.contentOffset = CGPointMake((sender.tag - 1001) * self.TopScrollView.frame.size.width / 4, 0);
     
    }
   }

- (void)changeColorWithButton:(UIButton *)sender
{
        for (UIButton * but in self.buttonAry) {
        if (but.tag == sender.tag) {
            [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}


#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIButton * but1 = self.buttonAry[(NSInteger)(_centerScrollView.contentOffset.x / _centerScrollView.frame.size.width)];
    [self changeColorWithButton:but1];
    if (but1.tag > 1000 && but1.tag < 1003) {
       
            self.TopScrollView.contentOffset = CGPointMake((but1.tag - 1001) * self.TopScrollView.frame.size.width / 4, 0);
        
    }
}




@end
