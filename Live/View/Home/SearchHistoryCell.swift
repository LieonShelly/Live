//
//  SearchHistoryCell.swift
//  Live
//
//  Created by fanfans on 2017/7/18.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class SearchHistoryCell: UITableViewCell, ViewNameReusable {
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var nameLable: UILabel = {
        let nameLable: UILabel = UILabel()
        nameLable.textAlignment = .left
        nameLable.textColor = UIColor(hex: 0x222222)
        nameLable.font = UIFont.systemFont(ofSize: 14)
        return nameLable
    }()
    fileprivate lazy var line: UIView = {
        let line: UIView = UIView()
        line.backgroundColor = UIColor(hex: 0xe5e5e5)
        return line
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(nameLable)
        bgView.addSubview(line)
        
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        nameLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgView.snp.left).offset(12)
            maker.centerY.equalTo(bgView.snp.centerY)
        }
        line.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLable.snp.left)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(0)
            maker.right.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
