//
//  DownLoad_progressTableViewCell.m
//  LoveMovie
//
//  Created by laouhn on 15/9/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "DownLoad_progressTableViewCell.h"
#import "AFNetworking.h"
#import "NetworkEngine.h"
#define KWIDTH_CELL self.frame.size.width
#define KHIGHT_CELL self.frame.size.height

@interface DownLoad_progressTableViewCell ()

@property (nonatomic, retain) UIProgressView * progressView;
@property (nonatomic, retain) UIButton * startButton;

@property (nonatomic, retain) UILabel * videoTitle;
@property (nonatomic, retain) UILabel * progresslabel;
@property (nonatomic, retain) AFHTTPRequestOperationManager * manager;
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, assign) float current;
@end



@implementation DownLoad_progressTableViewCell

- (void)dealloc
{
    [_videoTitle release];
    [_startButton release];
    [_progressView release];
    [_operation release];
    [_timer release];

    [super dealloc];
}
- (UILabel *)videoTitle
{
    if (!_videoTitle) {
        self.videoTitle = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, KWIDTH_CELL, 40)] autorelease];
//        _videoTitle.backgroundColor = [UIColor grayColor];
    }
    return [[_videoTitle retain] autorelease];
}
-(UIProgressView *)progressView
{
    if (!_progressView) {
        self.progressView = [[[UIProgressView alloc] initWithFrame:CGRectMake(20, 70 , KWIDTH_CELL - 150, 5)] autorelease];
        _progressView.progress = 0;
//        _progressView.backgroundColor = 
    }
    return [[_progressView  retain] autorelease];
}

- (UIButton *)startButton
{
    if (!_startButton) {
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_startButton setTitle:@"0%" forState:UIControlStateNormal];
        
        _startButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 150, 50, 100, 40);
//        _startButton.backgroundColor = [UIColor redColor];
        [_startButton.layer setCornerRadius:20];
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return [[_startButton retain] autorelease];
}
- (void)startButtonAction:(UIButton *)sender
{
  
    
    
    if ([_startButton.titleLabel.text isEqualToString:@"继续"]) {
        
        self.current = self.operation.video.current;
        //继续下载
        [self.operation resume];
        
        [self.timer setFireDate:[NSDate date]];
      
    }else
    {
        [self.operation pause];
         [self.timer setFireDate:[NSDate distantFuture]];
        [self performSelectorOnMainThread:@selector(setButtonTitle:) withObject:@"继续" waitUntilDone:nil];
    }
 
}
- (void)setButtonTitle:(NSString *)str
{
    [self.startButton setTitle:str forState:UIControlStateNormal];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.videoTitle];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.startButton];
       self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setProgressViewValue) userInfo:nil repeats:YES];
        

    }
    return self;
}



- (void)setProgressViewValue
{
//   NSNumber * num = [[NSUserDefaults standardUserDefaults] objectForKey:@"32723"];
    
    self.progressView.progress = self.operation.video.current - self.current;
    [self.startButton setTitle:[NSString stringWithFormat:@"%.1f%%",self.progressView.progress * 100]
                      forState:UIControlStateNormal];
    NSLog(@"%@", self.operation);

}

-(void)setOperation:(AFHTTPRequestOperation *)operation
{
    if (_operation != operation) {
        [_operation release];
        _operation = [operation retain];
    }
    self.videoTitle.text = _operation.video.title;
    self.startButton.titleLabel.text = [NSString stringWithFormat:@"%.1f%%",_operation.video.current * 100];
    
    __block typeof(self) mySelf = self;
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [mySelf.timer invalidate];
//        [mySelf performSelectorOnMainThread:@selector(setButtonTitle:) withObject:@"已下载" waitUntilDone:YES];
       
        
        
        [mySelf performSelectorOnMainThread:@selector(refresh:) withObject:mySelf.videoTitle.text waitUntilDone:NO];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [mySelf performSelectorOnMainThread:@selector(setButtonTitle:) withObject:@"失败" waitUntilDone:YES];
    }];
}


- (void)refresh:(NSString *)str
{
    [self.delegate reloadData:str];
    NSLog(@"%@", str);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
