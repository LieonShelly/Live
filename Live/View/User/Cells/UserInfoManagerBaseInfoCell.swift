//
//  UserInfoManagerBaseInfoCell.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class UserInfoManagerBaseInfoCell: UITableViewCell, ViewNameReusable {
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var tipLable: UILabel = {
        let tipLable: UILabel = UILabel()
        tipLable.textAlignment = .left
        tipLable.textColor = UIColor(hex: 0x222222)
        tipLable.font = UIFont.systemFont(ofSize: 14)
        return tipLable
    }()
    lazy var inputTextFiled: UITextField = {
        let inputTextFiled: UITextField = UITextField()
        inputTextFiled.textColor = UIColor(hex: 0x222222)
        inputTextFiled.font = UIFont.systemFont(ofSize: 14)
        inputTextFiled.textAlignment = .right
        return inputTextFiled
    }()
    lazy var rightArrow: UIImageView = {
        let rightArrow: UIImageView = UIImageView()
        rightArrow.image = UIImage(named:"right_arrow")
        rightArrow.contentMode = .center
        return rightArrow
    }()
     lazy var line: UIView = {
        let line: UIView = UIView()
        line.backgroundColor = UIColor(hex: 0xe5e5e5)
        return line
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(tipLable)
        bgView.addSubview(inputTextFiled)
        bgView.addSubview(rightArrow)
        bgView.addSubview(line)
        
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        tipLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(bgView.snp.centerY)
        }
        rightArrow.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.width.equalTo(50)
        }
        inputTextFiled.snp.makeConstraints { (maker) in
            maker.right.equalTo(-50)
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
