//
//  AppConfig.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import ObjectMapper

struct CustomKey {
    struct NotificationName {
        static let loginSuccess = NSNotification.Name.init("LoginSuccess")
        static let loginInvalid = NSNotification.Name.init("loginInvalid")
        static let fastRegisterSuccess = NSNotification.Name(rawValue: "fastRegisterVCHandle")
        static let weiboDidLoginNotification = NSNotification.Name(rawValue: "weiboDidLoginNotification")
        static let wechatDidLoginNotification = NSNotification.Name.init(rawValue: "WechatLoginHandle")
    }
    struct CacheKey {
        static let baseDataKey = "baseDataKey"
        static let regionKey = "regionKey"
    }
    struct URLKey {
         static let baseURL = (Bundle.main.infoDictionary?["BASE_URL"] as? String) ?? ""
        static let webBaseURL = (Bundle.main.infoDictionary?["WEB_BASE_URL"] as? String) ?? ""
        static let baseImageUrl = (Bundle.main.infoDictionary?["BASE_IMAGE_URL"] as? String) ?? ""
    }
    struct Color {
        static let mainBackgroundColor: UInt32 = 0xfafafa
        static let mainColor: UInt32 = 0xffab33
        static let mainBlueColor: UInt32 = 0x00a8fe
        static let tabBackgroundColor: UInt32 = 0x222222
        static let viewBackgroundColor: UInt32 = 0xf2f2f2
        static let redDotColor: UInt32 = 0xFF3824
        static let lineColor: UInt32 = 0xe5e5e5
        static let greyColor: UInt32 = 0xa0a0a0
        static let mainBlackColor: UInt32 = 0x000000
    }
    struct UserDefaultsKey {
        static let session = "sessionInfo"
        static let uuid = "uuid"
        static let userInfo =  "userinfo.archiver"
        static let searchHistory = "searchHistory"
    }
    struct ThirdPartyKey {
        static let qqAppID = "1106254696"
        static let qqAppSecret = "kDKjz1p9jMeQlX9G"
        static let sinaWeiboAppKey = "3825789199"
        static let sinaWeiboAppSecret = "b47aa01fd825551fdb5763d8b4920f75"
        static let sinaWeiboRedirectURI = "https://live.hlhdj.cn/api/oauth/weibo"
        static let sinaWeiboCancelRedirectURI = "https://live.hlhdj.cn/api/oauth/weibo/cannel"
        static let weChatAppID = "wxf0c4e542eb81c4cd"
        static let weChatAppSecret = "155a8487f2b9afe587543863d7ca8a44"
        static let shareSDKKey = "1f056b48347c8"
        static let shareSDKSecret = "09a428ab441589b0df80abe112371b73"
        static let alipayAppID = "2017070507648660"
        static let TIMAPPID = "1253899389"
        static let TIMSdkAppId: Int32 = 1400033866
        static let TIMAccountType: String = "13870"

    }
    struct Description {
        static let wechatDescription = "cn.hlhdj.live"
    }

    // ratioType :xxx // 分辨率类型 0 1280×720，1 1920×1080，2 2k，3 1242×2208，4 750×1334,5 640×1136
    static var Ratiotype: Int {
        let resulX = UIScreen.width * UIScreen.main.scale
        switch resulX {
        case 640:
            return 5
        case 750:
            return 4
        case 1242:
            return 3
        default:
            return 4
        }
    }
    
    struct CustomSize {
        static let shareViewHight: CGFloat = 168
    }
}

class UserSessionInfo: NSObject, Mappable, NSCoding {
    var expiresIn: UInt = 0
    var refreshTokenDate: Date?
    var token: String?
    var refreshToken: String?
    var isLoginSuccess: Bool = false
    var isNewUser: Bool = false
    
    required public init?(map: Map) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.expiresIn = aDecoder.decodeObject(forKey: "expiresIn") as? UInt ?? 0
        self.token = aDecoder.decodeObject(forKey: "token") as? String
        self.refreshToken = aDecoder.decodeObject(forKey: "refreshTokenDate") as? String
    }
   
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.expiresIn, forKey: "expiresIn")
        aCoder.encode(self.token, forKey: "token")
        aCoder.encode(self.refreshToken, forKey: "refreshTokenDate")
    }
    
    func mapping(map: Map) {
        expiresIn <- map["expiresIn"]
        token <- map["token"]
        refreshToken <- map["refreshToken"]
        isNewUser <- (map["code"], BoolNumberTransform())
    }

    static func save(session: UserSessionInfo) {
        print("***save Session*****\(session.toJSON())")
        let data = NSKeyedArchiver.archivedData(withRootObject: session)
        UserDefaults.standard.set(data, forKey: CustomKey.UserDefaultsKey.session)
    }
    
    static func getSession() -> UserSessionInfo {
        guard let data = UserDefaults.standard.value(forKey: CustomKey.UserDefaultsKey.session) as? Data, let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? UserSessionInfo else {
            return UserSessionInfo(JSON: [: ])!
        }
        return info
    }
    
    static func clearInfo() {
        UserDefaults.standard.removeObject(forKey: CustomKey.UserDefaultsKey.session)
    }
}

class AppConfig {
    static func getUUID() -> String {
        if let uuid = UserDefaults.standard.value(forKey: CustomKey.UserDefaultsKey.uuid) as? String {
            return uuid
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: CustomKey.UserDefaultsKey.uuid)
            return uuid
        }
    }
}
