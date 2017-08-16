//
//  UserInfoManagerAvatarCell.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class UserInfoManagerAvatarCell: UITableViewCell, ViewNameReusable {
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var avatar: UIImageView = {
        let avatar: UIImageView = UIImageView(image: UIImage(named: "placeholderImage_avatar"))
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 60 * 0.5
        avatar.layer.masksToBounds = true
        return avatar
    }()
    fileprivate lazy var tipLable: UILabel = {
        let tipLable: UILabel = UILabel()
        tipLable.textAlignment = .left
        tipLable.textColor = UIColor(hex: 0x222222)
        tipLable.text = "头像"
        tipLable.font = UIFont.systemFont(ofSize: 14)
        return tipLable
    }()
    fileprivate lazy var line: UIView = {
        let line: UIView = UIView()
        line.backgroundColor = UIColor(hex: 0xe5e5e5)
        return line
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(avatar)
        bgView.addSubview(tipLable)
        bgView.addSubview(line)
        
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        avatar.snp.makeConstraints { (maker) in
            maker.right.equalTo(-20)
            maker.centerY.equalTo(bgView.snp.centerY)
            maker.width.equalTo(60)
            maker.height.equalTo(60)
        }
        tipLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(bgView.snp.centerY)
        }
        line.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(0)
            maker.right.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
