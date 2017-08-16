//
//  WithdrawDepositHistoryCell.swift
//  Live
//
//  Created by fanfans on 2017/7/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class WithdrawDepositHistoryCell: UITableViewCell, ViewNameReusable {
    
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var tipsLable: UILabel = {
        let tipsLable = UILabel()
        tipsLable.text = "提现"
        tipsLable.font = UIFont.systemFont(ofSize: 14)
        tipsLable.textAlignment = .left
        tipsLable.textColor = UIColor(hex: 0x222222)
        return tipsLable
    }()
    fileprivate lazy var timeLable: UILabel = {
        let timeLable = UILabel()
        timeLable.text = "2017-07-20 11:02:03"
        timeLable.font = UIFont.systemFont(ofSize: 12)
        timeLable.textAlignment = .left
        timeLable.textColor = UIColor(hex: 0x999999)
        return timeLable
    }()
    fileprivate lazy var amountLable: UILabel = {
        let amountLable = UILabel()
        amountLable.text = "-198"
        amountLable.font = UIFont(name: "Helvetica-Bold", size: 16)
        amountLable.textAlignment = .right
        amountLable.textColor = UIColor(hex: CustomKey.Color.mainColor)
        return amountLable
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
        bgView.addSubview(timeLable)
        bgView.addSubview(amountLable)
        bgView.addSubview(line0)
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        tipsLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(10)
        }
        timeLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(tipsLable.snp.bottom).offset(5)
        }
        amountLable.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        line0.snp.makeConstraints { (maker) in
            maker.height.equalTo(0.5)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }
    
    func config(_ model: MoneyRecord?) {
        guard let model = model else {
            return
        }
        tipsLable.text = model.type.title
        timeLable.text = model.createTimeDis ?? ""
        amountLable.text = model.type.markStr + " \(model.count)"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
