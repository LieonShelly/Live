//
//  AllBeanCell.swift
//  Live
//
//  Created by fanfans on 2017/7/19.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import YYText

class AllBeanCell: UITableViewCell, ViewNameReusable {
    
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var allBeanLabel: YYLabel = {
        let allBeanLabel = YYLabel()
        allBeanLabel.font = UIFont.systemFont(ofSize: 16)
        allBeanLabel.textAlignment = .left
        allBeanLabel.textColor = UIColor(hex: 0x222222)
        return allBeanLabel
    }()
    fileprivate lazy var rightBtn: UIButton = {
        let rightBtn = UIButton()
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        rightBtn.setTitle("哆豆乐园", for: .normal)
        rightBtn.layer.borderWidth = 2
        rightBtn.layer.cornerRadius = 25 * 0.5
        rightBtn.layer.masksToBounds = true
        rightBtn.layer.borderColor = UIColor(hex: CustomKey.Color.mainColor).cgColor
        return rightBtn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        contentView.addSubview(bgView)
        bgView.addSubview(allBeanLabel)
        bgView.addSubview(rightBtn)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
