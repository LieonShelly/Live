//
//  AnchorDetail.swift
//  Live
//
//  Created by lieon on 2017/7/11.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper

class AnchorDetailResult: Model {
    var result: AnchorDetail?
    override func mapping(map: Map) {
        result <- map["user"]
    }
}

class AnchorDetail: Model {
    var userId: Int = 0
    var nickName: String?
    var avatar: String?
    var sex: Gender = .unknown
    var liveNo: String?
    var followCount: Int = 0
    var fansCount: Int = 0
    var level: Int = 0
    var isFollow: Bool = false
    
    override func mapping(map: Map) {
        userId <- map["id"]
        nickName <- map["nickName"]
        avatar <- map["avastar"]
        sex <- map["sex"]
        liveNo <- map["liveNo"]
        followCount <- map["followCount"]
        fansCount <- map["fansCount"]
        level <- map["level"]
        isFollow <- map["isFollow"]
    }
}
