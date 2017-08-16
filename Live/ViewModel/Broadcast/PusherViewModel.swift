//
//  PusherViewModel.swift
//  Live
//
//  Created by lieon on 2017/6/23.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable function_parameter_count

import Foundation

let pushURL = "rtmp://192.168.0.24:2355/rtmplive/room"

class PusherViewModel {
    static var shared: PusherViewModel {
        return PusherViewModel()
    }
    
    func getPusherUrl(_ userId: String, groupId: String, title: String, coverPic: String, nickName: String, headPic: String, location: String, handler: (_ errCode: Int, _ pusherUrl: String, _ timestamp: Int) -> Void) {
        //FIXME: 真正的从服务器获取推流URL
        handler(0, pushURL, 10000)
    }
}
