//
//  RoomTableViewCell.swift
//  Live
//
//  Created by lieon on 2017/7/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
       lazy var roomVC: RoomViewController = RoomViewController()
       override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        roomVC.view.removeFromSuperview()
        roomVC.view.backgroundColor = .white
        roomVC.view.frame = contentView.bounds
        contentView.addSubview(roomVC.view)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoomTableViewCell {
   }
