//
//  AppError.swift
//  Live
//
//  Created by lieon on 2017/6/21.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation

protocol ErrorCode {
    func errorCode() -> Int
}

public struct AppError: Error {
     var message: String = ""
    var erroCode: ErrorCodeType = .none
}
