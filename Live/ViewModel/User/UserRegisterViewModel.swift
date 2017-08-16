//
//  UserRegisterViewModel.swift
//  Live
//
//  Created by lieon on 2017/6/26.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

class UserSessionViewModel {
    
    func validate(phoneNum: String) -> Promise<Bool> {
        let param = UserRequestParam()
        param.username = phoneNum
        let req: Promise<RegisterInfoResponse> = RequestManager.request(.endpoint(UserPath.registerValidatePhone, param: param), needToken: .false)
      let vaildate =  req.then { value -> Bool in
            if let object = value.object {
                print(object)
                return object.status == .success ? true: false
            }
            return false
        }
        return vaildate
    }
    
    func sendCaptcha(phoneNum: String, type: CaptchaType) -> Promise<Bool> {
        let param = SmsCaptchaParam()
        param.phone = phoneNum
        param.type =  type
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(UserPath.smsCaptcha, param: param), needToken: .false)
       let valid = req.then { value -> Bool in
            return value.result == .success ? true: false
        }
        return valid
    }
    
    func  checkCaptcha(param: SmsCaptchaParam) -> Promise<Bool> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(UserPath.checkCapcha, param: param), needToken: .false)
        let valid = req.then { value -> Bool in
            return value.result == .success ? true: false
        }
        return valid
    }
    
    func register(sessionType: SessionHandleType) -> Promise<Bool> {
        let req: Promise<UserSessionResponse> = RequestManager.request(.endpoint(sessionType.path, param: sessionType.param), needToken: .false)
       return  req.then { value -> Bool in
            if let sessionInfo = value.object {
               UserSessionInfo.save(userInfo: sessionInfo)
                return true
            } else {
                return false
            }
        }
    }
    
    func login(sessionType: SessionHandleType) -> Promise<Bool> {
        let req: Promise<UserSessionResponse> = RequestManager.request(.endpoint(sessionType.path, param: sessionType.param), needToken: .false)
        return  req.then { value -> Bool in
            if let sessionInfo = value.object {
                UserSessionInfo.save(userInfo: sessionInfo)
                return true
            } else {
                return false
            }
        }

    }
    
    func findPassword(param: UserRequestParam) -> Promise<Bool> {
        let req: Promise<UserSessionResponse> = RequestManager.request(.endpoint(UserPath.findPassword, param: param), needToken: .false)
        return  req.then { value -> Bool in
            if let sessionInfo = value.object {
                UserSessionInfo.save(userInfo: sessionInfo)
                return true
            } else {
                return false
            }
        }
        
    }
}
