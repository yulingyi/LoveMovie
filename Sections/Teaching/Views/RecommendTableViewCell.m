//
//  RecommendTableViewCell.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface RecommendTableViewCell ()

@property (nonatomic, retain) UIImageView * ImageView;
@property (nonatomic, retain) UILabel *  contentLabel;
@property (nonatomic, retain) UILabel * typeLabel;

@end
@implementation RecommendTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        [self addSubview:self.ImageView];
        [self addSubview:self.contentLabel];
        [self addSubview:self.typeLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - lazyloading
- (UIImageView *)ImageView
{
    if (_ImageView == nil) {
        self.ImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, (self.frame.size.width - 10) / 3, self.frame.size.height - 5)] autorelease];
    }
    return [[_ImageView retain] autorelease];
}

- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        self.contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.ImageView.frame.size.width + 20, 0, (self.frame.size.width - 40) / 3 * 2, self.frame.size.height - 30)] autorelease];
        _contentLabel.numberOfLines = 0;
    }
    return [[_contentLabel retain] autorelease];
}

- (UILabel *)typeLabel
{
    if (_typeLabel == nil) {
        self.typeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.contentLabel.frame.origin.x,self.contentLabel.frame.size.height + 10, (self.frame.size.width - 10) / 3 * 2, 20)] autorelease];
        self.typeLabel.textColor = [UIColor grayColor];
    }
    return [[_typeLabel retain] autorelease];
}


#pragma mark - setter
- (void)setModel:(RecommendModel *)model
{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    self.contentLabel.text = _model.title;
    self.typeLabel.text = [_model.type firstObject];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
