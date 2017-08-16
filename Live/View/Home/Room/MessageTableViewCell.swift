//
//  MessageTableViewCell.swift
//  Live
//
//  Created by lieon on 2017/7/19.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import YYText

class MessageTableViewCell: UITableViewCell, ViewNameReusable {
    var cellHeight: CGFloat = 0
    fileprivate lazy var messageLabel: YYLabel = {
        let label = YYLabel()
        label.font = UIFont.systemFont(ofSize: 12.5)
        label.textColor = UIColor(hex: 0xe6e6e6)
        label.backgroundColor = .clear
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(messageLabel)
        messageLabel.backgroundColor = .clear
        messageLabel.numberOfLines = 0
        messageLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(5)
            maker.bottom.equalTo(-5)
            maker.right.lessThanOrEqualTo(-100)
        }
        let coverLabel = UILabel()
        coverLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        coverLabel.layer.cornerRadius = (bounds.height - 24) * 0.5
        coverLabel.layer.masksToBounds = true
        contentView.insertSubview(coverLabel, belowSubview: messageLabel)
        coverLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.top.equalTo(5)
            maker.bottom.equalTo(-5)
            maker.right.equalTo(messageLabel.snp.right)
        }
    }
    
    func configAttributeMessage( _ text: NSAttributedString) {
        messageLabel.attributedText = text
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
