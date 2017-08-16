//
//  SubLabelArrowCell.swift
//  Live
//
//  Created by lieon on 2017/6/30.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class SubLabelArrowCell: UITableViewCell {
    
    fileprivate lazy var arrowView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "user_center_more")
        iconView.sizeToFit()
        return iconView
    }()
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor(hex: 0x222222)
        return nameLabel
    }()
    fileprivate lazy var subTitleLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .right
        nameLabel.textColor = UIColor(hex: 0x222222)
        return nameLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(arrowView)
        contentView.addSubview(line0)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subTitleLabel)
        arrowView.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(arrowView.snp.left).offset(5)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
