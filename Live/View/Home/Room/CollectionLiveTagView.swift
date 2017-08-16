//
//  CollectionLiveTagView.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class CollectionLiveTagView: UIView {
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        self.backgroundColor = UIColor.black .withAlphaComponent(0.6)
        return bgView
    }()
    fileprivate lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 11)
        statusLabel.textColor = UIColor.white
        statusLabel.textAlignment = .center
        return statusLabel
    }()
    fileprivate lazy var statusView: UIView = {
        let statusView = UIView()
        statusView.layer.cornerRadius = 5 * 0.5
        statusView.layer.masksToBounds = true
        return statusView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 16 * 0.5
        self.layer.masksToBounds = true
        
        self.addSubview(bgView)
        self.addSubview(statusView)
        self.addSubview(statusLabel)
        
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
        }
        statusView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(bgView.snp.centerY)
            maker.left.equalTo(3)
            maker.width.equalTo(5)
            maker.height.equalTo(5)
        }
        statusLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(5)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }
    
    func configWithListLiveType(type: ListLiveType) {
        if type == .living {
            statusLabel.text = "直播中"
            statusView.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        } else {
            statusLabel.text = "回放中"
            statusView.backgroundColor = UIColor(hex:0x14eff)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   
}
