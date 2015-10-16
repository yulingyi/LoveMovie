//
//  DetailVIew.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "DetailVIew.h"
#import "AFNetworking.h"


#define kWidth [UIScreen mainScreen].bounds.size.width

@interface DetailVIew ()

@property (nonatomic, retain) UILabel * titleLabel;
@property (nonatomic, retain) UILabel * actorsLabel;
@property (nonatomic, retain) UILabel * directorsLabel;
@property (nonatomic, retain) UILabel * yearLabel;
@property (nonatomic, retain) UILabel * zoneLabel;
@property (nonatomic, retain) UILabel * introductionLabel;

@property (nonatomic, retain) UILabel * titleLb;
@property (nonatomic, retain) UILabel * actorsLb;
@property (nonatomic, retain) UILabel * directorsLb;
@property (nonatomic, retain) UILabel * yearLb;
@property (nonatomic, retain) UILabel * zoneLb;
@property (nonatomic, retain) UILabel * introductionLb;

@end


@implementation DetailVIew



- (void)dealloc
{
    self.titleLabel = nil;
    self.actorsLabel = nil;
    self.directorsLabel = nil;
    self.yearLabel = nil;
    self.zoneLabel = nil;
    self.introductionLabel = nil;
    self.video = nil;
    self.titleLb = nil;
    self.actorsLb = nil;
    self.directorsLb = nil;
    self.yearLb = nil;
    self.zoneLb = nil;
    self.introductionLb = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame video:(VideoModel *)video
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.actorsLabel];
        [self addSubview:self.directorsLabel];
        [self addSubview:self.yearLabel];
        [self addSubview:self.zoneLabel];
        [self addSubview:self.introductionLabel];
        
        [self addSubview:self.titleLb];
        [self addSubview:self.actorsLb];
        [self addSubview:self.directorsLb];
        [self addSubview:self.yearLb];
        [self addSubview:self.zoneLb];
        [self addSubview:self.introductionLb];
        
        self.video = video;
    }
    return self;
}


- (void)setVideo:(VideoModel *)video
{
    if (_video != video) {
        [_video release];
        _video = [video retain];
    }
    self.titleLabel.text = video.title;
    self.actorsLabel.text = video.actors;
    self.directorsLabel.text = video.directors;
    self.yearLabel.text = video.year;
    self.zoneLabel.text = video.zone;
    self.introductionLabel.text = video.introduction;
    self.introductionLabel.frame = CGRectMake(45, 175, kWidth - 45, [self callhight:_video]);
    
    
}



#pragma mark - 网络数据
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 0, kWidth - 45, 30)] autorelease];
    }
    return [[_titleLabel retain] autorelease];
}
- (UILabel *)actorsLabel
{
    if (!_actorsLabel) {
        self.actorsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 35, kWidth - 45, 30)] autorelease];
    }
    return [[_actorsLabel retain] autorelease];
}

- (UILabel *)directorsLabel
{
    if (!_directorsLabel) {
        self.directorsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 70, kWidth - 45, 30)] autorelease];
    }
    return [[_directorsLabel retain] autorelease];
}
- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        self.yearLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 105, kWidth - 45, 30)] autorelease];
    }
    return [[_yearLabel retain] autorelease];
}

- (UILabel *)zoneLabel
{
    if (!_zoneLabel) {
        self.zoneLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 140, kWidth - 45, 30)] autorelease];
    }
    return [[_zoneLabel retain] autorelease];
}

- (UILabel *)introductionLabel
{
    if (!_introductionLabel) {
        self.introductionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 175, kWidth - 45, kWidth * 2 - 175)] autorelease];
        self.introductionLabel.textAlignment = 4;
        self.introductionLabel.numberOfLines = 0;
    }
    return [[_introductionLabel retain] autorelease];
}

/**
 *  此方法用于计算cell的高度
 */
- (CGFloat)callhight:(VideoModel *)video
{
    
    /*   NSString的对象方法 boundingRectWithSize:....
     
     1. 用于计算给定的某段文本, 在某种字体和字号下, 在某个范围之内根据不同的断行方式要正常显示需要的高度
     参数1: 参考显示范围(注意宽度给正确, 高度随意)
     参数2: 断行方式(以下代码中的值, 计算结果是较准确的, 视情况自己定)
     参数3: 字体字号(注意: 和最终所在label的字号一定要一致)
     参数4: nil
     */
    self.rect = [video.introduction boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width - 40, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    return _rect.size.height;
}

#pragma mark -
- (UILabel *)titleLb
{
    if (!_titleLb) {
        self.titleLb = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 55, 30)] autorelease];
        self.titleLb.text = @"影片名:";
    }
    return [[_titleLb retain] autorelease];
}

- (UILabel *)actorsLb
{
    if (!_actorsLb) {
        self.actorsLb = [[[UILabel alloc] initWithFrame:CGRectMake(5, 35, 40, 30)] autorelease];
        self.actorsLb.text = @"主演:";
    }
    return [[_actorsLb retain] autorelease];
}

- (UILabel *)directorsLb
{
    if (!_directorsLb) {
        self.directorsLb = [[[UILabel alloc] initWithFrame:CGRectMake(5, 70, 40, 30)] autorelease];
        self.directorsLb.text = @"导演:";
    }
    return [[_directorsLb retain] autorelease];
}
- (UILabel *)yearLb
{
    if (!_yearLb) {
        self.yearLb = [[[UILabel alloc] initWithFrame:CGRectMake(5, 105, 40, 30)] autorelease];
        self.yearLb.text = @"年份:";
    }
    return [[_yearLb retain] autorelease];
}

- (UILabel *)zoneLb
{
    if (!_zoneLb) {
        self.zoneLb = [[[UILabel alloc] initWithFrame:CGRectMake(5, 140, 40, 30)] autorelease];
        self.zoneLb.text = @"地区:";
    }
    return [[_zoneLb retain] autorelease];
}

- (UILabel *)introductionLb
{
    if (!_introductionLb) {
        self.introductionLb = [[[UILabel alloc] initWithFrame:CGRectMake(5, 170, 40, 30)] autorelease];
        self.introductionLb.text = @"简介:";
    }
    return [[_introductionLb retain] autorelease];
}


@end
