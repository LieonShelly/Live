//
//  ShareView.swift
//  Live
//
//  Created by lieon on 2017/7/10.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShareView: UIView {
    private let disposeBag: DisposeBag = DisposeBag()
    lazy var weiBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share_sina"), for: .normal)
        return btn
    }()
    
    lazy var qqZoneBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share_qqzone"), for: .normal)
        return btn
    }()
    
    lazy var weiChatBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share_wechat"), for: .normal)
        return btn
    }()
    
    lazy var qqBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share_qq"), for: .normal)
        return btn
    }()
    
    lazy var friendCircleBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "share_pengyouquan"), for: .normal)
        return btn
    }()
    
    fileprivate lazy var weiboLabel: UILabel = {
        let label = UILabel()
        label.text = "微博"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    fileprivate lazy var qqZoneLabel: UILabel = {
        let label = UILabel()
         label.text = "QQ空间"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    fileprivate lazy var weiChatLabel: UILabel = {
        let label = UILabel()
         label.text = "微信"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    fileprivate lazy var qqLabel: UILabel = {
        let label = UILabel()
         label.text = "QQ"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    fileprivate lazy var friendCircleLabel: UILabel = {
        let label = UILabel()
         label.text = "朋友圈"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    lazy  var cancleBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("取消", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        return loginBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(weiBtn)
        addSubview(qqZoneBtn)
        addSubview(weiChatBtn)
        addSubview(qqBtn)
        addSubview(friendCircleBtn)
        addSubview(weiboLabel)
        addSubview(qqZoneLabel)
        addSubview(weiChatLabel)
        addSubview(qqLabel)
        addSubview(friendCircleLabel)
        addSubview(cancleBtn)
        
        let btnWidth: CGFloat = 37.5
        let insetX: CGFloat = (UIScreen.width - 12 * 2 - btnWidth * 5) / 4.0
        
        weiBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.width.equalTo(btnWidth)
            maker.height.equalTo(btnWidth)
            maker.top.equalTo(12)
        }
        weiboLabel.snp.makeConstraints { (maker) in
           maker.centerX.equalTo(weiBtn.snp.centerX)
            maker.top.equalTo(weiBtn.snp.bottom).offset(12)
        }
        
        qqZoneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(weiBtn.snp.right).offset(insetX)
            maker.width.equalTo(btnWidth)
            maker.height.equalTo(btnWidth)
            maker.top.equalTo(12)
        }
        qqZoneLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(qqZoneBtn.snp.centerX)
            maker.top.equalTo(weiboLabel.snp.top)
        }
        
        weiChatBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(qqZoneBtn.snp.right).offset(insetX)
            maker.width.equalTo(btnWidth)
            maker.height.equalTo(btnWidth)
            maker.top.equalTo(12)
        }
        weiChatLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(weiChatBtn.snp.centerX)
            maker.top.equalTo(weiboLabel.snp.top)
        }
        
        qqBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(weiChatBtn.snp.right).offset(insetX)
            maker.width.equalTo(btnWidth)
            maker.height.equalTo(btnWidth)
            maker.top.equalTo(12)
        }
        qqLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(qqBtn.snp.centerX)
            maker.top.equalTo(weiboLabel.snp.top)
        }
        
        friendCircleBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(qqBtn.snp.right).offset(insetX)
            maker.width.equalTo(btnWidth)
            maker.height.equalTo(btnWidth)
            maker.top.equalTo(12)
        }
        friendCircleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(friendCircleBtn.snp.centerX)
            maker.top.equalTo(weiboLabel.snp.top)
        }
        
        cancleBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(37)
            maker.right.equalTo(-37)
            maker.height.equalTo(40)
            maker.top.equalTo(weiChatLabel.snp.bottom).offset(37)
        }
        
        cancleBtn.rx.tap
            .subscribe(onNext: { (value) in
                UIView.animate(withDuration: 0.25, animations: { 
                    self.transform = .identity
                })
            })
            .disposed(by: self.disposeBag)
    }
    
    func configApperance(textClor: UIColor) {
        weiboLabel.textColor = textClor
        qqZoneLabel.textColor = textClor
        weiChatLabel.textColor = textClor
        qqLabel.textColor = textClor
        friendCircleLabel.textColor = textClor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
