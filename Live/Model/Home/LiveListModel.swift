//
//  LiveListModel.swift
//  Live
//
//  Created by lieon on 2017/7/6.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources
import Kingfisher

class ListGroup: Model {
    var group: [LiveListModel]?
    
    override func mapping(map: Map) {
        group <- map["list"]
    }
}

class LiveListModel: Model {
    var liveId: Int?
    var name: String?
    var cover: String? {
        didSet {
            guard let imageURL = URL(string: CustomKey.URLKey.baseImageUrl + (cover ?? "")) else { return }
            ImageDownloader.default.downloadImage(with: imageURL, retrieveImageTask: nil, options: nil, progressBlock: nil) { (image, _, _, _) in
                self.coverImage = image
            }
        }
    }
    var city: String?
    var level: Int = 0
    var userName: String?
    var avatar: String?
    var userId: Int = 0
    var seeCount: Int = 0
    var type: ListLiveType = .none
    var playUrlRtmp: String?
    var playUrlFlv: String?
    var playUrlHls: String?
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var distance: UInt = 0
    var replayUrlMp4: String?
    var replayUrlFlv: String?
    var replayUrlHls: String?
    var startTime: Int = 0
    var endTime: Int = 0
    var groupId: String?
    var isFollow: Bool = false
    var seeingCount: Int = 0
    var coverImage: UIImage?
    
    override func mapping(map: Map) {
        liveId <- map["id"]
        name <- map["name"]
        cover <- map["cover"]
        city <- map["city"]
        level <- map["level"]
        userName <- map["userName"]
        avatar <- map["avastar"]
        userId <- map["userId"]
         seeCount <- map["seeCount"]
        type <- map["type"]
        playUrlRtmp <- map["playUrlRtmp"]
        playUrlFlv <- map["playUrlFlv"]
        playUrlHls <- map["playUrlHls"]
        longitude <- map["lng"]
        latitude <- map["lat"]
        distance <- map["distance"]
        replayUrlMp4 <- map["replayUrlMp4"]
        replayUrlFlv <- map["replayUrlFlv"]
        replayUrlHls <- map["replayUrlHls"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        groupId <- map["groupId"]
        isFollow <- map["isFollow"]
        seeingCount <- map["seeingCount"]
    }
}
