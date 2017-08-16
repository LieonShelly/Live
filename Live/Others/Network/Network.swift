//
//  Network.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper
import Device
import UIKit
import Alamofire

public class Header: Model {
    public var token: String {
        get { return UserSessionInfo.getSession().token ?? ""}
        set { }
    }
    public var deviceUUID: String {
        get { return AppConfig.getUUID() }
        set { }
    }
    public var deviceType: String {
        get { return UIDevice.current.systemVersion  }
        set { }
    }
    public var deviceName: String {
        get { return Device.version().rawValue }
        set { }
    }
    public var contentType: String = "application/json"
    
    public override func mapping(map: Map) {
        token <- map["token"]
        deviceUUID <- map["deviceId"]
        deviceType <- map["deviceType"]
        deviceName <- map["deviceName"]
        contentType <- map["Content-Type"]
        
    }
}

public enum UserPath: UserEndPointProtocol {
    case login
    case fastLogin
    case registerValidatePhone
    case smsCaptcha
    case checkCapcha
    case register
    case thirdPartyRegiseterQQ
    case thirdPartyRegiseterWechat
    case thirdPartyRegiseterWeibo
    case findPassword
    case thirdPartyLoginQQ
    case thirdPartyLoginWechat
    case thirdPartyLoginSina
    case thirdPartyBindQQ
    case thirdPartyBindWechat
    case thirdPartyBindWeibo
    case approve
    case getInfo
    case modifyUserInfo
    case feedback
    case approveZhima
    case approveZhimaQuery
    case logout
    case exchangePhoneNum
    
    var method: HTTPMethod {
        switch self {
        case .getInfo:
            return .get
        case .logout:
            return .get
        default:
            return .post
        }
    }
    
    var path: String {
        return"/user"
    }
    
    var endpoint: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/reg"
        case .registerValidatePhone:
            return "/reg/validatePhone"
        case .smsCaptcha:
            return "/sms/captcha"
        case .checkCapcha:
            return "/check/captcha"
        case .thirdPartyRegiseterQQ:
            return "/fastCreate/qq"
        case .thirdPartyRegiseterWechat:
            return "/fastCreate/wechat"
        case .thirdPartyRegiseterWeibo:
            return "/fastCreate/weibo"
        case .findPassword:
            return "/setPass"
        case .fastLogin:
            return "/login/captcha"
        case .thirdPartyLoginQQ:
            return "/login-qq"
        case .thirdPartyLoginSina:
            return "/login-weibo"
        case .thirdPartyLoginWechat:
            return "/login-wechat"
        case .thirdPartyBindQQ:
            return "/binding/qq"
        case .thirdPartyBindWechat:
            return "/binding/wechat"
        case .thirdPartyBindWeibo:
            return "/binding/weibo"
        case .approve:
            return "/approve"
        case .getInfo:
            return "/info"
        case . modifyUserInfo:
            return "/info"
        case .feedback:
            return "/recommend/add"
        case .approveZhima:
            return "/approveZhima"
        case .approveZhimaQuery:
            return "/approveZhimaQuery"
        case .logout:
            return "/logout"
        case .exchangePhoneNum:
            return "/exchangePhone"
        }
    }
}

class UserRequestParam: Model {
    var username: String?
    var password: String?
    var code: String?
    var accessToken: String?
    var openId: String?
    var unionId: String?
    var thirdPartyInfo: [String: Any]?
    var capchaCodeType: CaptchaType?
    var phone: String?
    
    override func mapping(map: Map) {
        username <- map["username"]
        password <- map["password"]
        code <- map["code"]
        accessToken <- map["accessToken"]
        openId <- map["openId"]
        unionId <- map["unionId"]
        thirdPartyInfo <- map["info"]
        capchaCodeType <- map["type"]
        phone <- map["phone"]
    }
}

/*
 phone:手机号码
 type :类型
 code:验证码
 */
class SmsCaptchaParam: Model {
    var type: CaptchaType = .register
    var phone: String?
    var code: String?
    override func mapping(map: Map) {
        type <- map["type"]
        phone <- map["phone"]
        code <- map["code"]
    }
}

enum CommonPath: ContentEndPointProtocol {
    case  getQQValidationCode
    case  getWeiboValidationCode
    case  getWechatValidationCode
    
    var path: String {
        return "/commons"
    }
    
    var endpoint: String {
       return "/validate/bindThird"
    }
}

class GetValidationCodeParam: Model {
    var type: ThirdPartyType = .none
    var openId: String?
    
    override func mapping(map: Map) {
        type <- map["type"]
        openId <- map["openId"]
    }
}

class BroadcastParam: Model {
    var cover: String?
    var latitude: Double = 30.67
    var longitude: Double = 104.06
    var city: String? = "成都"
    var name: String?
    
    override func mapping(map: Map) {
        cover <-  map["cover"]
        latitude <- map["lat"]
        longitude <- map["lng"]
        city <- map["city"]
        name <- map["name"]
    }
}

enum BroadcatPath: UserEndPointProtocol {
    case startLive
    case endLive
    case deleteeBroadcast
    case comebackLive
    
    var path: String {
        return "/live"
    }
    
    var endpoint: String {
        switch self {
        case .startLive:
            return "/startLive"
        case .endLive:
            return "/endLive"
        case .deleteeBroadcast:
            return "/" + "\(LiveListRequstParam.liveId)" + "/delete"
        case .comebackLive:
            return "/comebackLive"
        }
    }
}

enum RoomPath: UserEndPointProtocol {
    case enterLiveRoom
    case leaveLiveRoom
    case getLiveRealTimeInfo
    
    var path: String {
        return "/live"
    }
    
    var endpoint: String {
        switch self {
        case .enterLiveRoom:
            return "/" + "\(RoomRequstParam.RoomID ?? "")" + "/comeIn"
        case .leaveLiveRoom:
            return "/" + "\(RoomRequstParam.RoomID ?? "")" + "/leaveOut"
        case .getLiveRealTimeInfo:
            return "/" + "\(RoomRequstParam.RoomID ?? "")" + "/info"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLiveRealTimeInfo:
            return .get
        default:
            return .post
        }
    }
}

enum LiveListPath: ContentEndPointProtocol {
    case live
    case nearby
    case byUserId
    
    var path: String {
        return "/live"
    }
    
    var endpoint: String {
        switch self {
        case .live:
            return ""
        case .nearby:
            return "/distance"
        case .byUserId:
            return "/user" + "/" + "\(LiveListRequstParam.userId)"
        }
    }
}

class LiveListRequstParam: Model {
   static  var userId: Int = 0
    static var liveId: Int = 0
    var page: Int = 0
    var limit: Int = 20
    var keywords: String?
    var orderBy: OrderType?
    var longitude: Double?
    var latitude: Double?
    var sex: Gender?
    
    override func mapping(map: Map) {
        page <- map["page"]
        limit <- map["limit"]
        keywords <- map["keywords"]
        orderBy <- map["orderBy"]
        latitude <- map["lat"]
        longitude <- map["lng"]
        sex <- map["sex"]
    }
}

class IDVlidateRequestParam: Model {
    var trueName: String?
    var idCardNumber: String?
    
    override func mapping(map: Map) {
        trueName <- map["trueName"]
        idCardNumber <- map["idCard"]
    }
    
}

class ModiftUserInfoParam: Model {
    var avatar: String?
    var nickName: String?
    var sex: Gender = .female
    var birthday: String?
    
    override func mapping(map: Map) {
        avatar <- map["avastar"]
        nickName <- map["nickName"]
        sex <- map["sex"]
        birthday <- map["birthday"]
    }
}

class FeedbackRequstParam: Model {
    var content: String?
    var pictures: [String]?
    
    override func mapping(map: Map) {
        content <- map["content"]
        pictures <- map["picture"]
    }
}

class ZhimaCertifyResult: Model {
    var certifyNumber: String?
    var certifyURL: String?
    var appId: String?
    var isApprove: Bool = false
    
    override func mapping(map: Map) {
        certifyNumber <- map["bizNo"]
        certifyURL <- map["generateCertifyUrl"]
        appId <- map["appId"]
        isApprove <- map["isApprove"]
    }
}

class ZhimaCertifyResultQueryParam: Model {
    var certifyNumber: String?
    
    override func mapping(map: Map) {
        certifyNumber <- map["bizNo"]
    }
}

class RoomRequstParam: Model {
    static var RoomID: String?
}

class AnchorRequestParm: Model {
  static  var anchorId: Int = 0
    
}

enum AnchorPath: ContentEndPointProtocol {
    case getInfo
    
    var path: String {
        return "/user"
    }
    
    var endpoint: String {
        switch self {
        case .getInfo:
            return "/" + "\(AnchorRequestParm.anchorId)" + "/info"
        }
    }
}

class CollectionRequstParam: Model {
    var userId: Int = 0
    var liveId: Int?
    
    override func mapping(map: Map) {
        userId <- map["userId"]
        liveId <- map["liveId"]
    }
}

enum CollectionPath: UserEndPointProtocol {
    case addfollow
    case disFollow
    case followList
    case recommendList
    case userSearch
    
    var method: HTTPMethod {
        switch self {
        case .followList,
             .recommendList,
             .userSearch:
            return .get
        default:
             return .post
        }
    }
    
    var path: String {
        return "/follow"
    }
    var endpoint: String {
        switch self {
        case .addfollow:
            return "/addfollow"
        case .disFollow:
            return "/disFollow"
        case .followList:
            return ""
        case .recommendList:
            return "/user/recommend"
        case .userSearch:
            return "/user/search"
        }
    }
}

class UserListRequstParam: Model {
    var page: Int = 0
    var limit: Int = 20
    var userId: Int?
    var type: UserListType = .fans
    
    override func mapping(map: Map) {
        page <- map["page"]
        limit <- map["limit"]
        userId <- map["userId"]
        type <- map["type"]
    }
}

enum  RechargeEnvironment: Int {
    case pruduct = 0
    case test = 1
}

class RechargeRequestParam: Model {
    var environment: RechargeEnvironment = .test
    var receipt: String?
    
    override func mapping(map: Map) {
        environment <- map["chooseEnv"]
        receipt <- map["receipt-data"]
    }
}

enum MoneyPath: UserEndPointProtocol {
    case rechargeBeans
    case getPickupInfo
    case applyPickUp
    case getMoneyLogList
    
    var path: String {
        return "/money"
    }
    
    var endpoint: String {
        switch self {
        case .rechargeBeans:
             return "/verifyIapCertificate"
        case .getPickupInfo:
            return "/getPickupInfo"
        case .applyPickUp:
            return "/applyPickUp" + "/" + ApplyPickUpParam.type.rawValue
        case .getMoneyLogList:
            return "/getMoneyLogList"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMoneyLogList:
            return .get
        default:
            return .post
        }
    }
}

enum GiftPath: UserEndPointProtocol {
    case getList
    case give
    
    var path: String {
        return "/gift"
    }
    
    var endpoint: String {
        switch self {
        case .getList:
            return "/list"
        case .give:
            return "/give"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getList:
            return .get
        default:
            return .post
        }
    }
}

class GiftRequstParam: Model {
    var ratioType: Int = CustomKey.Ratiotype
    var toId: Int?
    var gitftId: Int?
    var liveId: Int?
    
    override func mapping(map: Map) {
        toId <- map["toId"]
        gitftId <- map["giftId"]
        liveId <- map["liveId"]
        ratioType <- map["ratioType"]
    }
}

class ChatRequestParam: Model {
    var liveId: Int = 0
    
    override func mapping(map: Map) {
        liveId <- map["liveId"]
    }
}

enum ChatPath: UserEndPointProtocol {
    case sendDanmaku
    
    var path: String {
        return "/chat"
    }
    
    var endpoint: String {
        switch self {
        case .sendDanmaku:
            return "/barrage"
        }
    }
}

class ApplyPickUpParam: Model {
    static var type: PayType = .alipay
    var pickupMoney: String?
    var payeeAccount: String?
    var realName: String?
    var mobile: String?
    var code: String?
    var payType: PayType = .alipay {
        didSet {
            ApplyPickUpParam.type = payType
        }
    }
    
    override func mapping(map: Map) {
        pickupMoney <- map["pickupMoney"]
        payeeAccount <- map["payeeAccount"]
        realName <- map["realName"]
        mobile <- map["mobile"]
        code <- map["code"]
    }
}

class MoneyInoutRecordParam: Model {
    var page: Int = 0
    var limit: Int = 0
    var type: MoneyRecordType = .withdraw
    
    override func mapping(map: Map) {
        page <- map["page"]
        limit <- map["limit"]
        type <- map["type"]
    }
}
