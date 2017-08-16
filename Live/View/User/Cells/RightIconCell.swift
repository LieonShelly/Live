//
//  RightIconCell.swift
//  Live
//
//  Created by lieon on 2017/6/30.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class RightIconCell: UITableViewCell {
    fileprivate lazy var fansLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "粉丝 6"
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = UIColor(hex: 0x222222)
        nameLabel.isUserInteractionEnabled = true
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    fileprivate lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "placeholderImage_avatar")
        iconView.layer.cornerRadius = 120.fitWidth * 0.5
        iconView.layer.borderWidth = 2
        iconView.layer.masksToBounds = true
        iconView.layer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
        iconView.isUserInteractionEnabled = true
        iconView.backgroundColor = .red
        return iconView
    }()
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
         contentView.addSubview(iconView)
         contentView.addSubview(fansLabel)
         contentView.addSubview(line0)
        
        fansLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        
        iconView.snp.makeConstraints { (maker) in
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
