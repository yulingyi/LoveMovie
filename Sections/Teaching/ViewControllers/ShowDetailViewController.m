//
//  ShowDetailViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "NetworkEngine.h"
#import "MBProgressHUD.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
@interface ShowDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, retain) NSMutableDictionary * dic;
@end

@implementation ShowDetailViewController

- (void)dealloc
{
    self.myId = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    self.view.backgroundColor = [UIColor whiteColor];
    NSString * url = [NSString stringWithFormat:@"http://api2.jxvdy.com/tutorial_info?id=%@&token=", [self.myId stringValue]];
    __block typeof(self) mySelf = self;
    [[NetworkEngine shareNetworkEngine] getInfoFromServerWithURLStr:url success:^(id response) {
        
        [mySelf dataParsingWithDic:response];
        
    } fail:^(NSError *error) {
        
        
    }];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 }

- (void)dataParsingWithDic:(NSDictionary *)dic
{
    _dic = [dic mutableCopy];;
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 -49)] ;

    NSString * str = _dic[@"content"];
     [webView loadHTMLString:[str substringToIndex:str.length - 12]  baseURL:nil];
//    [webView setScalesPageToFit:YES];
    webView.delegate = self;
//    webView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    webView.allowsInlineMediaPlayback = YES;
    webView.hidden = YES;
    [self.view addSubview:webView];
    [webView release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{ [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    webView.hidden = NO;
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = %f;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);", KWIDTH- 15]];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
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
