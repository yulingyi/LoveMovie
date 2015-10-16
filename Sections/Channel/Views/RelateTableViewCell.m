//
//  RelateTableViewCell.m
//  LoveMovie
//
//  Created by laouhn on 15/9/19.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RelateTableViewCell.h"

#define SWIDTH self.frame.size.width
#define SHEIGHT self.frame.size.height
#define KHEIGHT self.dTitleLabel.frame.size.height
#define KWIDTH self.dTitleLabel.frame.size.width
@interface RelateTableViewCell ()

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

@implementation RelateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
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
        self.dTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 10, SWIDTH - 70, 50)] autorelease];
        _dTitleLabel.backgroundColor = [UIColor redColor];
    }
    return [[_dTitleLabel retain] autorelease];
}


- (UILabel *)dSubTitleLabel
{
    if (_dSubTitleLabel == nil) {
        self.dSubTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, KHEIGHT + 10, 50, KHEIGHT)] autorelease];
        
        _dSubTitleLabel.backgroundColor = [UIColor blueColor];
    }
    return [[_dSubTitleLabel retain] autorelease];
}

- (UILabel *)dDirectorLabel
{
    if (_dDirectorLabel == nil) {
        self.dDirectorLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, (KHEIGHT + 10) * 2, SWIDTH, KHEIGHT)] autorelease];
        _dDirectorLabel.backgroundColor = [UIColor grayColor];
    }
    return [[_dDirectorLabel retain] autorelease];
}

- (UILabel *)dWriterLabel
{
    if (_dWriterLabel == nil) {
        self.dWriterLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, (KHEIGHT + 10) * 3, SWIDTH, KHEIGHT)] autorelease];
        _dWriterLabel.backgroundColor = [UIColor yellowColor];
    }
    return [[_dWriterLabel retain] autorelease];
}

- (UILabel *)dActorsLabel
{
    if (_dActorsLabel == nil) {
        self.dActorsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, (KHEIGHT + 10) * 4, SWIDTH, KHEIGHT)] autorelease];
        _dActorsLabel.backgroundColor = [UIColor orangeColor];
    }
    return [[_dActorsLabel retain] autorelease];
}

- (UILabel *)dTypeLabel
{
    if (_dTypeLabel == nil) {
        self.dTypeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, (KHEIGHT + 10) * 5, SWIDTH, KHEIGHT)] autorelease];
        _dTypeLabel.backgroundColor = [UIColor redColor];
    }
    return [[_dTypeLabel retain] autorelease];
}

- (UILabel *)dZoneLabel
{
    if (_dZoneLabel == nil) {
        self.dZoneLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, (KHEIGHT + 10) * 6, SWIDTH, KHEIGHT)] autorelease];
        _dZoneLabel.backgroundColor = [UIColor greenColor];
    }
    return [[_dZoneLabel retain] autorelease];
}

- (UILabel *)dYearLabel
{
    if (_dYearLabel == nil) {
        self.dYearLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, (KHEIGHT + 10) * 7, SWIDTH, KHEIGHT)] autorelease];
        _dYearLabel.backgroundColor = [UIColor brownColor];
    }
    return [[_dYearLabel retain] autorelease];
}

- (UILabel *)dIntroductionLabel
{
    if (_dIntroductionLabel == nil) {
        self.dIntroductionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, (KHEIGHT + 10) * 8, SWIDTH, 100)] autorelease];
        _dIntroductionLabel.numberOfLines = 0;
        _dIntroductionLabel.backgroundColor = [UIColor blueColor];
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
    self.dTitleLabel.text = _detailModel.title;
    self.dScoreLabel.text = _detailModel.score;
    self.dSubTitleLabel.text = _detailModel.videoDescription;
    self.dDirectorLabel.text = _detailModel.directors;
    self.dWriterLabel.text = _detailModel.writers;
    self.dTypeLabel.text = [_detailModel.type firstObject];
    self.dZoneLabel.text = _detailModel.zone;
    self.dYearLabel.text = _detailModel.year;
    self.dIntroductionLabel.text = _detailModel.introduction;
}


//- (void)setDic:(NSDictionary *)dic
//{
//    if (_dic != dic) {
//        [_dic release];
//        _dic = [dic retain];
//    }
//    self.dTitleLabel.text = _dic[@"title"];
//    self.dScoreLabel.text = _dic[@"score"];
//    self.dSubTitleLabel.text = _dic[@"description"];
//    self.dDirectorLabel.text = _dic[@"directors"];
//    self.dWriterLabel.text = _dic[@"writers"];
//    self.dTypeLabel.text = [_dic[@"type"] firstObject];
//    self.dZoneLabel.text = _dic[@"zone"];
//    self.dYearLabel.text = _dic[@"year"];
//    self.dIntroductionLabel.text = _dic[@"introduction"];
//    
//}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
