//
//  SearchViewModel.swift
//  Live
//
//  Created by lieon on 2017/7/13.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PromiseKit

class  SearchViewModel {
    var history: [String] = []
    var recommendUses: [UserModel]?
    var searchedUses: [UserModel]?
    var searchedUsersCount: Int = 0
    
    func requestRecommendList() -> Promise<[UserModel]> {
        let req: Promise<UserGroupResponse> = RequestManager.request(.endpoint(CollectionPath.recommendList, param: nil))
       return req.then { (response) -> [UserModel] in
            if let object = response.object, let group = object.listGroup {
                return group
            }
            return [UserModel]()
        }
    }
    
    func  requestSearchuUser(param: LiveListRequstParam) -> Promise<[UserModel]> {
        let req: Promise<UserGroupResponse> = RequestManager.request(.endpoint(CollectionPath.userSearch, param: param))
        return req.then { (response) -> [UserModel] in
            if let object = response.object, let group = object.listGroup {
                self.searchedUsersCount = group.count
                return group
            }
            return [UserModel]()
        }
    }
    
    func saveSearchHistory(_ name: String) {
        CoreDataManager.sharedInstance.saveSearchHistory(name: name)
    }
    
    func getSearchHistory() -> Promise< [String]> {
       return Promise { fullfil, reject in
        guard let info = CoreDataManager.sharedInstance.getSearchHistory(), let trueinfo = info as? [String]  else {
                var error = AppError()
                error.message = "getSearchHistory Error"
                    reject(error)
                return
            }
            fullfil(trueinfo)
        }
    }
    
    func clearHistory() {
        history.removeAll()
        CoreDataManager.sharedInstance.clearAllHistory()
    }
}
