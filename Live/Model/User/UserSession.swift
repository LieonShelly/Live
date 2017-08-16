//
//  UserSession.swift
//  Live
//
//  Created by lieon on 2017/6/28.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import ObjectMapper

class UserGroup: Model {
    var user: UserInfo?
    
    override func mapping(map: Map) {
        user <- map["user"]
    }
    
}
class RegisterInfo: Model {
    var status: RegiseterStatus = .success
    var isNewUser: Bool = false
    
    override func mapping(map: Map) {
        status <- map["status"]
        isNewUser <- (map["code"], BoolNumberTransform())
    }
}

class Validation: Model {
    var code: String?
    
    override func mapping(map: Map) {
        code <- map["code"]
    }
}

class UserInfo: Model {
    var userId: Int = 0
    var nickName: String?
    var avatar: String?
    var email: String?
    var phone: String?
    var gender: Gender = .unknown
    var birthday: String?
    var isApprove: Bool = false
    var follow: Int = 0
    var fans: Int = 0
    var point: Int = 0
    var level: Int = 0
    var userSign: String?
    var isComplete: Bool = false
    var trueName: String?
    var liveNo: String?
    var giveOut: String?
    
    override func mapping(map: Map) {
        userId <- map["id"]
        nickName <- map["nickName"]
        avatar <- map["avastar"]
        email <- map["email"]
        phone <- map["phone"]
        gender <- map["sex"]
        follow <- map["follow"]
        birthday <- map["birthday"]
        isApprove <- (map["approve"], BoolNumberTransform())
        fans <- map["beFollow"]
        point <- map["point"]
        level <- map["level"]
        isComplete <- (map["isComplete"], BoolNumberTransform())
        trueName <- map["trueName"]
        userSign <- map["userSign"]
        liveNo <- map["liveNo"]
        giveOut <- map["liveNo"]
    }
}
