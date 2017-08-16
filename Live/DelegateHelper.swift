//
//  DelegateHelper.swift
//  Live
//
//  Created by lieon on 2017/6/29.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class DelegateHelper: NSObject, QQApiInterfaceDelegate {
    
    func onReq(_ req: QQBaseReq!) {
        print("*********onReq*******")
    }
    
    func onResp(_ resp: QQBaseResp!) {
         print("*********onResp*******")
    }
    
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
         print("*********isOnlineResponse*******")
    }
}

extension DelegateHelper: WeiboSDKDelegate {
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if let res = response as? WBAuthorizeResponse, let userId = res.userID, let accesstoken = res.accessToken {
            print("userID: \(userId), accesstoken:\(accesstoken)")
            let userInfo = [
                "userId": userId,
                "accessToken": accesstoken
            ]
            NotificationCenter.default.post(name: CustomKey.NotificationName.weiboDidLoginNotification, object: self, userInfo: userInfo)
        }
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
}
