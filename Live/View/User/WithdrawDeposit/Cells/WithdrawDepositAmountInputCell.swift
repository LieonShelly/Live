//
//  WithdrawDepositAmountInputCell.swift
//  Live
//
//  Created by fanfans on 2017/7/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class WithdrawDepositAmountInputCell: UITableViewCell, ViewNameReusable {
    
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var userNameLable: UILabel = {
        let userNameLable = UILabel()
        userNameLable.text = CoreDataManager.sharedInstance.getUserInfo()?.nickName ?? ""
        userNameLable.font = UIFont.systemFont(ofSize: 16)
        userNameLable.textAlignment = .left
        userNameLable.textColor = UIColor(hex: 0x222222)
        return userNameLable
    }()
     lazy var amountTF: UITextField = {
        let amountTF = UITextField()
        amountTF.placeholder = "最少100"
        amountTF.font = UIFont.systemFont(ofSize: 14)
        amountTF.textAlignment = .right
        amountTF.textColor = UIColor(hex: 0x222222)
        amountTF.keyboardType = .namePhonePad
        return amountTF
    }()
    fileprivate lazy var rightLable: UILabel = {
        let rightLable = UILabel()
        rightLable.text = "元"
        rightLable.font = UIFont.systemFont(ofSize: 14)
        rightLable.textAlignment = .right
        rightLable.textColor = UIColor(hex: 0x222222)
        return rightLable
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(userNameLable)
        bgView.addSubview(amountTF)
        bgView.addSubview(rightLable)
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
        userNameLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        amountTF.snp.makeConstraints { (maker) in
            maker.right.equalTo(-30)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.width.equalTo(100)
        }
        rightLable.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
