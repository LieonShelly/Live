//
//  DanmakuItem.swift
//  Live
//
//  Created by lieon on 2017/7/21.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import FXDanmaku
import YYText

class DanmakuItem: FXDanmakuItem {
    lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20 / 2
        view.layer.masksToBounds = true
        return view
    }()
    fileprivate lazy var desclabel: YYLabel = {
        let label = YYLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    fileprivate lazy var bgView: UIView = {
        let bgView = UIView()
        // danmaku_item_bg
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        bgView.layer.cornerRadius = 20 / 2
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    override init(reuseIdentifier identifier: String?) {
        super.init(reuseIdentifier: identifier)
        addSubview(bgView)
        addSubview(avatarImageView)
        addSubview(desclabel)
       
        avatarImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(self.snp.centerY)
            maker.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        desclabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(avatarImageView.snp.right).offset(5)
            maker.centerY.equalTo(self.snp.centerY)
        }
        
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(avatarImageView.snp.left)
            maker.right.equalTo(desclabel.snp.right).offset(5)
            maker.bottom.equalTo(avatarImageView.snp.bottom)
            maker.top.equalTo(avatarImageView.snp.top)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        desclabel.text = nil
    }
    
    override func itemWillBeDisplayed(with data: FXDanmakuItemData) {
        if let data = data as? DanmakuItemData, let message = data.message, let url = URL(string: CustomKey.URLKey.baseImageUrl + (message.headPic ?? "")) {
            avatarImageView.kf.setImage(with: url)
            
            let pad = NSMutableAttributedString(string: " ")
            pad.yy_font = UIFont.systemFont(ofSize: 16)
            let text = NSMutableAttributedString()
            let levelStr = NSMutableAttributedString(string: "V" + "\( message.level)")
            levelStr.yy_font = UIFont.systemFont(ofSize: 16)
            levelStr.yy_color = UIColor.white
            let backgroudBoder = YYTextBorder()
            backgroudBoder.fillColor = UIColor(hex: CustomKey.Color.mainColor)
            backgroudBoder.cornerRadius = 15
            backgroudBoder.lineJoin = .bevel
            levelStr.yy_setTextBackgroundBorder(backgroudBoder, range: NSRange(location: 0, length: ("V" + "\( message.level)").characters.count))
            text.append(levelStr)
            text.append(pad)
            if let nickiname = message.nickName, let msg = message.msg {
                let textnickName = NSMutableAttributedString(string: nickiname + ": ")
                textnickName.yy_font = UIFont.systemFont(ofSize: 16)
                textnickName.yy_color = UIColor.white
                text.append(textnickName)
                
                let textnicMsg = NSMutableAttributedString(string: msg)
                textnicMsg.yy_font = UIFont.systemFont(ofSize: 16)
                textnicMsg.yy_color = UIColor(red: 0.0, green: 239.0 / 255.0, blue: 232.0 / 255.0, alpha: 1)
                text.append(textnicMsg)
            }
            text.append(pad)
            text.yy_alignment = .left
            text.yy_lineSpacing = 3
            text.yy_lineBreakMode = .byWordWrapping
            text.yy_paragraphSpacingBefore = 3
            desclabel.attributedText = text
        }

    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DanmakuItemData: FXDanmakuItemData {
    var message: IMMessage?
    
    override init?(itemReuseIdentifier identifier: String, priority: FXDataPriority) {
        super.init(itemReuseIdentifier: identifier, priority: priority)
    }
}
