//
//  UserLoginViewModel.swift
//  Live
//
//  Created by lieon on 2017/6/22.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper
import CoreData

class  UserLoginViewModel {
 
    func loadData() -> Promise<Void> {
        let param = UserRequestParam()
        param.username = "15608066219"
        param.password = "123456".md5()
        let req: Promise<UserLoginResponse> = RequestManager.request(Router.endpoint(UserPath.login, param: param), needToken: .false)
        return  req.then { value -> Void in
                print(value.toJSON())
        }
    }
    
}
