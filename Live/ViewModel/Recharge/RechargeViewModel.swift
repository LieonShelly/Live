//
//  RechargeViewModel.swift
//  Live
//
//  Created by fanfans on 2017/7/19.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper

class RechargeViewModel {
    func requstRecharge(with param: RechargeRequestParam) -> Promise<NullDataResponse> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(MoneyPath.rechargeBeans, param: param))
        return req
    }
}
