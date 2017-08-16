//
//  RoomBottomView.swift
//  Live
//
//  Created by lieon on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class RoomBottomView: UIView {
    let chattap: UITapGestureRecognizer = UITapGestureRecognizer()
    lazy var zanBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "zan_normal"), for: .normal)
        btn.setImage(UIImage(named: "zan_hightlighted"), for: .highlighted)
        return btn
    }()
    lazy var shopingBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "shopping_tie"), for: .normal)
        btn.setImage(UIImage(named: "shopping_tie"), for: .highlighted)
               return btn
    }()
    lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play_share"), for: .normal)
        btn.setImage(UIImage(named: "play_share"), for: .highlighted)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
         addSubview(zanBtn)
         addSubview(shopingBtn)
         addSubview(shareBtn)
        let view = UIView()
//        view.backgroundColor = UIColor(hex: 0x605c56, alpha: 0.5)
//        view.layer.cornerRadius = 17
//        view.layer.masksToBounds = true
        addSubview(view)
        
        zanBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(-12)
        }
        
        shopingBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(zanBtn.snp.left).offset(-20)
        }
        
        shareBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(shopingBtn.snp.left).offset(-20)
        }
        view.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(self.snp.centerY)
            maker.height.equalTo(34)
            maker.width.equalTo(140)
        }
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.text = "想说点什么..."
        textLabel.font = UIFont(name: "Helvetica-Bold", size: CGFloat(14))
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.centerY.equalTo(view.snp.centerY)
        }
        textLabel.isUserInteractionEnabled = true
        textLabel.addGestureRecognizer(chattap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
