//
//  Url.h
//  VMovie
//
//  Created by laouhn on 15/9/16.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#ifndef VMovie_Url_h
#define VMovie_Url_h

//微电影界面轮播图地址请求
#define VIDEO_FOCUS_PIC http://api2.jxvdy.com/focus_pic?name=video

//微电影界面佳作推荐地址请求
#define VIDEO_GOOD http://api2.jxvdy.com/search_list?model=video&order=time&direction=1&count=6&attr=2

//微电影界面国内佳作地址请求
#define VIDEO_BOARD http://api2.jxvdy.com/search_list?model=video&zone=23&order=random&count=6&attr=2

//微电影界面国外佳作地址请求
#define VIDEO_ABOARD http://api2.jxvdy.com/search_list?model=video&zone=24&order=random&count=6&attr=2

//微电影详细信息请求地址 :+ token=&id= [ id ]
#define VIDEO http://api2.jxvdy.com/video_info?

//微电影相关视频信息请求地址 :+ id= [id]&count=6
#define VIDEO_MORE  http://api2.jxvdy.com/video_related?

//微电影相关视频信息请求地址 :+ id= [id]&count=6&offset=24
#define VIDEO_MORE  http://api2.jxvdy.com/video_related?


//微电影相关评论请求地址 :+ token=&id= [ id ]&type=2&count=10
#define VIDEO_MORE   http://api2.jxvdy.com/comment_list?

//微电影最新最热好评 : + model=video&direction=1&count=15&order=[time(最新)/hits(最热)/like(好评)]&offset=15
#define VIDEO_SX    http://api2.jxvdy.com/search_list?


//评论 :+ id=[ID ]&type=2&count=10
#define   VIDEO_COMMENT http://api2.jxvdy.com/comment_list?

//收索关键字 :+ model=video&count=15&keywords=[KEY]&token=
#define     VIDEO_KEY  http://api2.jxvdy.com/search_list?


//收索关键字 :+ model=video&count=15&keywords=[KEY]&token=&offset=15
#define     VIDEO_KEY_MORE http://api2.jxvdy.com/search_list?


//注册 : + name=[用户名]&pwd=[密码]&email=[邮箱地址]

#define REGIST http://api2.jxvdy.com/member_regist?

//登陆 : +&name=[用户名]&pwd=[密码]
#define LOGIN  http://api2.jxvdy.com/member_login?











#endif
