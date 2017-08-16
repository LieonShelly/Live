//
//  Room.swift
//  Live
//
//  Created by lieon on 2017/7/10.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

class RoomReslut: Model {
    var result: LiveListModel?
    
    override func mapping(map: Map) {
        result <- map["live"]
    }
}

class Room: Model {
    var playUrlRtmp: String?
    var playUrlFlv: String?
    var playUrlHls: String?
    var name: String?
    var userId: Int = 0
    var liveNo: String?
    var liveId: Int = 0
    var groupId: String?
    var avastar: String?
    var nickName: String?
    var isFollow: Bool = false
    
    override func mapping(map: Map) {
        playUrlRtmp <- map["playUrlRtmp"]
        playUrlFlv <- map["playUrlFlv"]
        playUrlHls <- map["playUrlHls"]
        name <- map["name"]
        userId <- map["userId"]
        liveNo <- map["liveNo"]
        liveId <- map["liveId"]
        groupId <- map["groupId"]
        avastar <- map["avastar"]
        nickName <- map["nickName"]
        isFollow <- map["isFollow"]
    }
}

class LiveRealTime: Model {
    var info: LiveRealTimeInfo?
    
    override func mapping(map: Map) {
        info <- map["info"]
    }
}
class LiveRealTimeInfo: Model {
    var seeingCount: String?
    var income: Int = 0
    var users: [UserInfo]?
    
    override func mapping(map: Map) {
        seeingCount <- map["seeingCount"]
        income <- map["pointCount"]
        users <- map["users"]
    }
}
