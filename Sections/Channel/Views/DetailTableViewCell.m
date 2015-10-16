//
//  DetailTableViewCell.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "DetailTableViewCell.h"

#define SWIDTH self.frame.size.width
#define SHEIGHT self.frame.size.height
#define KHEIGHT self.dTitleLabel.frame.size.height
#define KWIDTH self.dTitleLabel.frame.size.width

@interface DetailTableViewCell ()

@property (nonatomic, retain) UILabel * dTitleLabel;
@property (nonatomic, retain) UILabel * dScoreLabel;
@property (nonatomic, retain) UILabel * dSubTitleLabel;
@property (nonatomic, retain) UILabel * dDirectorLabel;
@property (nonatomic, retain) UILabel * dWriterLabel;
@property (nonatomic, retain) UILabel * dActorsLabel;
@property (nonatomic, retain) UILabel * dTypeLabel;
@property (nonatomic, retain) UILabel * dZoneLabel;
@property (nonatomic, retain) UILabel * dYearLabel;
@property (nonatomic, retain) UILabel * dIntroductionLabel;

@end


@implementation DetailTableViewCell

- (void)dealloc
{
    self.detailModel = nil;
    self.dTitleLabel = nil;
    self.dIntroductionLabel = nil;
    self.dScoreLabel = nil;
    self.dSubTitleLabel = nil;
    self.dTypeLabel = nil;
    self.dWriterLabel = nil;
    self.dYearLabel = nil;
    self.dZoneLabel = nil;

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dTitleLabel];
        [self addSubview:self.dScoreLabel];
        [self addSubview:self.dSubTitleLabel];
        [self addSubview:self.dDirectorLabel];
        [self addSubview:self.dWriterLabel];
        [self addSubview:self.dActorsLabel];
        [self addSubview:self.dTypeLabel];
        [self addSubview:self.dZoneLabel];
        [self addSubview:self.dYearLabel];
        [self addSubview:self.dIntroductionLabel];
        
    }
    return self;
}


#pragma mark - lazyloading

- (UILabel *)dTitleLabel
{
    if (_dTitleLabel == nil) {
        self.dTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 0, SWIDTH - 70, 40)] autorelease];
    }
    return [[_dTitleLabel retain] autorelease];
}

- (UILabel *)dScoreLabel
{
    if (_dScoreLabel == nil) {
        self.dScoreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(KWIDTH + 20, 0, 50, 40)] autorelease];
    }
    return [[_dScoreLabel retain] autorelease];
}

- (UILabel *)dSubTitleLabel
{
    if (_dSubTitleLabel == nil) {
        self.dSubTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT, SWIDTH - 10, KHEIGHT)] autorelease];
        _dSubTitleLabel.numberOfLines = 0;
    }
    return [[_dSubTitleLabel retain] autorelease];
}

- (UILabel *)dDirectorLabel
{
    if (_dDirectorLabel == nil) {
        self.dDirectorLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT * 2, SWIDTH, KHEIGHT)] autorelease];
    }
    return [[_dDirectorLabel retain] autorelease];
}

- (UILabel *)dWriterLabel
{
    if (_dWriterLabel == nil) {
        self.dWriterLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT  * 3, SWIDTH, KHEIGHT)] autorelease];
    }
    return [[_dWriterLabel retain] autorelease];
}

- (UILabel *)dActorsLabel
{
    if (_dActorsLabel == nil) {
        self.dActorsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT  * 4, SWIDTH, KHEIGHT)] autorelease];
    }
    return [[_dActorsLabel retain] autorelease];
}

- (UILabel *)dTypeLabel
{
    if (_dTypeLabel == nil) {
        self.dTypeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT * 5 , SWIDTH, KHEIGHT)] autorelease];
    }
    return [[_dTypeLabel retain] autorelease];
}

- (UILabel *)dZoneLabel
{
    if (_dZoneLabel == nil) {
        self.dZoneLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT * 6, SWIDTH, KHEIGHT)] autorelease];
    }
    return [[_dZoneLabel retain] autorelease];
}

- (UILabel *)dYearLabel
{
    if (_dYearLabel == nil) {
        self.dYearLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT * 7 , SWIDTH, KHEIGHT)] autorelease];
    }
    return [[_dYearLabel retain] autorelease];
}

- (UILabel *)dIntroductionLabel
{
    if (_dIntroductionLabel == nil) {
        self.dIntroductionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT * 8, SWIDTH - 20, 200)] autorelease];
       
        _dIntroductionLabel.numberOfLines = 0;
        
    }
    return [[_dIntroductionLabel retain] autorelease];
}


#pragma mark - setter
- (void)setDetailModel:(detailModel *)detailModel
{
    if (_detailModel != detailModel) {
        [_detailModel release];
        _detailModel = [detailModel retain];
    }
    self.dTitleLabel.text = [NSString stringWithFormat:@"片名:%@", _detailModel.title];
    self.dScoreLabel.text = [NSString stringWithFormat:@"%@", _detailModel.score] ;

    self.dSubTitleLabel.text = [NSString stringWithFormat:@"影片简介:%@", _detailModel.videoDescription];
    self.dActorsLabel.text = [NSString stringWithFormat:@"主演:%@", _detailModel.actors];
    self.dDirectorLabel.text = [NSString stringWithFormat:@"导演:%@", _detailModel.directors];
    self.dWriterLabel.text = [NSString stringWithFormat:@"编剧:%@", _detailModel.writers];
    self.dTypeLabel.text = [NSString stringWithFormat:@"类型:%@", [_detailModel.type firstObject]];
    self.dZoneLabel.text = [NSString stringWithFormat:@"地区:%@", _detailModel.zone];
    self.dYearLabel.text = [NSString stringWithFormat:@"年份:%@", _detailModel.year];
    self.dIntroductionLabel.text = [NSString stringWithFormat:@"影片详情:%@", _detailModel.introduction];
    CGRect rect = [_detailModel.introduction boundingRectWithSize:CGSizeMake(SWIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    _dIntroductionLabel.frame = CGRectMake(5, KHEIGHT * 8, SWIDTH - 20, rect.size.height);
    self.contentSize = CGSizeMake(KWIDTH, 330 + rect.size.height);
}


@end
