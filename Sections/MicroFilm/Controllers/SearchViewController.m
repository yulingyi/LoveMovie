//
//  SearchViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "SearchViewController.h"
#import "FMDB.h"
#import "ResultBySearchViewController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHIGHT [UIScreen mainScreen].bounds.size.height
@interface SearchViewController ()<UISearchBarDelegate>

@property (nonatomic, retain) UISearchBar * searchBar;

@property (nonatomic, retain) UIView * keysView;


@end

@implementation SearchViewController


- (void)dealloc
{
    self.searchBar = nil;
    self.keysView = nil;
    [super dealloc];
}

- (UIView *)keysView
{
    if (!_keysView) {
        self.keysView = [[[UIView alloc] initWithFrame:CGRectMake(10, 104, KWIDTH - 20, 50)] autorelease];

   
    }
    return [[_keysView retain] autorelease];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, KWIDTH, 40)] autorelease];
        _searchBar.placeholder = @"请输入关键字....";
        _searchBar.delegate = self;
        
        
       
        
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return [[_searchBar retain] autorelease];
    
}

- (NSArray *)getKeysFromSql
{
    
    NSString * DocPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString * sqlPath = [DocPath stringByAppendingPathComponent:@"data.sqlite"];
    
    FMDatabase * db = [FMDatabase databaseWithPath:sqlPath];
    
    if (![db open]) {
        NSLog(@"guygyu");
    }
    NSMutableArray * keyAry = [@[] mutableCopy];
   FMResultSet * resultSet = [db executeQuery:@"select * from SearchKeys"];
    
    while ([resultSet next]) {
        [keyAry addObject:[resultSet stringForColumn:@"key"]];
    }
    
    [db close];
    [keyAry addObjectsFromArray:@[@"微电影", @"小爸爸", @"穿越",@"爱情"]];
    return keyAry;
}

- (void)addKeysToView
{
    NSArray * ary = [self getKeysFromSql];
    
        self.keysView.frame = CGRectMake(10, 104, KWIDTH - 20, (ary.count / 2 + 2 ) * 50);
        
   
    CGFloat kBtuWidth = (KWIDTH - 20) / 2;
    for (int i = 0; i < [ary count] / 2 + 1; i++) {
        
        
        for (int j = 0; j < 2; j++) {
            if ((i * 2 + j ) < ary.count) {
                
                UIButton * btu = [UIButton buttonWithType:UIButtonTypeCustom];
                btu.backgroundColor = [UIColor colorWithRed:arc4random() % 255 /255.0 green:arc4random() % 255 /255.0 blue:arc4random() % 255 /255.0 alpha:1];
                btu.frame = CGRectMake(kBtuWidth * j, 50 * i, kBtuWidth- 10, 40);
                
                [btu setTitle:ary[i * 2 + j] forState:UIControlStateNormal];
                [btu.layer setCornerRadius:5];
                
                [btu addTarget:self action:@selector(linkByClick:) forControlEvents:UIControlEventTouchUpInside];
                
                 [self.keysView addSubview:btu];
                              
            }
            
            
        }
       
        
    }
    UIButton * clear = [UIButton buttonWithType:UIButtonTypeCustom];
    clear.backgroundColor = [UIColor colorWithRed:arc4random() % 255 /255.0 green:arc4random() % 255 /255.0
                                             blue:arc4random() % 255 /255.0 alpha:1];
    clear.frame = CGRectMake(0, 50 * ary.count / 2 + 50,self.keysView.frame.size.width, 40);
    [clear setTitle:@"清除" forState:UIControlStateNormal];
    [clear.layer setCornerRadius:5];
    [clear addTarget:self action:@selector(clearKeys:) forControlEvents:UIControlEventTouchUpInside];
    [self.keysView addSubview:clear];
    
}

- (void)linkByClick:(UIButton *)sender
{
    [self nextPage:sender.titleLabel.text];
    
}

- (void)clearKeys:(UIButton *)sender
{
    
    
    NSString * DocPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString * sqlPath = [DocPath stringByAppendingPathComponent:@"data.sqlite"];
    
    FMDatabase * db = [FMDatabase databaseWithPath:sqlPath];
    
    if (![db open]) {
        NSLog(@"guygyu");
    }

    [db executeUpdate:@"delete from SearchKeys"];
    

    
    [db close];
    
    for (UIButton * but in self.keysView.subviews) {
        [but removeFromSuperview];
    }

    
}

- (void)nextPage:(NSString *)str
{
    ResultBySearchViewController * resultVC = [[ResultBySearchViewController alloc] init];
    resultVC.key = str;
    [self.navigationController pushViewController:resultVC animated:YES];
    
    [resultVC release];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"搜索";
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.keysView];
    
    [self addKeysToView];
    // Do any additional setup after loading the view.
}

#pragma mark----


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"guykugyuy");
    NSString * key = self.searchBar.text;
    
    [self insertKeyToSql:key];
    
    [self nextPage:searchBar.text];

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"gyukgayu");
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
   
       self.keysView.hidden = !self.keysView.hidden;
 
    
}
- (void)insertKeyToSql:(NSString *)key
{
    
    NSString * DocPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString * sqlPath = [DocPath stringByAppendingPathComponent:@"data.sqlite"];
    
    FMDatabase * db = [FMDatabase databaseWithPath:sqlPath];
    
    if (![db open]) {
        NSLog(@"guygyu");
    }
    if (![db executeQuery:@"select * from SearchKeys"]) {
         [db executeUpdate:@"CREATE TABLE SearchKeys (key text PRIMARY KEY)"];
    }
    
    BOOL insert = [db executeUpdate:@"insert into  SearchKeys values (?)", key];
    
    if (insert) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//                [alert release];
    }

    
    [db close];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
