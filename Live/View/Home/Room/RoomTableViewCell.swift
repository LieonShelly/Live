//
//  RoomTableViewCell.swift
//  Live
//
//  Created by lieon on 2017/7/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
       var roomID: String?
       override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    func configRoomID(_ roomID: String) {
         print("configRoomID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoomTableViewCell { }
