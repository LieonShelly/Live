//
//  MsgHandler.swift
//  Live
//
//  Created by lieon on 2017/6/23.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import UIKit
import PromiseKit
import ObjectMapper

enum IMGroupErrorCode: Int32 {
    case notExist =  10010  //该群已解散
    case hasBeenGroupMember = 10013 // /已经是群成员
    var message: String {
        switch self {
        case .notExist:
            return "该群已解散"
        case .hasBeenGroupMember:
            return "已经是群成员"
        }
    }
}

class MsgHandler: NSObject {
    var recievedMessageCallback: ((IMMessage) -> Void)?
    fileprivate var chatRoomConvsersation: TIMConversation?
    fileprivate var groupID: String?
    
    override init() {
        super.init()
        TIMManager.sharedInstance().add(self)
    }
    
    func joinGrooup() {
         if let userInfo = CoreDataManager.sharedInstance.getUserInfo() {
            let message = IMMessage()
            message.userAction = .enterLive
            message.userId = userInfo.userId
            message.nickName = userInfo.nickName ?? ""
            message.headPic = CustomKey.URLKey.baseImageUrl + (userInfo.avatar ?? "")
            message.msg = ""
            sendMessage(with: message)
        }
     
    }
    
    func sendTextMessage(_ text: String) {
        if let userInfo = CoreDataManager.sharedInstance.getUserInfo() {
            let message = IMMessage()
            message.userAction = .text
            message.userId = userInfo.userId
            message.nickName = userInfo.nickName ?? ""
            message.headPic = CustomKey.URLKey.baseImageUrl + (userInfo.avatar ?? "")
            message.msg = text
            sendMessage(with: message)
        }
    }
    
    func sendMessage(with message: IMMessage) {
        if let text = message.msg, (message.userAction == .danmaku || message.userAction  == .text) && text.isEmpty {
            debugPrint("sendMessage failed, msg length is 0")
            return
        }
        let dic: [String: Any] = message.toJSON()
        let content = dic.toJSONString()
        let textElement = TIMTextElem()
        textElement.text = content
        let msg = TIMMessage()
        msg.add(textElement)
        if let conversation = chatRoomConvsersation {
            conversation.send(msg, succ: { 
                debugPrint("sendMessage success:\(message.userAction)")

            }, fail: { (errorCode, errorMssage) in
                debugPrint("sendMessage failed, cmd:\(message.userAction), code:\(errorCode), errmsg\(String(describing: errorMssage))")
            })
        }
    }

    func joinLiveRoom(with groupID: String) -> Promise<Bool> {
        return Promise { fullfil, reject in
            weak var weakSelf = self
            TIMGroupManager.sharedInstance().joinGroup(groupID, msg: "live", succ: {
                weakSelf?.swithToliveRoom(with: groupID)
                fullfil(true)
            }, fail: { (errorCode, msg) in
                var error = AppError()
                let groupError = IMGroupErrorCode(rawValue: errorCode)
                if groupError == .hasBeenGroupMember {
                    fullfil(true)
                } else {
                    error.message = groupError?.message ?? "join error: unknown"
                    reject(error)
                }
            })
        }
    }
    
    func quitLiveRoom() -> Promise<Bool> {
        return Promise { fullfil, reject in
            guard let groupID = groupID else {
                var error = AppError()
                error.message = "quit room fail, gropID is nil"
                reject(error)
                return
            }
            TIMGroupManager.sharedInstance().quitGroup(groupID, succ: { 
                debugPrint("quitGroup success,group id:\(groupID)")
            }, fail: { (errorCode, msg) in
                 var error = AppError()
                error.message = msg ?? "quit faild: unkown"
                reject(error)
            })
        }
    }
    
    fileprivate func swithToliveRoom(with groupID: String) {
        self.groupID = groupID
        chatRoomConvsersation = TIMManager.sharedInstance().getConversation(TIMConversationType.GROUP, receiver: groupID)
    }
    
    func createLiveRoom(with groupID: String) -> Promise<String> {
        return Promise { fullfill, reject in
            TIMGroupManager.sharedInstance().createGroup("AVChatRoom", groupId: groupID, groupName: "live", succ: { [unowned self](groupID) in
                self.swithToliveRoom(with: groupID!)
                fullfill(groupID!)
            }) { (errorCode, errorMessage) in
                var error = AppError()
                error.message = errorMessage ?? "quit faild: unkown"
                reject(error)
            }
        }
    }
}

extension MsgHandler: TIMMessageListener {
    func onNewMessage(_ msgs: [Any]!) {
        guard let messages = msgs as? [TIMMessage] else {
            return
        }
        messages.forEach { messgae in
            let conType = messgae.getConversation().getType()
            switch conType {
            case .C2C: /// 连麦模块
                break
            case  .GROUP:/// 群聊
                if messgae.getConversation().getReceiver() == self.groupID {
                    for i in 0 ..< messgae.elemCount() {
                        guard  let element = messgae.getElem(i) else { continue }
                        if element.isKind(of: TIMTextElem.self) {
                            if let textElement = element as? TIMTextElem, let messageText = textElement.text, let textMessage = Mapper<IMMessage>().map(JSONString: messageText) {
                                let messageType = textMessage.userAction
                                switch messageType {
                                case .enterLive:
                                        textMessage.msg = "进入直播间"
                                case .exitLive:
                                        textMessage.msg = "退出直播间"
                                case .like: // 点赞
                                    break
                                case .danmaku: // 弹幕
                                    break
                                case .groupStstem:
                                    break
                                case .attentAnchor:
                                    break
                                default:
                                    break
                                }
                                recievedMessageCallback?(textMessage)
                            }
                        }
                    }
                    
                }
            case .SYSTEM: /// 系统消息
                break
            }
        }
    }
}

class IMMessage: Model {
    var userAction: AVIMCommand = .none
    var userId: Int = 0
    var nickName: String?
    var msg: String?
    var headPic: String?
    var level: Int = 0
    
    override func mapping(map: Map) {
        userAction <- map["userAction"]
        userId <- map["userId"]
        nickName <- map["nickName"]
        msg <- map["msg"]
        headPic <- map["headPic"]
        level <- map["level"]
    }
}
