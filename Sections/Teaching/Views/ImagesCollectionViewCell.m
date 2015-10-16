//
//  ImagesCollectionViewCell.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ImagesCollectionViewCell.h"
#import "TopCollectionReusableView.h"
#import "NetworkEngine.h"
@interface ImagesCollectionViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, retain) TopCollectionReusableView * topCollection;
@property (nonatomic, retain) NSArray *data;

@end

@implementation ImagesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180);
        [self addSubview:self.topCollection];
    }
    return self;
}

#pragma mark lazyloading
- (TopCollectionReusableView *)topCollection
{
    if (_topCollection == nil) {
        self.topCollection = [[TopCollectionReusableView alloc] initWithFrame:self.frame];
        NSString *urlString = @"http://api2.jxvdy.com/focus_pic?name=tutorials";
        __block typeof(self) mySelf = self;
        [[NetworkEngine shareNetworkEngine] getInfoFromServerWithURLStr:urlString success:^(id response) {
            
            [mySelf dataParsingWithAry:response];
        } fail:^(NSError *error) {
            
            
        }];
        
    }
    return [[_topCollection retain] autorelease];
}

- (void)dataParsingWithAry:(NSArray *)ary
{
    
    self.data = ary;
    
    NSArray * imagesAry = @[ary[0][@"img"],ary[1][@"img"],ary[2][@"img"],ary[3][@"img"] ];
    NSArray * titleAry = @[ary[0][@"title"],ary[1][@"title"],ary[2][@"title"],ary[3][@"title"] ];
            self.topCollection.cycleScrollView.delegate = self;
    self.topCollection.cycleScrollView.imageURLStringsGroup = imagesAry;
    self.topCollection.cycleScrollView.titlesGroup = titleAry;
    
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"您点击了第%ld张", index);
      [self.deleage onClickWithRecommendModel:self.data[index][@"id"]];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView index:(NSInteger)index
{
  
}

@end
