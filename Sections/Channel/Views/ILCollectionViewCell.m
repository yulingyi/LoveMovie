//
//  ILCollectionViewCell.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ILCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "FMDatabase.h"

#define KWIDTH self.frame.size.width
#define KHEIGHT self.frame.size.height
@interface ILCollectionViewCell ()

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel * titleLabel;
@property (nonatomic, retain) UILabel * subTitleLabel;

@end

@implementation ILCollectionViewCell

- (void)dealloc
{
    self.model = nil;
    self.imageView = nil;
    self.titleLabel = nil;
    self.subTitleLabel = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

#pragma mark - lazyloading
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, KWIDTH, KHEIGHT / 3 * 2)] autorelease];
//        _imageView.backgroundColor = [UIColor redColor];
    }
    return [[_imageView retain] autorelease];
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, KHEIGHT / 3 * 2, KWIDTH, KHEIGHT / 3 / 3)] autorelease];
        _titleLabel.font = [UIFont systemFontOfSize:14];

    }
    return [[_titleLabel retain] autorelease];
}

- (UILabel *)subTitleLabel
{
    if (_subTitleLabel == nil) {
        self.subTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.frame.size.height + KHEIGHT / 3 * 2, KWIDTH, self.titleLabel.frame.size.height * 2)] autorelease];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
    }
    return [[_subTitleLabel retain] autorelease];
}

- (void)setModel:(VideoModel *)model
{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    self.titleLabel.text = _model.title;
    self.subTitleLabel.text = _model.descript;
}


- (void)showHistory
{
//    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//    
//    NSString * dbPath = [cachePath stringByAppendingPathComponent:@"data.sqlite"];
//    
//    NSLog(@"%@", dbPath);
//    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
//    [db open];
//    
//    if (![db open]) {
//        NSLog(@"asd");
//        return;
//    }
//    [db executeUpdate:@"create table videoInformation(myDescription text, myId int primary key, img text, score text, time int, title text)"];
//    
//    BOOL insert = [db executeUpdate:@"insert into videoInformation values(?, ?, ?, ?, ?, ?)", self.model.myDescription, self.model.myId, self.model.img, self.model.score, self.model.time, self.model.title];
//    if (!insert) {
//        NSLog(@"Fail");
//    }
//    [db close];

}





@end
