//
//  VideoCollectionViewCell.m
//  VMovie
//
//  Created by laouhn on 15/9/14.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "FMDB.h"
@interface VideoCollectionViewCell ()

@property (nonatomic, retain) UIImageView * iconView;
@property (nonatomic, retain) UILabel * titleLabel;
@property (nonatomic, retain) UILabel * subTitleLabel;


@end

@implementation VideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
        [self.contentView addSubview:self.iconView];
        self.iconView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];

        
    }
    
    return self;
}




- (void)setVideo:(VideoModel *)video
{
    if (_video != video) {
        [_video release];
        _video = [video retain];
    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_video.img] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    self.titleLabel.text = _video.title;
    if ([_video.episode intValue] > 0 ) {
        self.subTitleLabel.text = [NSString stringWithFormat:@"第%@集",[_video.episode stringValue]];
    }else{
        if (!_video.maxepisode) {
            self.subTitleLabel.text = _video.descript;
        }else
        {
            self.subTitleLabel.text = [NSString stringWithFormat:@"更新到第%@集",[_video.maxepisode stringValue]];
        }
    }
}


- (UIImageView *)iconView
{
    if (!_iconView) {
        self.iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.75)] autorelease];
    }
    
    return [[_iconView retain] autorelease];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconView.frame), self.frame.size.width, self.frame.size.height * 0.1)] autorelease];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return [[_titleLabel retain] autorelease];
    
    
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        self.subTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.frame.size.width, self.frame.size.height * 0.15)] autorelease];
        
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.numberOfLines = 0;
        [_subTitleLabel setTextColor:[UIColor grayColor]];
         
    }
    return [[_subTitleLabel retain] autorelease];
}

- (void)dealloc
{
    self.iconView = nil;
    self.titleLabel = nil;
    self.subTitleLabel =  nil;
    
    [super dealloc];
}

@end
