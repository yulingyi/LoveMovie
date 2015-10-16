//
//  NightTableViewCell.m
//  LoveMovie
//
//  Created by laouhn on 15/10/6.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "NightTableViewCell.h"


@interface NightTableViewCell ()

@property (nonatomic, retain) UISwitch * switchView;
@end

@implementation NightTableViewCell

- (void)dealloc
{
    [_switchView release];
    [super dealloc];
}

- (UISwitch *)switchView
{
    if (!_switchView) {
        self.switchView = [[[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, 8, 100, 44)] autorelease];
        _switchView.on = NO;
    }
    return [[_switchView retain] autorelease];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 160, 44);
        [self addSubview:self.switchView];
        [_switchView addTarget:self action:@selector(stateChange) forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
}


- (void)stateChange
{
    if (_switchView.on) {
        self.window.alpha = 0.5;
    }else
    {
        self.window.alpha = 1;
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
