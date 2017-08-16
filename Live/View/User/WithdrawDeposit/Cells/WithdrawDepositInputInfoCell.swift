//
//  WithdrawDepositInputInfoCell.swift
//  Live
//
//  Created by fanfans on 2017/7/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class WithdrawDepositInputInfoCell: UITableViewCell, ViewNameReusable {
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var tipsLable: UILabel = {
        let tipsLable = UILabel()
        tipsLable.font = UIFont.systemFont(ofSize: 14)
        tipsLable.textAlignment = .left
        tipsLable.textColor = UIColor(hex: 0x222222)
        return tipsLable
    }()
    lazy var inputTF: UITextField = {
        let inputTF = UITextField()
        inputTF.font = UIFont.systemFont(ofSize: 14)
        inputTF.textAlignment = .left
        inputTF.textColor = UIColor(hex: 0x222222)
        return inputTF
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
        bgView.addSubview(tipsLable)
        bgView.addSubview(inputTF)
        bgView.addSubview(line0)
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
        tipsLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        inputTF.snp.makeConstraints { (maker) in
            maker.right.equalTo(30)
            maker.left.equalTo(110)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
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
