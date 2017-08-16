//
//  CloseBroadcastView.swift
//  Live
//
//  Created by lieon on 2017/7/10.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class CloseBroadcastView: UIView {
    let coverTap = UITapGestureRecognizer()
    lazy var continueBtn: UIButton = {
        let startBtn = UIButton()
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .normal)
        startBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        startBtn.setTitle("继续直播", for: .normal)
        startBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        startBtn.layer.cornerRadius = 20
        startBtn.layer.masksToBounds = true
        return startBtn
    }()
    
     lazy var closeBtn: UIButton = {
        let startBtn = UIButton()
        startBtn.backgroundColor = .clear
        startBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        startBtn.setTitle("关闭直播", for: .normal)
        startBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        startBtn.layer.borderColor = UIColor(hex: CustomKey.Color.mainColor).cgColor
        startBtn.layer.borderWidth = 1
        startBtn.layer.cornerRadius = 20
        startBtn.layer.masksToBounds = true
        return startBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let cover = UIView()
        cover.isUserInteractionEnabled = true
        cover.addGestureRecognizer(coverTap)
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(cover)
        cover.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.bottom.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
        }
        
        let label = UILabel()
        label.text = "观众正在赶来的路上哦"
        label.font = UIFont.sizeToFit(with: 14)
        label.textColor = .white
        addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.top.equalTo(270.0)
        }
        
        addSubview(continueBtn)
        continueBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.top.equalTo(label.snp.bottom).offset(32.5.fitHeight)
            maker.size.equalTo(CGSize(width: 195, height: 40))
        }
        
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.top.equalTo(continueBtn.snp.bottom).offset(12)
            maker.size.equalTo(CGSize(width: 195, height: 40))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
