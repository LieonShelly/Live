//
//  SettingModifyAccountCell.swift
//  Live
//
//  Created by fanfans on 2017/7/5.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class SettingModifyAccountCell: UITableViewCell, ViewNameReusable {
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var avatar: UIImageView = {
        let avatar: UIImageView = UIImageView()
        avatar.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 45 * 0.5
        avatar.layer.masksToBounds = true
        return avatar
    }()
    fileprivate lazy var tipLable: UILabel = {
        let tipLable: UILabel = UILabel()
        tipLable.textAlignment = .left
        tipLable.textColor = UIColor(hex: 0x222222)
        tipLable.text = "手机号"
        tipLable.font = UIFont.systemFont(ofSize: 13)
        return tipLable
    }()
     lazy var phoneLable: UILabel = {
        let phoneLable: UILabel = UILabel()
        phoneLable.textAlignment = .left
        phoneLable.textColor = UIColor(hex: 0x999999)
        phoneLable.text = "1380000000"
        phoneLable.font = UIFont.systemFont(ofSize: 13)
        return phoneLable
    }()
    lazy var rightLable: UILabel = {
        let rightLable: UILabel = UILabel()
        rightLable.textColor = UIColor(hex: 0x999999)
        rightLable.font = UIFont.systemFont(ofSize: 13)
        rightLable.textAlignment = .right
        rightLable.text = ""
        return rightLable
    }()
    lazy var rightArrow: UIImageView = {
        let rightArrow: UIImageView = UIImageView()
        rightArrow.image = UIImage(named:"right_arrow")
        rightArrow.contentMode = .center
        rightArrow.isHidden = true
        return rightArrow
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(avatar)
        bgView.addSubview(tipLable)
        bgView.addSubview(phoneLable)
        bgView.addSubview(rightLable)
        bgView.addSubview(rightArrow)
        
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        avatar.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.centerY.equalTo(bgView.snp.centerY)
            maker.width.equalTo(45)
            maker.height.equalTo(45)
        }
        tipLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(avatar.snp.right) .offset(10)
            maker.centerY.equalTo(bgView.snp.centerY)
        }
        phoneLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipLable.snp.right) .offset(10)
            maker.centerY.equalTo(bgView.snp.centerY)
        }
        rightArrow.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.width.equalTo(50)
        }
        rightLable.snp.makeConstraints { (maker) in
            maker.right.equalTo(-40)
            maker.left.equalTo(12)
            maker.centerY.equalTo(bgView.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
