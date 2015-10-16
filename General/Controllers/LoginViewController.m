//
//  LoginViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/19.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "LoginViewController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHIGHT [UIScreen mainScreen].bounds.size.height
#import "AFNetworking.h"
#import "EmailViewController.h"
#import "RegisterViewController.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSinaSSOHandler.h"
@interface LoginViewController ()

@property (nonatomic, retain) UITextField * userNameFileld;
@property (nonatomic, retain) UITextField * passwordFileld;
@property (nonatomic, retain) UIButton * loginButton;
@property (nonatomic, retain) UIButton * registerButton;


@end

@implementation LoginViewController


- (void)dealloc
{
    [_userNameFileld release];
    [_passwordFileld release];
    [_loginButton release];
    [_registerButton release];
    [super dealloc];
}

- (UITextField *)userNameFileld
{
    if (!_userNameFileld) {
        self.userNameFileld = [[[UITextField alloc] initWithFrame:CGRectMake(20, 100, KWIDTH - 40, 40)] autorelease];
        _userNameFileld.placeholder = @"请输入用户名或邮箱";
        _userNameFileld.borderStyle = UITextBorderStyleRoundedRect;
    }
    return [[_userNameFileld retain] autorelease];
}

- (UITextField *)passwordFileld
{
    if (!_passwordFileld) {
        self.passwordFileld = [[[UITextField alloc] initWithFrame:CGRectMake(20, 150, KWIDTH - 40, 40)] autorelease];
        _passwordFileld.placeholder = @"请输入密码";
        
        _passwordFileld.borderStyle = UITextBorderStyleRoundedRect;
    }
    return [[_passwordFileld retain] autorelease];
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(20, 200, KWIDTH - 40, 40);
        [_loginButton.layer setCornerRadius:5];
        _loginButton.backgroundColor = [UIColor blueColor];
        [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    }
    return [[_loginButton retain] autorelease];
}

- (void)loginButtonAction:(UIButton *)sender
{
//    +&name=[用户名]&pwd=[密码]
// http://api2.jxvdy.com/member_login?
    
//    http://api2.jxvdy.com/member_emailstatus?token=pX4znWQE8kJUm3Z0yzrXWeT2KUUkuQYCE3qqgbK0--x0jP5ndETt2b2QKSXA7P1BSM06HLvLqA
    
//http://api2.jxvdy.com/member_info?token=pX4znWQE8kJUm3Z0yzrXWeT2KUUkuQYCE3qqgbK0--x0jP5ndETt2b2QKSXA7P1BSM06HLvLqA&id=341514&isprivate=1
    
    
    
    __block NSMutableArray * firstResponseObject = [@[] mutableCopy];
    
    NSString * urlStr = [NSString stringWithFormat:@"http://api2.jxvdy.com/member_login?&name=%@&pwd=%@", _userNameFileld.text, _passwordFileld.text];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
      manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    [manager GET:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        firstResponseObject = [responseObject mutableCopy];
        
        [[NSUserDefaults standardUserDefaults] setValue:firstResponseObject[1] forKey:@"soken"];
        [[NSUserDefaults standardUserDefaults] setValue:firstResponseObject[0] forKey:@"userId"];
       
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:[NSString stringWithFormat:@"http://api2.jxvdy.com/member_emailstatus?token=%@",responseObject[1] ] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            BOOL result = [responseObject isEqualToData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]];
            
              manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
                 result ? [manager GET:[NSString stringWithFormat:@"http://api2.jxvdy.com/member_info?token=%@&id=%@&isprivate=1", firstResponseObject[1], [firstResponseObject[0] stringValue]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                     [[NSUserDefaults standardUserDefaults] setValue:dic[@"email"] forKey:@"email"];
                     [[NSUserDefaults standardUserDefaults] setValue:dic[@"name"] forKey:@"name"];
                      [[NSUserDefaults standardUserDefaults] setValue:dic[@"nick"] forKey:@"nick"];
                      [[NSUserDefaults standardUserDefaults] setValue:dic[@"sex"] forKey:@"fans"];
                      [[NSUserDefaults standardUserDefaults] setValue:dic[@"follow"] forKey:@"follow"];
//                      [[NSUserDefaults standardUserDefaults] setValue:dic[@"profile"] forKey:@"profile"];
                      [[NSUserDefaults standardUserDefaults] setValue:dic[@"fans"] forKey:@"fans"];
                     
                     dic[@"face"] ? [[NSUserDefaults standardUserDefaults] setValue:dic[@"face"] forKey:@"url"] : nil;
                     
                     
                      [[NSUserDefaults standardUserDefaults] setValue:dic[@"myattention"] forKey:@"myattention"];
  
                     
                     [self popoverPresentationController];
                     
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                        NSLog(@"%@",error);
                    }] : [self sendEmail];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)sendEmail
{
    EmailViewController * emailVC = [[EmailViewController alloc] init];
    [self presentViewController:emailVC animated:YES completion:^{
        
    }];
    [emailVC release];
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame =  CGRectMake(20, 250, KWIDTH - 40, 40);
        _registerButton.backgroundColor = [UIColor blueColor];
        [_registerButton.layer setCornerRadius:5];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
       

    }
    return [[_registerButton retain] autorelease];
}
- (void)registerButtonAction:(UIButton *)sender
{
    NSLog(@"ghhhhhhhhhhhhhhhhhhr");
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    [registerVC release];
}
- (void)zhuxiao:(UIBarButtonItem *)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nick"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fans"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"follow"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fans"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"url"];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myattention"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"soken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];



    
    
    [self popoverPresentationController];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登陆";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"注销登录"
                                                                               style:UIBarButtonItemStyleDone target:self action:@selector(zhuxiao:)] autorelease];
    
    [self.view addSubview:self.userNameFileld];
    [self.view addSubview:self.passwordFileld];
    
    [self.view addSubview:self.loginButton];
    
    [self.view addSubview:self.registerButton];
    
    [self addMyView];
}

- (void)addMyView
{
    
    
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 350)];
//    [self.view addSubview:view];
//    [view release];
//    
//    CGPoint center = self.view.center;
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(center.x - 100, 20, 200, 50)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"第三方登陆";
//    
//    [view addSubview:label];
//    
//    
//    UIButton * sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [sinaButton setFrame:CGRectMake(center.x - 160, 100, 50, 50)];
//    [view addSubview:sinaButton];
//    [sinaButton setBackgroundImage:[UIImage imageNamed:@"xinlang.jpg"] forState:UIControlStateNormal];
//    sinaButton.tag = 1000;
//    [sinaButton addTarget:self action:@selector(myLogin:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton * tencentbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [tencentbutton setFrame:CGRectMake(center.x - 80, 100, 50, 50)];
//    [view addSubview:tencentbutton];
//    [tencentbutton setBackgroundImage:[UIImage imageNamed:@"txwb.jpg"] forState:UIControlStateNormal];
//    tencentbutton.tag = 1001;
//    [tencentbutton addTarget:self action:@selector(myLogin:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UIButton * renrenButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [renrenButton setFrame:CGRectMake(center.x, 100, 50, 50)];
//    [view addSubview:renrenButton];
//    [renrenButton setBackgroundImage:[UIImage imageNamed:@"renren.jpg"] forState:UIControlStateNormal];
//    renrenButton.tag = 1002;
//    [renrenButton addTarget:self action:@selector(myLogin:)
//           forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton * QQZonebutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [QQZonebutton setFrame:CGRectMake(center.x + 80, 100, 50, 50)];
//    [view addSubview:QQZonebutton];
//    [QQZonebutton setBackgroundImage:[UIImage imageNamed:@"QQkj.jpg"] forState:UIControlStateNormal];
//    QQZonebutton.tag = 1003;
//    [QQZonebutton addTarget:self action:@selector(myLogin:) forControlEvents:UIControlEventTouchUpInside];
//    
    
}


- (void)myLogin:(UIBarButtonItem *)sender
{
    NSArray * titleAry = @[UMShareToSina, UMShareToTencent, UMShareToRenren, UMShareToQzone];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:titleAry[sender.tag - 1000]];
    
    //    if (sender.tag > 1002) {
    //        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
    //        }
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:titleAry[sender.tag - 1000]];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:snsAccount.accessToken forKey:@"soken"];
            [[NSUserDefaults standardUserDefaults] setValue:snsAccount.usid forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setValue:snsAccount.userName forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.iconURL forKey:@"url"];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:titleAry[sender.tag - 1000]  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
