//
//  ImagesCollectionViewCell.h
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"
@protocol ImagesCollectionViewCellDeleage <NSObject>

- (void)onClickWithRecommendModel:(NSNumber *)modelID;

@end

@interface ImagesCollectionViewCell : UICollectionViewCell


@property (nonatomic, assign)id<ImagesCollectionViewCellDeleage> deleage;




@end
