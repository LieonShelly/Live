//
//  BeanProductCell.swift
//  Live
//
//  Created by fanfans on 2017/7/19.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class BeanProductCell: UITableViewCell, ViewNameReusable {
    
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var allBeanLabel: UILabel = {
        let allBeanLabel = UILabel()
        allBeanLabel.text = "220哆豆"
        allBeanLabel.font = UIFont.systemFont(ofSize: 14)
        allBeanLabel.textAlignment = .left
        allBeanLabel.textColor = UIColor(hex: 0x222222)
        return allBeanLabel
    }()
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton()
        rightBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.setTitle("6元", for: .normal)
        rightBtn.layer.cornerRadius = 25 * 0.5
        rightBtn.layer.masksToBounds = true
        return rightBtn
    }()
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(allBeanLabel)
        bgView.addSubview(rightBtn)
        bgView.addSubview(line0)
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        allBeanLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        rightBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.width.equalTo(74)
            maker.height.equalTo(25)
        }
        line0.snp.makeConstraints { (maker) in
            maker.height.equalTo(0.5)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
