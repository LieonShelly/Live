//
//  Live.swift
//  Live
//
//  Created by lieon on 2017/7/5.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import ObjectMapper

class EndLiveReponse: Model {
    var live: EndLiveModel?
    
    override func mapping(map: Map) {
        live <- map["live"]
    }
}

class LiveReponse: Model {
    var liveinfo: Live?
    
    override func mapping(map: Map) {
        liveinfo <- map["live"]
    }
}

class EndLiveModel: Model {
    var avastar: String?
    var nickName: String?
    var liveId: Int = 0
    var pointCount: Int = 0
    var fansCount: Int = 0
    var giftCount: Int = 0
    var seeCount: Int = 0
    var maxSeeingCount: Int = 0
    var userId: Int = 0
    var liveNo: String?
    
    override func mapping(map: Map) {
        avastar <- map["avastar"]
        nickName <- map["nickName"]
        liveId <- map["liveId"]
        pointCount <- map["pointCount"]
        fansCount <- map["fansCount"]
        giftCount <- map["giftCount"]
        seeCount <- map["seeCount"]
        maxSeeingCount <- map["maxSeeingCount"]
        userId <- map["userId"]
         liveNo <- map["liveNo"]
    }
}

class Live: Model {
    var pushUrl: String?
    var name: String?
    var liveNo: String?
    var groupId: String?
    var avastar: String?
    var nickName: String?
    var userId: Int = 0
    var liveId: Int = 0
    
    override func mapping(map: Map) {
        pushUrl <- map["pushUrl"]
        name <- map["name"]
        liveNo <- map["liveNo"]
        groupId <- map["groupId"]
        avastar <- map["avastar"]
        nickName <- map["nickName"]
        userId <- map["userId"]
         liveId <- map["liveId"]
    }
    
}
