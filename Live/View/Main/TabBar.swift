//
//  TabBar.swift
//  Live
//
//  Created by lieon on 2017/6/22.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    lazy var centerBtn: UIButton = {
        let centerBtn = UIButton()
        centerBtn.setImage(UIImage(named: "tab_launch"), for: .normal)
        centerBtn.setImage(UIImage(named: "tab_launch"), for: .highlighted)
        centerBtn.imageView?.contentMode = .center
        centerBtn.sizeToFit()
        return centerBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(centerBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerBtn.frame.origin.x = frame.width / 3
        centerBtn.frame.origin.y = frame.height -  centerBtn.frame.height - 10
        centerBtn.frame.size.width = frame.width / 3
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isHidden {
            let pointInCenter = self.convert(point, to: centerBtn)
            if centerBtn.point(inside: pointInCenter, with: event) {
                return centerBtn
            }
            return super.hitTest(point, with: event)
        }

            return super.hitTest(point, with: event)
    }
}
