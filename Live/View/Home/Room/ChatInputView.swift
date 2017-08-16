//
//  ChatInputView.swift
//  Live
//
//  Created by lieon on 2017/7/17.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class ChatInputView: UIView {
    var returnKeyPressAction: ((Void) -> Void)?
    var isDanakuMessage: Bool = false
    lazy var barrageBtn: XYSwitch = XYSwitch()
    lazy var sendBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("发送", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        return btn
    }()
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy   var line1: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    lazy  var messageTf: UITextView = {
        let pwdTF = UITextView()
        pwdTF.placeholder = "说点什么..."
        pwdTF.textColor = UIColor(hex: 0x333333)
        pwdTF.font = UIFont.sizeToFit(with: 13)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .send
        return pwdTF
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageTf)
        addSubview(sendBtn)
        addSubview(line0)
        addSubview(barrageBtn)
        addSubview(line1)
        messageTf.delegate = self
        
        sendBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(-12)
            maker.width.equalTo(35)
        }
        
        line0.snp.makeConstraints { (maker) in
            maker.right.equalTo(sendBtn.snp.left).offset(-5)
            maker.top.equalTo(sendBtn.snp.top).offset(-5)
            maker.height.equalTo(30)
            maker.width.equalTo(0.5)
        }
        
        messageTf.snp.makeConstraints { (maker) in
            maker.left.equalTo(60)
            maker.centerY.equalTo(self.snp.centerY)
            maker.right.equalTo(line0.snp.left).offset(5)
            maker.bottom.equalTo(-12)
            maker.top.equalTo(12)
        }
        line1.snp.makeConstraints { (maker) in
            maker.top.equalTo(line0)
            maker.right.equalTo(messageTf.snp.left).offset(-5)
            maker.width.equalTo(0.5)
            maker.height.equalTo(30)
        }
        barrageBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(line1.snp.left).offset(-2)
            maker.top.equalTo(line1.snp.top).offset(-5)
            maker.width.equalTo(50)
            maker.height.equalTo(28)
        }
        
        barrageBtn.changeStateBlock = {[unowned self] isOn in
            self.isDanakuMessage = isOn
            if isOn {
                 self.messageTf.placeholder = "弹幕每条10颗哆豆"
            } else {
                 self.messageTf.placeholder = "说点什么..."
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatInputView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            returnKeyPressAction?()
            return false
        }
        return true
    }
}
