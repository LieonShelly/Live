//
//  UserInfo.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper

class RegisterInfo: Model {
    var status: RegiseterStatus = .success
    
    override func mapping(map: Map) {
        status <- map["status"]
    }
}
class UserInfo: NSObject, Mappable, NSCoding {
    var avatar: String?
    var userId: String?
    var name: String?
    var phone: String?
    var uuid: String?
    var gender: Gender = .unknown
    var coverURL: String?
    
    required public init?(map: Map) {
        
    }
    
    required  init?(coder aDecoder: NSCoder) {
        self.avatar = aDecoder.decodeObject(forKey: "avastar") as? String
        self.userId = aDecoder.decodeObject(forKey: "id") as? String
        self.name = aDecoder.decodeObject(forKey: "nickName") as? String
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.avatar, forKey: "avastar")
        aCoder.encode(self.userId, forKey: "id")
        aCoder.encode(self.name, forKey: "nickName")
        aCoder.encode(self.phone, forKey: "phone")
        aCoder.encode(self.uuid, forKey: "uuid")
    }
    
     func mapping(map: Map) {
        avatar <- map["avastar"]
        userId <- map["id"]
        name <- map["nickName"]
        phone <- map["phone"]
    }
}
