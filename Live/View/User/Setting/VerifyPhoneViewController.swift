//
//  VerifyPhoneViewController.swift
//  Live
//
//  Created by fanfans on 2017/7/13.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift

class VerifyPhoneViewController: BaseViewController {
     var phoneNum: String?
    fileprivate lazy var tipsLable: UILabel = {
        let tipsLable = UILabel()
        tipsLable.text = "已绑定的手机号18380225528"
        tipsLable.font = UIFont.systemFont(ofSize: 13)
        tipsLable.textAlignment = .left
        tipsLable.textColor = UIColor(hex: 0x999999)
        return tipsLable
    }()
    fileprivate lazy  var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.placeholder = "请输入短信验证码"
        pwdTF.textColor = UIColor(hex:0x333333)
        pwdTF.font = UIFont.sizeToFit(with: 13)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    fileprivate lazy  var pwdLog: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_captch"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy  var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy var getVerifiedCodeBtn: UIButton = {
        let getVerifiedCodeBtn = UIButton()
        getVerifiedCodeBtn.sizeToFit()
        getVerifiedCodeBtn.titleLabel?.font = UIFont.sizeToFit(with: 12)
        getVerifiedCodeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        getVerifiedCodeBtn.setTitleColor(UIColor.gray, for: .disabled)
        getVerifiedCodeBtn.setTitleColor(UIColor.gray, for: .normal)
        return getVerifiedCodeBtn
    }()
    fileprivate lazy  var nextBtn: UIButton = {
        let nextBtn = UIButton()
        nextBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        nextBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        nextBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        nextBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        nextBtn.layer.cornerRadius = 22.5
        nextBtn.layer.masksToBounds = true
        nextBtn.setTitle("下 一 步", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.isEnabled = false
        return nextBtn
    }()
    fileprivate lazy var cannotGetVerifiedCodeLable: UILabel = {
        let cannotGetVerifiedCodeLable = UILabel()
        cannotGetVerifiedCodeLable.text = "原手机无法获取验证码"
        cannotGetVerifiedCodeLable.font = UIFont.systemFont(ofSize: 13)
        cannotGetVerifiedCodeLable.textAlignment = .left
        cannotGetVerifiedCodeLable.textColor = UIColor(hex: 0x999999)
        return cannotGetVerifiedCodeLable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "已绑定手机号"
        self.view.backgroundColor = UIColor.white
        tipsLable.text = "已绑定的手机号" + (phoneNum ?? "")
        
        // MARK: congfigUI
        self.view.addSubview(tipsLable)
        self.view.addSubview(pwdTF)
        self.view.addSubview(pwdLog)
        self.view.addSubview(line0)
        self.view.addSubview(line1)
        self.view.addSubview(getVerifiedCodeBtn)
        self.view.addSubview(nextBtn)
        self.view.addSubview(cannotGetVerifiedCodeLable)
        
        // MARK: layout
        tipsLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(28)
            maker.top.equalTo(40)
        }
        pwdLog.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipsLable.snp.left)
            maker.top.equalTo(tipsLable.snp.bottom).offset(25)
            maker.width.equalTo(20)
        }
        getVerifiedCodeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.top.equalTo(pwdLog.snp.top).offset(0)
            maker.width.equalTo(80)
        }
        line0.snp.makeConstraints { (maker) in
            maker.right.equalTo(getVerifiedCodeBtn.snp.left)
            maker.centerY.equalTo(pwdLog.snp.centerY).offset(5)
            maker.width.equalTo(1)
            maker.height.equalTo(20)
        }
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(pwdLog.snp.right).offset(20)
            maker.right.equalTo(line0.snp.left).offset(0)
            maker.centerY.equalTo(pwdLog.snp.centerY)
            maker.height.equalTo(35)
        }
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(1)
            maker.top.equalTo(pwdLog.snp.bottom).offset(12)
        }
        nextBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(45)
            maker.top.equalTo(line1.snp.bottom).offset(35)
        }
        cannotGetVerifiedCodeLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(nextBtn.snp.bottom) .offset(15)
            maker.centerX.equalTo(self.view.snp.centerX)
        }
        
        self.getVerifiedCodeBtn.start(withTime: 120, title: "获取验证码", countDownTitle: "S后重发", mainColor: self.view.backgroundColor ?? .red, count: self.view.backgroundColor ?? .red)
        
        // MARK: nextBtnAction
        let usernameValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 4 }
            .shareReplay(1)
        
        usernameValid
            .bind(to: nextBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 4 ? text: text.substring(to: "1560".endIndex)
            }
            .shareReplay(1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .subscribe(onNext: { [weak  self] in
                guard let phoneNum = self?.phoneNum, let code = self?.pwdTF.text else { return }
                let verfiedVM = UserSessionViewModel()
                let param = SmsCaptchaParam()
                param.phone = phoneNum
                param.type = .changePhoneNum
                param.code = code
                HUD.show(true, show: "", enableUserActions: false, with: self)
                 verfiedVM.checkCaptcha(param: param)
                    .then(execute: { (_) -> Void in
                        let vcc = ModifyPhoneViewController()
                        self?.navigationController?.pushViewController(vcc, animated: true)
                    })
                    .always {
                        HUD.show(false, show: "", enableUserActions: false, with: self)
                    }
                    .catch(execute: { error in
                        if let error = error as? AppError {
                            self?.view.makeToast(error.message)
                        }
                    })
            })
            .disposed(by: disposeBag)
        
        getVerifiedCodeBtn.rx.tap
            .subscribe(onNext: { [weak  self] in
                guard let phoneNum = self?.phoneNum  else { return }
                let verfiedVM = UserSessionViewModel()
                HUD.show(true, show: "", enableUserActions: false, with: self)
                verfiedVM.sendCaptcha(phoneNum: phoneNum, type: .changePhoneNum)
                    .then(execute: { (_) -> Void in
                        self?.getVerifiedCodeBtn.start(withTime: 120, title: "获取验证码", countDownTitle: "S后重发", mainColor: self?.view.backgroundColor ?? .red, count: self?.view.backgroundColor ?? .red)
                        })
                    .always {
                        HUD.show(false, show: "", enableUserActions: false, with: self)
                    }
                    .catch(execute: { error in
                        if let error = error as? AppError {
                            self?.view.makeToast(error.message)
                        }
                    })

            })
            .disposed(by: disposeBag)
    }
}
