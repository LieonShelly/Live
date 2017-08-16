//
//  SettingViewModel.swift
//  Live
//
//  Created by fanfans on 2017/7/10.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import PromiseKit

class SettingViewModel {
    func  logout() -> Promise<Bool> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(UserPath.logout, param: nil), needToken: .true)
        let valid = req.then { value -> Bool in
            CoreDataManager.sharedInstance.clearUserInfo()
            UserSessionInfo.clearInfo()
            return value.result == .success ? true: false
        }
        return valid
    }
}
