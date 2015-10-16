
//
//  interface.h
//  Interface
//
//  Created by laouhn on 15/9/12.
//  Copyright (c) 2015年 王少鹏. All rights reserved.
//


/* 教学微电影
 1. 推荐
//轮播图地址
#define KRECOMMEND_IMAGES  http://api2.jxvdy.com/focus_pic?name=tutorials

//图片和Label结合的地址(轮播图下面)
 #define KRECOMMEND_DATA   http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&token=
 
 //上拉加载数据量(初始加载15条) x表示每次刷新出来数据量加上原有的数据量 + (x + 15)
 #define KRECOMMEND_LOADMOREDATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&token=&offset=
 
2. 剧作教程
 
 //图片和Label结合的地址
#define KDRAMACOURSE_DATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&type=14&token=
 
 //上拉加载数据量(初始加载15条) x表示每次刷新出来数据量加上原有的数据量 
 #define KDRAMACOURSE_LOADMOREDATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&token=&type=14&offset=(x + 15)
 
 3. 微影拍摄
 //图片和Label结合的地址
 #define KTINYSHOOT_DATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&type=15&token=
 
 //上拉加载数据量(初始加载15条) x表示每次刷新出来数据量加上原有的数据量
 #define KTINYSHOOT_LOADMOREDATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&token=&type=15&offset=(x + 15)

 4.影视后期
 
 //图片和Label结合的地址
 #define KFILMLATER_DATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&type=16&token=
 
 //上拉加载数据量(初始加载15条) x表示每次刷新出来数据量加上原有的数据量
 #define KFILMLATER_LOADMOREDATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&token=&type=16&offset=(x + 15)
 
 
 5.拍摄器材
 
 //图片和Label结合的地址
 #define KSHOOTEQUIPMENT_DATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&type=17&token=
 
 //上拉加载数据量(初始加载15条) x表示每次刷新出来数据量加上原有的数据量
 #define KSHOOTEQUIPMENT_LOADMOREDATA http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&token=&type=17&offset=(x + 15)
 
 
 
 //搜索(以下是默认的,也就是搜索框中无内容时)
 
 //搜索框中电影地址(微电影)(上拉刷新同样是这个地址)
#define KMCSROFILM_DATA  http://api2.jxvdy.com/search_list?model=video&count=15&keywords=
 
 //上拉刷新加载数据量(微电影)
 #define KMCSROFILM_LOADMOREDATA http://api2.jxvdy.com/search_list?model=video&count=15&keywords=输入框的内容&token=&offset=15

 //微电影播放地址 +影片id
  http://api2.jxvdy.com/video_file?id=32724
 
 //影片详情地址
 http://api2.jxvdy.com/video_info?token=&id=32724
 
 //相关视频地址
http://api2.jxvdy.com/video_related?id=341249&count=6
 
 //网络剧地址
 #define KDRAMAURL_DATA http://api2.jxvdy.com/search_list?model=drama&count=15&keywords=输入框的内容&token=
 
 
 //上拉(下拉)刷新加载数据量(网络剧)
 #define KDRAMAURL_LOADMOREDATA http://api2.jxvdy.com/search_list?model=drama&count=15&keywords=输入框的内容&token=&offset=3

 */




/*   频道
 //最新按钮关联地址 30915 30912 30905
#define KLATEST_DATA http://api2.jxvdy.com/search_list?model=video&direction=1&count=15&order=time&offset=30
 
 //最热按钮关联地址
 #define KHOT_DATA http://api2.jxvdy.com/search_list?model=video&direction=1&count=15&order=hits
 
 //好评按钮关联地址
#define KCOMMENT_DATA http://api2.jxvdy.com/search_list?model=video&direction=1&count=15&order=like
 
 //类型按钮关联的地址(全部按钮废弃)
 
 (其它按钮地址type依次递增)
 http://api2.jxvdy.com/search_list?model=video&direction=1&count=15&order=time&type=1

 */
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  
