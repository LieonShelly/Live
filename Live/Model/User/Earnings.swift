//
//  Earnings.swift
//  Live
//
//  Created by lieon on 2017/7/27.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper

class PickupIntialModel: Model {
    var money: String?
    var pickupFloor: String?
    
    override func mapping(map: Map) {
        money <- map["money"]
        pickupFloor <- map["pickupFloor"]
    }
}

class MoneyRecord: Model {
    var createTimeDis: String?
    var type: MoneyRecordType = .withdraw
    var count: Int = 0
    
    override func mapping(map: Map) {
        createTimeDis <- map["createTimeDis"]
        type <- map["type"]
        count <- map["count"]
    }
}

class MoneyRecordGroup: Model {
    var list: [MoneyRecord]?
    
    override func mapping(map: Map) {
        list <- map["list"]
    }
}
