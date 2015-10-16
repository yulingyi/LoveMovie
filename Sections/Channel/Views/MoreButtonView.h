//
//  MoreButtonView.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreButtonViewDelegate <NSObject>

- (void)getClickedButton:(UIButton *)button;

@end

@interface MoreButtonView : UIView

@property (nonatomic, assign) id<MoreButtonViewDelegate> delegate;

@end
