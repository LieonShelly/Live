//
//  RightSubTileCell.swift
//  Live
//
//  Created by lieon on 2017/6/30.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class RightSubTileCell: UITableViewCell, ViewNameReusable {

    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var subTitleLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "212323423多逗"
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textAlignment = .right
        nameLabel.textColor = UIColor.gray
        return nameLabel
        
    }()
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "登录/注册"
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor(hex: 0x222222)
        return nameLabel
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(subTitleLabel)
        bgView.addSubview(line0)
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(12)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(0)
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        
        subTitleLabel.snp.makeConstraints { (maker) in
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
    
    func config(title: String, subtitle: String) {
            nameLabel.text = title
            subTitleLabel.text = subtitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
