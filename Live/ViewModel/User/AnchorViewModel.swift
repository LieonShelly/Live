//
//  AnchorViewModel.swift
//  Live
//
//  Created by lieon on 2017/7/11.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable variable_name

import Foundation
import PromiseKit

class AnchorViewModel {
    lazy var anchorInfo: AnchorDetail = AnchorDetail()
    
    /// 主播信息
    func requestAnchorDetail(with id: Int) -> Promise<Bool> {
        AnchorRequestParm.anchorId = id
        let req: Promise<AnchorDetailResponse> = RequestManager.request(.endpoint(AnchorPath.getInfo, param: nil), needToken: .true)
        return  req.then { [unowned self] (response) -> Bool in
            if let object = response.object, let userInfo = object.result {
                self.anchorInfo = userInfo
                return true
            }
            return false
        }
    }
}
