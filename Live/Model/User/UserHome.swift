//
//  UserHome.swift
//  Live
//
//  Created by lieon on 2017/7/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import UIKit

class UserHome: NSObject {
    var title: String?
    var handle: ((Void) -> Void)?
    
    convenience init(title: String, handle:  @escaping ((Void) -> Void)) {
        self.init()
        self.title = title
        self.handle = handle
    }
}
