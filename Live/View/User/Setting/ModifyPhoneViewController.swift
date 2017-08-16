//
//  ModifyPhoneViewController.swift
//  Live
//
//  Created by fanfans on 2017/7/13.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PromiseKit

class ModifyPhoneViewController: BaseViewController {
    fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入新手机号码"
        textField.font = UIFont.sizeToFit(with: 13)
        textField.textColor = UIColor(hex: 0x333333)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        return textField
    }()
    fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.placeholder = "请输入收到的验证码"
        pwdTF.textColor = UIColor(hex: 0x333333)
        pwdTF.font = UIFont.sizeToFit(with: 13)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    fileprivate lazy  var userLog: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_phone_num"))
        imageView.contentMode = .center
        return imageView
    }()
    fileprivate lazy   var pwdLog: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_captch"))
        pwdLog.contentMode = .center
        return pwdLog
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
    fileprivate lazy  var line2: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy var getVerifiedCodeBtn: UIButton = {
        let getVerifiedCodeBtn = UIButton()
        getVerifiedCodeBtn.sizeToFit()
        getVerifiedCodeBtn.titleLabel?.font = UIFont.sizeToFit(with: 12)
        getVerifiedCodeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        getVerifiedCodeBtn.setTitle("获取验证码", for: .normal)
        getVerifiedCodeBtn.setTitleColor(UIColor.gray, for: .disabled)
        getVerifiedCodeBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        return getVerifiedCodeBtn
    }()
    
    fileprivate lazy  var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("确认更换", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.layer.cornerRadius = 22.5
        loginBtn.layer.masksToBounds = true
        loginBtn.isEnabled = false
        return loginBtn
    }()
    fileprivate lazy  var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(11))
        descLabel.textColor = UIColor(hex: CustomKey.Color.mainColor)
        descLabel.text = "更换手机号，原手机号不能登录"
        return descLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
}

extension ModifyPhoneViewController {
    fileprivate func setupUI() {
        title = "更换手机号"
        view.backgroundColor = .white
        view.addSubview(userLog)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdLog)
        view.addSubview(pwdTF)
        view.addSubview(line1)
        view.addSubview(getVerifiedCodeBtn)
        view.addSubview(line2)
        view.addSubview(loginBtn)
        view.addSubview(descLabel)
        userLog.snp.makeConstraints { (maker) in
            maker.top.equalTo(80)
            maker.left.equalTo(30)
            maker.width.equalTo(20)
        }
        phoneNumTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(userLog.snp.right).offset(20)
            maker.centerY.equalTo(userLog.snp.centerY)
            maker.right.equalTo(-30)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(userLog.snp.bottom).offset(12)
            maker.right.equalTo(-20)
            maker.height.equalTo(0.5)
        }
        pwdLog.snp.makeConstraints { (maker) in
            maker.left.equalTo(userLog.snp.left).offset(2)
            maker.top.equalTo(line0.snp.bottom).offset(12)
            maker.width.equalTo(20)
        }
        getVerifiedCodeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-35)
            maker.centerY.equalTo(pwdLog.snp.centerY)
        }
        line1.snp.makeConstraints { (maker) in
            maker.right.equalTo(getVerifiedCodeBtn.snp.left).offset(-12)
            maker.width.equalTo(1)
            maker.height.equalTo(20)
            maker.centerY.equalTo(pwdLog.snp.centerY)
        }
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(phoneNumTF.snp.right)
            maker.top.equalTo(line0.snp.bottom).offset(12)
        }
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdLog.snp.bottom).offset(12)
            maker.left.equalTo(line0.snp.left)
            maker.right.equalTo(line0.snp.right)
            maker.height.equalTo(0.5)
        }
        loginBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(45)
            maker.top.equalTo(line2.snp.bottom).offset(50)
        }
        descLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.top.equalTo(loginBtn.snp.bottom).offset(26)
        }
    }
    
    fileprivate func setupAction() {
        let usernameValid = phoneNumTF.rx.text.orEmpty
            .map { $0.characters.count >= 11}
            .shareReplay(1)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 4 }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        usernameValid
            .bind(to: getVerifiedCodeBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 4 ? text: text.substring(to: "0123".endIndex)
            }
            .shareReplay(1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        phoneNumTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 11 ? text: text.substring(to: "15608006621".endIndex)
            }
            .shareReplay(1)
            .bind(to: phoneNumTF.rx.text)
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe (onNext: { [weak self] in
                let modifyVM = UserSessionViewModel()
                HUD.show(true, show: "", enableUserActions: false, with: self)
                let param = UserRequestParam()
                param.phone = self?.phoneNumTF.text ?? ""
                param.code = self?.pwdTF.text ?? ""
                  modifyVM.requestExchangePhoneNum(with: param)
                    .then(execute: { (_) -> Void in
                        guard let navigationVC = self?.navigationController else {
                           return
                        }
                        for vcc in navigationVC.viewControllers {
                            if vcc is SettingViewController {
                                navigationVC.popToViewController(vcc, animated: true)
                            }
                        }
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
                let verfiedVM = UserSessionViewModel()
                HUD.show(true, show: "", enableUserActions: false, with: self)
                verfiedVM.sendCaptcha(phoneNum: self?.phoneNumTF.text ?? "", type: .changePhoneNum)
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
