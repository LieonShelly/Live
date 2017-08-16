//
//  RoomViewModel.swift
//  Live
//
//  Created by lieon on 2017/7/10.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import PromiseKit
import RxCocoa
import RxDataSources
import RxSwift
import YYText
import Kingfisher

class RoomViewModel {
    lazy var recievedBigGiftMessages: [IMMessage] = [IMMessage]()
    lazy var sendedBigGift: [Gitft] = [Gitft]()
    var animatingBigGiftIndex: Int?
    var room: LiveListModel?
    var cellHeights: [CGFloat] = [CGFloat]()
    lazy var attributeMessages: [NSAttributedString] = [NSAttributedString]()
    var followAnchorAction: ((IMMessage) -> Void)?
    var messageHandler: MsgHandler = MsgHandler()
    init() {
        let myMessage = IMMessage()
        myMessage.msg = "欢迎来到哆集直播，请文明交流，发布谩骂，低俗广告，政治内容将被封号\n☆网警24小时巡查☆"
        myMessage.userAction = .groupStstem
        caculateTextMessageHeight(myMessage)
        transFormIIMessgae(myMessage)
    }
    
    /// 进入房间
    func requestEnterLiveRoom(with roomID: String) -> Promise<Bool> {
        RoomRequstParam.RoomID = roomID
        let req: Promise<LiveRoomResponse> = RequestManager.request(.endpoint(RoomPath.enterLiveRoom, param: nil), needToken: .true)
       return req.then { (response) -> Bool in
            if let response = response.object, let _ = response.result {
                return true
            }
            return false
        }
    }
    
    /// 退出房间
    func requestLeaveLiveRoom(with roomID: String) -> Promise<NullDataResponse> {
         RoomRequstParam.RoomID = roomID
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(RoomPath.leaveLiveRoom, param: nil), needToken: .true)
        return req
    }
    
    /// 关注
    func collectionLiver(with param: CollectionRequstParam) -> Promise<Bool> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(CollectionPath.addfollow, param: param), needToken: .true)
        let valid = req.then { value -> Bool in
            return value.result == .success ? true: false
        }
        return valid
    }
    
    ///  取消关注
    func cancleCollectionLiver(with param: CollectionRequstParam) -> Promise<Bool> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(CollectionPath.disFollow, param: param), needToken: .true)
        let valid = req.then { value -> Bool in
            return value.result == .success ? true: false
        }
        return valid
    }
    
    /// 登录聊天IM
    func loginRoom() -> Promise<Bool> {
        return Promise { fullfill, reject in
            guard let userInfo = CoreDataManager.sharedInstance.getUserInfo()  else {
                var error = AppError()
                error.message = "UserInfo is nil"
                reject(error)
                return
            }
            let loginParam = TIMLoginParam()
            loginParam.identifier = "user_" + "\(userInfo.userId )"
            loginParam.userSig = userInfo.userSign ?? ""
            loginParam.appidAt3rd = "\(CustomKey.ThirdPartyKey.TIMSdkAppId)"
            TIMManager.sharedInstance().login(loginParam, succ: {
                fullfill(true)
            }, fail: { (errorCode, errorMessage) in
                print(errorCode)
                var error = AppError()
                error.message = errorMessage ?? "Login Room Failed"
                reject(error)
            })
            
        }
    }
}

extension RoomViewModel {
    /// 获取礼物列表
    func requestGiftlist() -> Promise<GiftGroup> {
        let param = GiftRequstParam()
        let req: Promise<GiftGroupResponse> = RequestManager.request(Router.endpoint(GiftPath.getList, param: param))
        return req.then(execute: { response -> GiftGroup in
            guard let group = response.object else {
             return GiftGroup()
            }
            return group
        })
    }
    
    /// 赠送礼物
    func requestGiveGift(with param: GiftRequstParam) -> Promise<NullDataResponse> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(GiftPath.give, param: param))
        return req
    }
    
}

extension RoomViewModel {
    /// 计算文本消息的高度
    func caculateTextMessageHeight(_ message: IMMessage) {
        switch message.userAction {
        case .groupStstem:
            if let msg = message.msg {
                /// 前后补齐空格
                let text = "  " + msg + "  "
                let nss = NSString(string: text)
                /// 计算文本高度
                let rect = nss.boundingRect(with: CGSize(width: UIScreen.width - 80, height: 90000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.5)], context: nil)
                /// 13 * 2 表示顶部和底部间距
                self.cellHeights.append(rect.height + 13 * 2)
            }
        case .enterLive, .attentAnchor:
            if let nickName = message.nickName, let msg = message.msg {
                let text = "  " + "\(message.level)" + " " + nickName + ": " + msg + "  "
                let nss = NSString(string: text)
                let rect = nss.boundingRect(with: CGSize(width: UIScreen.width - 100, height: 90000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.5)], context: nil)
                self.cellHeights.append(rect.height + 10 * 2)
            }
        case .text, .danmaku:
            if let nickName = message.nickName, let msg = message.msg {
                let text = "  " + "\(message.level)" + " " + nickName + ": " + msg + "  "
                let nss = NSString(string: text)
                let rect = nss.boundingRect(with: CGSize(width: UIScreen.width - 100, height: 90000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12.5)], context: nil)
                self.cellHeights.append(rect.height + 10 * 2)
            }
        default:
            break
            
        }
        
    }
    
    /// 将文本消息转换为富文本
    func transFormIIMessgae(_ message: IMMessage) {
        switch message.userAction {
        case .groupStstem:
            if let msg = message.msg {
                let pad = NSMutableAttributedString(string: " ")
                let textMessage = NSMutableAttributedString(string: msg)
                textMessage.yy_font = UIFont.systemFont(ofSize: 12.5)
                textMessage.yy_color = UIColor(hex:0xf05b1a)
                textMessage.append(pad)
                textMessage.yy_alignment = .left
                textMessage.yy_lineSpacing = 3
                textMessage.yy_lineBreakMode = .byWordWrapping
                textMessage.yy_paragraphSpacingBefore = 3
                attributeMessages.append(textMessage)
            }
        case .enterLive:
            let pad = NSMutableAttributedString(string: " ")
            pad.yy_font = UIFont.systemFont(ofSize: 12.5)
            let text = NSMutableAttributedString()
            let levelStr = NSMutableAttributedString(string: "  " + "V" + "\( message.level)" + "  ")
            levelStr.yy_font = UIFont.systemFont(ofSize: 12.5)
            levelStr.yy_color = UIColor.white
            let backgroudBoder = YYTextBorder()
            backgroudBoder.fillColor = message.level <= 5 ? UIColor(hex: 0xff70ad) : UIColor(hex: 0xab68ff)
            backgroudBoder.cornerRadius = 15
            backgroudBoder.lineJoin = .bevel
            levelStr.yy_setTextBackgroundBorder(backgroudBoder, range: NSRange(location: 0, length: ( "  " + "V" + "\( message.level)" + "  ").characters.count))
            text.append(levelStr)
            text.append(pad)
            if let nickiname = message.nickName, let msg = message.msg {
                let textMessage = NSMutableAttributedString(string: nickiname + msg)
                textMessage.yy_font = UIFont.systemFont(ofSize: 12.5)
                textMessage.yy_color = UIColor(hex: 0xe2e46c)
                text.append(textMessage)
            }
            text.append(pad)
            text.yy_alignment = .left
            text.yy_lineSpacing = 3
            text.yy_lineBreakMode = .byWordWrapping
            text.yy_paragraphSpacingBefore = 3
            attributeMessages.append(text)
        case .text, .danmaku:
            let pad = NSMutableAttributedString(string: " ")
            pad.yy_font = UIFont.systemFont(ofSize: 12.5)
            let text = NSMutableAttributedString()
            let levelStr = NSMutableAttributedString(string: "  " + "V" + "\( message.level)" + "  ")
            levelStr.yy_font = UIFont.systemFont(ofSize: 12.5)
            levelStr.yy_color = UIColor.white
            let backgroudBoder = YYTextBorder()
            backgroudBoder.fillColor = message.level <= 5 ? UIColor(hex: 0xff70ad) : UIColor(hex: 0xab68ff)
            backgroudBoder.cornerRadius = 15
            backgroudBoder.lineJoin = .bevel
            levelStr.yy_setTextBackgroundBorder(backgroudBoder, range: NSRange(location: 0, length: ( "  " + "V" + "\( message.level)" + "  ").characters.count))
            text.append(levelStr)
            text.append(pad)
            if let nickiname = message.nickName, let msg = message.msg {
                let textMessage = NSMutableAttributedString(string: nickiname + ": " + msg)
                textMessage.yy_font = UIFont.systemFont(ofSize: 12.5)
                textMessage.yy_color = UIColor.white
                text.append(textMessage)
                let vipStr = "\( message.level)"
                text.yy_setColor(UIColor(hex: 0xff8f00), range: NSRange(location: 6 + vipStr.characters.count, length: nickiname.characters.count + 1))
                print(text.string)
            }
            text.append(pad)
            
            text.yy_alignment = .left
            text.yy_lineSpacing = 3
            text.yy_lineBreakMode = .byWordWrapping
            text.yy_paragraphSpacingBefore = 3
            attributeMessages.append(text)
            
        case .attentAnchor:
            let pad = NSMutableAttributedString(string: " ")
            pad.yy_font = UIFont.systemFont(ofSize: 12.5)
            let text = NSMutableAttributedString()
            let levelStr = NSMutableAttributedString(string: "  " + "V" + "\( message.level)" + "  ")
            levelStr.yy_font = UIFont.systemFont(ofSize: 12.5)
            levelStr.yy_color = UIColor.white
            let backgroudBoder = YYTextBorder()
            backgroudBoder.fillColor = message.level <= 5 ? UIColor(hex: 0xff70ad) : UIColor(hex: 0xab68ff)
            backgroudBoder.cornerRadius = 15
            backgroudBoder.lineJoin = .bevel
            levelStr.yy_setTextBackgroundBorder(backgroudBoder, range: NSRange(location: 0, length: ( "  " + "V" + "\( message.level)" + "  ").characters.count))
            text.append(levelStr)
            text.append(pad)
            if let nickiname = message.nickName, let msg = message.msg {
                let textnickName = NSMutableAttributedString(string: nickiname + ": ")
                textnickName.yy_font = UIFont.systemFont(ofSize: 12.5)
                textnickName.yy_color = UIColor.white
                text.append(textnickName)
                
                let textnicMsg = NSMutableAttributedString(string: msg)
                textnicMsg.yy_font = UIFont.systemFont(ofSize: 12.5)
                textnicMsg.yy_color = UIColor(red: 0.0, green: 239.0 / 255.0, blue: 232.0 / 255.0, alpha: 1)
                text.append(textnicMsg)
            }
            text.append(pad)
            text.yy_alignment = .left
            text.yy_lineSpacing = 3
            text.yy_lineBreakMode = .byWordWrapping
            text.yy_paragraphSpacingBefore = 3
            attributeMessages.append(text)
            
        default:
            break
        }
    }
    
    /// 发送弹幕扣减哆豆
    func requestSendDanmaku(with param: ChatRequestParam) -> Promise<NullDataResponse> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(ChatPath.sendDanmaku, param: param), needToken: .true)
        return req
    }
}

extension RoomViewModel {
    /// 直播实时信息
    func requestRealTime(with roomID: String) -> Promise<LiveRealTimeInfo> {
         RoomRequstParam.RoomID = roomID
        let req: Promise<LiveRealTimeResponse> = RequestManager.request(.endpoint(RoomPath.getLiveRealTimeInfo, param: nil))
        return req.then(execute: { response -> LiveRealTimeInfo in
            if let object = response.object, let info = object.info {
                return info
            }
            return LiveRealTimeInfo()
        })
    }
}
