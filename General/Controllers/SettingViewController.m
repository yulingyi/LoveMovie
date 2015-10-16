//
//  SettingViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/10/6.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "SettingViewController.h"
#import "RootViewController.h"
@interface SettingViewController ()
@property (nonatomic, retain) UILabel * about;


@end

@implementation SettingViewController

- (void)dealloc
{
    [_about release];
    [super dealloc];
    
}

- (UILabel *)about
{
    
    if (!_about) {
        self.about = [[[UILabel alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49)] autorelease];
        _about.textAlignment = NSTextAlignmentLeft;
        _about.lineBreakMode =  NSLineBreakByWordWrapping;
        _about.numberOfLines = 0;
        
    }
    
    return [[_about retain] autorelease];
}


- (void)viewDidLoad {
    [super viewDidLoad];
self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.about];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)]autorelease] ;
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)back:(UIBarButtonItem *)sebder
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [((RootViewController *)self.tabBarController.parentViewController) openLeftView];
}
- (void)setStr:(NSString *)str
{
    if (_str != str) {
        [_str release];
        _str = [str copy];
    }
    
    self.navigationItem.title = _str;
    
    [self performSelectorOnMainThread:@selector(aboutText:) withObject:_str waitUntilDone:NO];
 
}

- (void)aboutText:(NSString *)str
{
    if ([_str isEqualToString:@"关于我们"]) {
        
       
        NSString * text  = @"  心动微影是一款专门为移动用户打造的集视屏搜索、播放为一体的移动网络音频产品。通过心动微影，用户可以方便快捷地搜索到音频资源,进行在线播放。";
        CGRect rect = [text  boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
        self.about.frame = CGRectMake(10, 74, rect.size.width, rect.size.height);
        
        self.about.text = text;
        

    }else if ([_str isEqualToString:@"免责声明"])
    {
        NSString *text = @"  心动微影提醒您：在使用爱上微电影客户端（以下简称心动微影）前，请您务必仔细阅读并透彻理解本声明。您可以选择不使用心动微影，但如果您使用心动微影，您的使用行为将被视为对本声明全部内容的认可。鉴于心动微影以非人工检索方式、根据您键入的关键字自动生成到第三方网页的链接，除爱上微电影注明之服务条款外，其他一切因使用心动微影而可能遭致的意外、疏忽、侵权及其造成的损失，心动微影对其概不负责，亦不承担任何法律责任。";
        
        CGRect rect = [text  boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
        self.about.frame = CGRectMake(10, 74, rect.size.width, rect.size.height);
        
        self.about.text = text;

        
    }else
    {
        NSString * text = @"  用户意见反馈QQ群: 335743201  \n   QQ反馈:996235005";
        
        CGRect rect = [text  boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
        self.about.frame = CGRectMake(10, 74, rect.size.width, rect.size.height);
        
        self.about.text = text;
        

    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
