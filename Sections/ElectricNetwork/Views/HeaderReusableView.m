//
//  HeaderReusableView.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "HeaderReusableView.h"

@interface HeaderReusableView ()

@property (nonatomic, retain) UILabel * label;

@end

@implementation HeaderReusableView

- (void)dealloc
{
    self.titleSectionLabel = nil;
    self.label = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleSectionLabel];
        [self addSubview:self.label];
    }
    return self;
}


- (UILabel *)titleSectionLabel
{
    if (_titleSectionLabel == nil) {
        self.titleSectionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)] autorelease];
    }
    return [[_titleSectionLabel retain] autorelease];
}

- (UILabel *)label
{
    if (!_label) {
        self.label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 2, 20)] autorelease];
        self.label.backgroundColor = [UIColor grayColor];
    }
    return [[_label retain] autorelease];
}


@end