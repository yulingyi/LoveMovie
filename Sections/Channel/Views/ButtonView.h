//
//  ButtonView.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonViewDelegate <NSObject>

- (void)buttonClicked:(UIButton *)sender;

@end

@interface ButtonView : UIView

@property (nonatomic, retain) id<ButtonViewDelegate> delegate;

@end
