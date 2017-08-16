//
//  UserInfoManagerViewModel.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper
import PromiseKit

class UserInfoManagerViewModel {
    var userInfo: UserInfo?
    
    /// 芝麻信用是否认证通过
    func requesZhimaValidResult(with param: ZhimaCertifyResultQueryParam) -> Promise<Bool> {
        let req: Promise<ZhimaCertifyResponse> = RequestManager.request(.endpoint(UserPath.approveZhimaQuery, param: param), needToken: .true)
       return req.then { response -> Bool in
            if let result = response.object?.isApprove {
                return result
            }
            return false
        }
    }
    
    /// 芝麻信用认证
    func requestZhimaValid(with param: IDVlidateRequestParam) -> Promise<ZhimaCertifyResponse> {
        let req: Promise<ZhimaCertifyResponse> = RequestManager.request(.endpoint(UserPath.approveZhima, param: param), needToken: .true)
        return req
    }
    
    ///  身份证实名认证
    func requstIDValid(with param: IDVlidateRequestParam) -> Promise<NullDataResponse> {
        let req: Promise<NullDataResponse> =  RequestManager.request(.endpoint(UserPath.approve, param: param), needToken: .true)
        return req
    }
 
  func requstUserInfo() -> Promise<Bool> {
        let req: Promise<UserInfoResponse> = RequestManager.request(.endpoint(UserPath.getInfo, param: nil), needToken: .true)
       return req.then { response -> Bool in
            if let users = response.object, let info = users.user {
                self.userInfo = info
                CoreDataManager.sharedInstance.save(userInfo: info)
                return true
            }
            return false
        }
    }
    
    func requstModifyUserInfo(with param: ModiftUserInfoParam) -> Promise<NullDataResponse> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(UserPath.modifyUserInfo, param: param), needToken: .true)
        req.then { (response) -> Void in
        }.catch { (_) in }
        return req
    }
}
