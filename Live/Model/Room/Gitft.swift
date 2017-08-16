//
//  Gitft.swift
//  Live
//
//  Created by lieon on 2017/7/24.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper

class GiftGroup: Model {
    var list: [Gitft]?
    
    override func mapping(map: Map) {
        list <- map["list"]
    }
}

class Gitft: Model {
    var gifitId: Int = 0
    var name: String?
    var picture: String?
    var pointCount: Int = 10
    var animateAddress: String?
    var shortName: String?
    var gitftType: GiftType = .common
    
    override func mapping(map: Map) {
        gifitId <- map["id"]
        name <- map["name"]
        picture <- map["picture"]
        pointCount <- map["pointCount"]
        shortName <- map["shortName"]
        gitftType <- map["giftType"]
    }
}
