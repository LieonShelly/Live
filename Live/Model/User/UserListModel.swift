//
//  UserListModel.swift
//  Live
//
//  Created by fanfans on 2017/7/11.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

class UserListGroup: Model {
    var count: Int = 0
    var listGroup: [UserModel]?
    
    override func mapping(map: Map) {
        listGroup <- map["list"]
        count <- map["count"]
    }
}

class UserModel: Model {
    
    var userId: Int = 0
    var nickName: String?
    var avatar: String?
    var isFollowed: Bool = false
    var level: Int = 0
    var fansCount: Int = 40
    
    override func mapping(map: Map) {
        userId <- map["id"]
        nickName <- map["nickName"]
        avatar <- map["avastar"]
        level <- map["level"]
        fansCount <- map["fansCount"]
        isFollowed <- map["isFollowed"]
        
    }
}
