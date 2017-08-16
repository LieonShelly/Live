//
//  ClearAllHistoryCell.swift
//  Live
//
//  Created by fanfans on 2017/7/18.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class ClearAllHistoryCell: UITableViewCell, ViewNameReusable {
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var tipsLable: UILabel = {
        let tipsLable: UILabel = UILabel()
        tipsLable.textAlignment = .center
        tipsLable.textColor = UIColor(hex: 0x999999)
        tipsLable.text = "清空全部记录"
        tipsLable.font = UIFont.systemFont(ofSize: 12)
        return tipsLable
    }()
    fileprivate lazy var line: UIView = {
        let line: UIView = UIView()
        line.backgroundColor = UIColor(hex: 0xe5e5e5)
        return line
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(tipsLable)
        bgView.addSubview(line)
        
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        tipsLable.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(bgView.snp.centerY)
            maker.centerX.equalTo(bgView.snp.centerX)
        }
        line.snp.makeConstraints { (maker) in
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(0)
            maker.right.equalTo(0)
            maker.left.equalTo(0)
        }
    }
    
    func config(_ model: UserModel) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
