//
//  HeaderCollectionReusableView.m
//  VMovie
//
//  Created by laouhn on 15/9/14.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "HeaderCollectionReusableView.h"
#import "SDCycleScrollView.h"
@interface HeaderCollectionReusableView ()

@property (nonatomic,retain) UILabel * label;


@end


@implementation HeaderCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.label];
        
        [self addSubview:self.leftLabel];

     
        
    }
    return self;
}


- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        self.leftLabel = [[[UILabel alloc] initWithFrame:CGRectMake( 20, 0, 100, self.frame.size.height)] autorelease];
      
    }
    return [[_leftLabel retain] autorelease];
}

- (UILabel *)label
{
    if (!_label) {
        self.label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 2, 20)] autorelease];
        _label.backgroundColor = [UIColor grayColor];
    }
    return [[_label retain] autorelease];
}

- (void)dealloc
{
    self.label = nil;
    self.leftLabel  = nil;
    
    [super dealloc];
}

@end
