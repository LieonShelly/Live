//
//  LiveListViewModel.swift
//  Live
//
//  Created by lieon on 2017/7/12.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PromiseKit

class  LiveListViewModel {
    lazy var listGroup: ListGroup = ListGroup()
    lazy var moreListGroup: ListGroup = ListGroup()
    var currentPage: Int = 0
    var lastRequstCount: Int = 0
   
    func requstList(with param: LiveListRequstParam, isMoreRefresh: Bool = false) -> Promise<Bool> {
        let req: Promise<ListGroupResponse> =  RequestManager.request(.endpoint(LiveListPath.live, param: param))
        return  req.then { [unowned self] (response) -> Bool in
            guard let listgroup = response.object, let group = listgroup.group else { return false }
            if isMoreRefresh { /// 如果是刷新更多，则在原始数据上拼接数据
                if !group.isEmpty {
                    self.listGroup.group?.append(contentsOf: group)
                    self.moreListGroup = listgroup
                    return true
                } else {
                    self.currentPage -= 1
                    if self.currentPage <= 0 {
                        self.currentPage = 0
                    }
                    return false
                }
            } else {
                self.listGroup = listgroup
                self.moreListGroup = listgroup
            }
            return true
        }
    }
    
    func requestNearByList(with param: LiveListRequstParam, isMoreRefresh: Bool = false) -> Promise<Bool> {
        let req: Promise<ListGroupResponse> =  RequestManager.request(.endpoint(LiveListPath.nearby, param: param))
        return  req.then { [unowned self] (response) -> Bool in
         guard let listgroup = response.object, let group = listgroup.group else { return false }
            if isMoreRefresh { /// 如果是刷新更多，则在原始数据上拼接数据
                if !group.isEmpty {
                    self.listGroup.group?.append(contentsOf: group)
                    self.moreListGroup = listgroup
                    return true
                } else {
                    self.currentPage -= 1
                    if self.currentPage <= 0 {
                        self.currentPage = 0
                    }
                    return false
                }
            } else {
                self.listGroup = listgroup
                self.moreListGroup = listgroup
            }
            return true
        }
    }
    
    func requestMybroadcastList(with param: LiveListRequstParam, isClear: Bool) -> Promise<Bool> {
        let req: Promise<ListGroupResponse> =  RequestManager.request(.endpoint(LiveListPath.byUserId, param: param))
        print(param)
        return  req.then { [unowned self] (response) -> Bool in
            guard let listgroup = response.object, let group = listgroup.group else { return false }
            if isClear {
                self.listGroup.group = []
            }
            if group.isEmpty {
                self.lastRequstCount = 0
                self.listGroup = listgroup
                return false
            } else {
                self.lastRequstCount = group.count
                self.listGroup.group?.append(contentsOf: group)
                return true
            }
        }
    }
    
    func delteBrocast(with liveId: Int) -> Promise<NullDataResponse> {
        LiveListRequstParam.liveId = liveId
         let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(BroadcatPath.deleteeBroadcast, param: nil))
        return req
    }
   
}
