//
//  RegisterViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "EmailViewController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHIGHT [UIScreen mainScreen].bounds.size.height
@interface RegisterViewController ()

@property (nonatomic, retain) UITextField * userNameFileld;
@property (nonatomic, retain) UITextField * passwordFileld;
@property (nonatomic, retain) UIButton * registerButton;
@property (nonatomic, retain) UITextField * emailFiled;


@end

@implementation RegisterViewController

- (void)dealloc
{
    [_userNameFileld release];
    [_passwordFileld release];
    [_registerButton release];
    [_emailFiled release];
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

- (UITextField *)emailFiled
{
    if (!_emailFiled) {
        self.emailFiled = [[[UITextField alloc] initWithFrame:CGRectMake(20, 200,  KWIDTH - 40, 40)] autorelease];
        _emailFiled.placeholder = @"请输入邮箱";
        _emailFiled.borderStyle = UITextBorderStyleRoundedRect;
        
    }
    return [[_emailFiled retain] autorelease];
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
//     http://api2.jxvdy.com/member_regist?name=921212&pwd=921212&email=15538303135@163.com
    NSLog(@"ghhhhhhhhhhhhhhhhhhr");
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
//
        
    __block RegisterViewController * selfBlock = self;
    NSString * urlStr = [[NSString stringWithFormat:@"http://api2.jxvdy.com/member_regist?name=%@&pwd=%@&email=%@",_userNameFileld.text,_passwordFileld.text, _emailFiled.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        
        [[NSUserDefaults standardUserDefaults] setValue:responseObject[1] forKey:@"soken"];
        [[NSUserDefaults standardUserDefaults] setValue:responseObject[0] forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setValue:selfBlock.emailFiled.text forKey:@"email"];
        
        [selfBlock sendEmail];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"用户名/邮箱已存在" message:@"请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            
        });
        
        [alertView release];

    }];
            
    
    
    
    
}
- (void)sendEmail
{
    EmailViewController * emailVC = [[EmailViewController alloc] init];
    [self presentViewController:emailVC animated:YES completion:^{
        
    }];
    [emailVC release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self.view addSubview:self.userNameFileld];
    [self.view addSubview:self.passwordFileld];
    [self.view addSubview:self.emailFiled];
    [self.view addSubview:self.registerButton];
    // Do any additional setup after loading the view.
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
