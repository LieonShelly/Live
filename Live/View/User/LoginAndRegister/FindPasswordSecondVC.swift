//
//  FindPasswordSecondVC.swift
//  Live
//
//  Created by lieon on 2017/6/27.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PassKit

class FindPasswordSecondVC: BaseViewController, ViewCotrollerProtocol {
    var phoneNum: String = ""
    var popVC: UIViewController?
    fileprivate lazy var findPasswordVM: UserSessionViewModel = UserSessionViewModel()
  fileprivate lazy  var phoneNumTF: UITextField = {
        let phoneNumTF = UITextField()
        phoneNumTF.placeholder = "短信验证码"
        phoneNumTF.textColor = UIColor(hex: 0x222222)
        phoneNumTF.font = UIFont.systemFont(ofSize: 14)
        phoneNumTF.keyboardType = .numberPad
        phoneNumTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        return phoneNumTF
    }()
   fileprivate lazy  var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入6-20位字符"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.systemFont(ofSize: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
  fileprivate lazy   var userLog: UIImageView = {
        let userLog = UIImageView(image: UIImage(named: "user_center_captch"))
        userLog.contentMode = .center
        return userLog
    }()
  fileprivate lazy   var pwdLog: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_pwd"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
  fileprivate lazy   var line0: UIView = {
        let line0 = UIView()
        line0.backgroundColor = UIColor(hex: 0xe6e6e6)
        return line0
    }()
   fileprivate lazy  var line2: UIView = {
        let line0 = UIView()
        line0.backgroundColor = UIColor(hex: 0xe6e6e6)
        return line0
    }()
   fileprivate lazy  var forgetPwdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        forgetPwdBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        forgetPwdBtn.setTitle("重新获取", for: .normal)
    forgetPwdBtn.setTitleColor(UIColor(hex: 0x999999), for: .normal)
        return forgetPwdBtn
    }()
  fileprivate lazy   var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.layer.cornerRadius = 22.5
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitle("确 认", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.isEnabled = false
        return loginBtn
    }()
  fileprivate lazy   var descLabel: UILabel = {
        let descPwdLabel = UILabel()
        descPwdLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        descPwdLabel.textColor = UIColor(hex: 0x999999)
        descPwdLabel.numberOfLines = 0
        descPwdLabel.text = "密码由6-20位字母组成、数字组成，不能有特殊符号，字母需区分大小写"
        return descPwdLabel
    }()
  fileprivate lazy   var verifiCode: String = ""
   fileprivate lazy   var descPwdLabel: UILabel = {
       let  descPwdLabel = UILabel()
        descPwdLabel.font = UIFont.systemFont(ofSize: CGFloat(11))
        descPwdLabel.textColor = UIColor(hex: 0x808080)
        descPwdLabel.numberOfLines = 0
        descPwdLabel.text = "密码由6-20位字母组成、数字组成，不能有特殊符号，字母需区分大小写"
        return descPwdLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        sertupAction()
        addEndingAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumTF.becomeFirstResponder()
        if !phoneNum.isEmpty {
            descLabel.text = "验证码已发至" + phoneNum.implicitPhoneNumFormat()
        }
    }
}

extension FindPasswordSecondVC {
    fileprivate func setupUI() {
        title = "找回密码"
        view.backgroundColor = UIColor.white
        view.addSubview(descLabel)
        view.addSubview(userLog)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdLog)
        view.addSubview(pwdTF)
        view.addSubview(forgetPwdBtn)
        view.addSubview(line2)
        view.addSubview(loginBtn)
        view.addSubview(descPwdLabel)
        descLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(userLog.snp.left)
            maker.right.equalTo(-20)
            maker.top.equalTo(40)
        }
        userLog .snp.makeConstraints { (maker) in
            maker.left.equalTo(30)
            maker.top.equalTo(descLabel.snp.bottom).offset(37.5)
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
            maker.left.equalTo(userLog.snp.left)
            maker.top.equalTo(line0.snp.bottom).offset(12)
            maker.width.equalTo(20)
        }
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-35)
            maker.centerY.equalTo(phoneNumTF.snp.centerY)
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
        descPwdLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(line2.snp.bottom).offset(12)
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
        }
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(descPwdLabel.snp.bottom).offset(44)
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(45)
        }
    }
    
    fileprivate func sertupAction() {
        let usernameValid = phoneNumTF.rx.text.orEmpty
            .map { $0.characters.count >= 4}
            .shareReplay(1)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 6 }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 20 ? text: text.substring(to: "01234567890112345678".endIndex)
            }
            .shareReplay(1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        phoneNumTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 4 ? text: text.substring(to: "0123".endIndex)
            }
            .shareReplay(1)
            .bind(to: phoneNumTF.rx.text)
            .disposed(by: disposeBag)
        
        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        forgetPwdBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.findPasswordVM.sendCaptcha(phoneNum: self?.phoneNum ?? "", type: .findPassword)
                    .then(execute: { isSuucssss -> Void in
                        if isSuucssss {
                            self?.forgetPwdBtn.start(withTime: 120, title: "获取验证码", countDownTitle: "S后重发", mainColor: self?.view.backgroundColor, count: self?.view.backgroundColor)
                        }
                    })
                    .catch(execute: { error in
                        if let error = error as? AppError {
                            self?.view.makeToast(error.message)
                        }
                    })
            })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                HUD.show(true, show: "", enableUserActions: false, with: self)
                let param = UserRequestParam()
                param.username = self?.phoneNum
                param.code = self?.phoneNumTF.text
                param.password = self?.pwdTF.text?.md5()
                param.capchaCodeType = .findPassword
                self?.findPasswordVM.findPassword(param: param)
                    .then(execute: { (isSuccss) -> Void in
                        if isSuccss {
                            if let weakSelf = self, let popVC = weakSelf.popVC {
                                self?.navigationController?.popToViewController(popVC, animated: true)
                            } else {
                                self?.navigationController?.popToRootViewController(animated: true)
                                // fastRegisterVCHandle通知，仅仅只是为了传递电话号码
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fastRegisterVCHandle"), object: self, userInfo: ["phoneNum": self?.phoneNum ?? ""])
                            }
                        }
                    })
                    .always {
                        HUD.show(false, show: "", enableUserActions: false, with: self)
                    }
                    .catch(execute: { (error) in
                        if let error = error as? AppError {
                            self?.view.makeToast(error.message)
                        }
                    })
            })
            .disposed(by: disposeBag)

    }
    
}
