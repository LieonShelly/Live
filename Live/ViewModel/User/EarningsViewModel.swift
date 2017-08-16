//
//  EarningsViewModel.swift
//  Live
//
//  Created by lieon on 2017/7/27.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import PromiseKit

class EarningsViewModel {
    var moneyReocod: [MoneyRecord]?
    var currentPage: Int = 0
     var lastRequstCount: Int = 0
    var pickUpInitial: PickupIntialModel?
    
    /// 哆豆提现
    func requestApplyPickUp(with param: ApplyPickUpParam) -> Promise<NullDataResponse> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(MoneyPath.applyPickUp, param: param))
        return req
    }
    
    /// 哆豆提现初始化信息
    func requestPicupInitialInfo() -> Promise<PickupInitialResponse> {
        let req: Promise<PickupInitialResponse> = RequestManager.request(Router.endpoint(MoneyPath.getPickupInfo, param: nil)
        )
        return req
    }
    
    /// 提现充值记录
    func requestMoneyRecord(with param: MoneyInoutRecordParam) -> Promise<MoneyRecordGroupResponse> {
        let req: Promise<MoneyRecordGroupResponse> = RequestManager.request(Router.endpoint(MoneyPath.getMoneyLogList, param: param)
        )
        return req
    }
}
