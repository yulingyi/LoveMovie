//
//  ElectricNetWork.h
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#ifndef LoveMovie_ElectricNetWork_h
#define LoveMovie_ElectricNetWork_h

//网络剧轮播图请求地址
#define KEFOCUS_PIC http://api2.jxvdy.com/focus_pic?name=drama


//佳作推荐
#define KEEXCELLENT_URL http://api2.jxvdy.com/search_list?model=drama&order=random&attr=2&count=6
//最近更新
#define KERECENT_UPDATE_URL http://api2.jxvdy.com/search_list?model=drama&order=time&direction=1&count=6

//更多
#define KETIME_URL http://api2.jxvdy.com/search_list?model=drama&direction=1&count=15&order=time

#define KEHITS_URL http://api2.jxvdy.com/search_list?model=drama&direction=1&count=15&order=hits

#define KELIKE_URL http://api2.jxvdy.com/search_list?model=drama&direction=1&count=15&order=like

//网络剧视频页详情
#define KEVIDEO_DETAIL_URL http://api2.jxvdy.com/drama_info?token=&id=32743

//网络剧视频页相关视频
#define KERELATED_URL http://api2.jxvdy.com/drama_related?id=32743&count=6

#endif
