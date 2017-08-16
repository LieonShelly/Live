//
//  BaseResponseObject.swift
//  Live
//
//  Created by lieon on 2017/6/21.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponseObject<T: Mappable>: Mappable {
    var result: ResponseType = .fail
    var errorCode: ErrorCodeType = .none
    var errorMsg: String?
    var object: T?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        result <- (map["result"])
        errorCode <- map["errorCode"]
        errorMsg <- map["errorMsg"]
        object <- map["object"]
    }
}

class NullDataResponse: BaseResponseObject<Model> {}

class UserSessionResponse: BaseResponseObject<UserSessionInfo> {}

class RegisterInfoResponse: BaseResponseObject<RegisterInfo> {}

class ValidationResponse: BaseResponseObject<Validation> { }

class BroadcastResponse: BaseResponseObject<LiveReponse> { }

class ListGroupResponse: BaseResponseObject<ListGroup> { }

class UserInfoResponse: BaseResponseObject<UserGroup> { }

class ZhimaCertifyResponse: BaseResponseObject<ZhimaCertifyResult> { }

class LiveRoomResponse: BaseResponseObject<RoomReslut> { }

class UserGroupResponse: BaseResponseObject<UserListGroup> { }

class AnchorDetailResponse: BaseResponseObject<AnchorDetailResult> { }

class EndLiveGroupResponse: BaseResponseObject<EndLiveReponse> { }

class GiftGroupResponse: BaseResponseObject<GiftGroup> { }

class LiveRealTimeResponse: BaseResponseObject<LiveRealTime> { }

class PickupInitialResponse: BaseResponseObject<PickupIntialModel> { }

class MoneyRecordGroupResponse: BaseResponseObject<MoneyRecordGroup> { }
