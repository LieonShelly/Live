//
//  FeedBackViewModel.swift
//  Live
//
//  Created by lieon on 2017/7/7.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit

class FeedBackViewModel: Model {
    func uploadCoverImage(with imageDatas: [Data]) -> Promise<[String]> {
        return Promise { fullfil, reject in
            UploadUtils.upLoadMultimedia(withDataArr: imageDatas, success: { (imageURLs) in
                if let strs = imageURLs as? [String] {
                    fullfil(strs)
                } else {
                    var appError = AppError()
                    appError.message = "upload error"
                    reject(appError)
                }
            }, fail: { errStr in
                var appError = AppError()
                appError.message = errStr ?? ""
                reject(appError)
            }, progress: {_ in })
        }
        
    }
    
    func requestFeedback(with param: FeedbackRequstParam) -> Promise<NullDataResponse> {
        let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(UserPath.feedback, param: param), needToken: .true)
        return req
    }
}
