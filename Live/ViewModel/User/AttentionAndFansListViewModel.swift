//
//  AttentionAndFansListViewModel.swift
//  Live
//
//  Created by fanfans on 2017/7/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PromiseKit

class  AttentionAndFansListViewModel {
    lazy var listGroup: UserListGroup = UserListGroup()
    
    func requstList(with param: UserListRequstParam) -> Promise<Bool> {
        let req: Promise<UserGroupResponse> =  RequestManager.request(.endpoint(CollectionPath.followList, param: param))
        return  req.then { [unowned self] (response) -> Bool in
            if let listgroup = response.object {
                self.listGroup = listgroup
                return true
            } else {
                return false
            }
        }
    }
}
