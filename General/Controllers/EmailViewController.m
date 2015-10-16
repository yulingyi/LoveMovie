//
//  EmailViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "EmailViewController.h"
#import "AFNetworking.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHIGHT [UIScreen mainScreen].bounds.size.height
@interface EmailViewController ()

@property (nonatomic, retain) UITextField * emailFiled;
@property (nonatomic, retain) UIButton * sendEmail;
@end

@implementation EmailViewController

-(void)dealloc
{
    [_emailFiled release];
    
    [super dealloc];
}


- (UITextField *)emailFiled
{
    if (!_emailFiled) {
        self.emailFiled = [[[UITextField alloc] initWithFrame:CGRectMake(20, 150, KWIDTH - 40, 40)] autorelease];
        _emailFiled.borderStyle = UITextBorderStyleRoundedRect;
        _emailFiled.placeholder = @"请输入邮箱";
         NSString *  email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
        _emailFiled.text = email;
    }
    return [[_emailFiled retain] autorelease];
}

- (UIButton *)sendEmail
{
    if (!_sendEmail) {
        self.sendEmail = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendEmail.frame = CGRectMake(20, 200, KWIDTH - 40, 40);
        _sendEmail.backgroundColor = [UIColor blueColor];
        [_sendEmail.layer setCornerRadius:5];
        [_sendEmail setTitle:@"验证邮箱"  forState:UIControlStateNormal];
        [_sendEmail addTarget:self action:@selector(sendEmailAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return [[_sendEmail retain] autorelease];
}

- (void)sendEmailAction:(UIButton *)sender
{
//    http://api2.jxvdy.com/member_checkemail?token=L8G8OSahVEvZxIM9BWvvfA4b3sFqKKm4cJ1i3zmjJhrQLVT5oSKolITy6TdvA6c9K3oydkBQgA&email=15538303135@163.com
    [self dismissViewControllerAnimated:YES completion:^{
       
        AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
        
        NSString *  token = [[NSUserDefaults standardUserDefaults] objectForKey:@"soken"];
        
        
        NSString * getStr = [NSString stringWithFormat:@"http://api2.jxvdy.com/member_checkemail?token=%@&email=%@",token,_emailFiled.text];
        [manger GET:getStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }];
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"激活邮箱";
    [self.view addSubview:self.emailFiled];
    [self.view addSubview:self.sendEmail];
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
