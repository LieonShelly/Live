//
//  Enum.swift
//  Live
//
//  Created by lieon on 2017/6/21.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable redundant_string_enum_value
// swiftlint:disable identifier_name

import Foundation
import ObjectMapper

enum  ResponseType: String {
    case success = "ok"
    case fail = "fail"
}
enum ErrorCodeType: String {
    case loginInValid = "1001"
    case error404 = "-1011"
    case timeout = "-1001"
    case disconnect = "-1009"
    case none = "0"
    case pointUnavailable = "2001"
}

enum Gender: Int {
    case unknown = -1
    case male = 1
    case female = 0
    
    var title: String {
        switch self {
        case .male:
            return "男"
        case .female:
            return "女"
        default:
          return  ""
        }
    }
}

enum AVIMCommand: Int {
    // 无事件
    case none = 0
    // 文本消息
    case text = 1
    // 用户加入直播
    case enterLive = 2
    // 用户推出直播
    case exitLive = 3
    // 点赞消息
    case like = 4
    // 弹幕消息
    case danmaku = 5
    // 关注主播
    case attentAnchor = 6
    //  系统提示相关
    case groupStstem = 7
    //  普通礼物消息
    case commonGift = 8
    ///  火箭礼物
    case bigGift = 9
}

enum CaptchaType: String {
    case register = "1"
    case phoneNumLogin = "2"
    case changePhoneNum = "3"
    case findPassword = "4"
    case setPassword = "5"
    case none = "0"
    case livePickupCash = "6"
}

enum SessionHandleType {
    case normal(UserPath, UserRequestParam)
    case QQ(UserPath, UserRequestParam)
    case wechat(UserPath, UserRequestParam)
    case weibo(UserPath, UserRequestParam)
    
    var path: UserEndPointProtocol {
        switch self {
        case .normal(let path, _):
            return path
        case .QQ(let path, _):
            return path
        case .wechat(let path, _):
            return path
        case .weibo(let path, _):
            return path
        }
    }
    
    var param: UserRequestParam {
        switch self {
        case .normal(_, let param):
            return param
        case .QQ(_, let param):
            return param
        case .wechat(_, let param):
            return param
        case .weibo(_, let param):
            return param
        }
    }
    
    var title: String {
        switch self {
        case .normal:
            return "哆集登录"
        case .QQ:
            return "QQ"
        case .wechat:
            return "微信"
        case .weibo:
            return "微博"
        }
    }
}
/*
 "status":0 //0表示未注册；1表示已注册
 */
enum RegiseterStatus: Int {
    case success = 1
    case failed = 0
}

enum ThirdPartyType: String {
    case qq = "qq"
    case wechat = "wechat"
    case weibo = "weibo"
    case none = "none"
}

enum UserListType: String {
    case fans = "fans"
    case attention = "follows"
    
    var title: String {
        switch self {
        case .fans:
            return "粉丝"
        case .attention:
            return "关注"
        }
    }
    var requestStr: String {
        switch self {
        case .fans:
            return "fans"
        case .attention:
            return "follows"
        }
    }
}

enum LiveSattus: Int {
    case stop = 0
    case living = 1
}

enum OrderType: String {
    case byNew = "new"
    case byHot = "hot"
    case byNearby = "nearby"
}

enum ListLiveType: Int {
    case living = 1
    case record = 0
    case none = -1
    
    var title: String {
        switch self {
        case .living:
            return "直播中"
        case .record:
            return "回放中"
        default:
            return ""
        }
    }
    
    var displayColor: UIColor {
        switch self {
        case .living, .none:
            return UIColor(hex: CustomKey.Color.mainColor)
         case .record:
            return UIColor(hex: 0x14ecff)
        }
    }
}

enum PayType: String {
    case alipay = "alipay"
    case wechatPay = "wechatPay"
}

enum MoneyRecordType: Int {
    case withdraw = 0
    case recharge = 1
    
    var title: String {
        switch self {
        case .withdraw:
            return "提现"
        case .recharge:
            return "充值"
        }
    }
    
    var markStr: String {
        switch self {
        case .withdraw:
            return "-"
        case .recharge:
            return "+"
        }
    }
}

enum GiftType: Int {
    case common = 0
    case bigGift = 1
    
    var userAction: AVIMCommand {
        switch self {
        case .common:
            return .commonGift
        case .bigGift:
            return .bigGift
        }
    }
}
