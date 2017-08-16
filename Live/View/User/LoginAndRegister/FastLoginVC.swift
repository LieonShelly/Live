//
//  FastLoginVC.swift
//  Live
//
//  Created by lieon on 2017/6/27.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit
import RxSwift
import PromiseKit
import RxCocoa
import RxBlocking

class FastLoginVC: BaseViewController, ViewCotrollerProtocol {
    var phoneNum: String = ""
    fileprivate var isNeedRegister: Bool = false
    fileprivate lazy var fastLoginVM: UserSessionViewModel = UserSessionViewModel()
    fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机号"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        return textField
    }()
    fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.placeholder = "短信验证码"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
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
        getVerifiedCodeBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        getVerifiedCodeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        getVerifiedCodeBtn.setTitle("获取验证码", for: .normal)
        getVerifiedCodeBtn.setTitleColor(UIColor(hex: 0x999999), for: .disabled)
        getVerifiedCodeBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        
        return getVerifiedCodeBtn
    }()
    
    fileprivate lazy  var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("登 录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.layer.cornerRadius = 22.5
        loginBtn.layer.masksToBounds = true
        loginBtn.isEnabled = false
        return loginBtn
    }()
    fileprivate lazy  var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        descLabel.textColor = UIColor(hex: CustomKey.Color.mainColor)
        descLabel.text = "若您输入的手机号未注册，将会进入注册流程"
        return descLabel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        addEndingAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !phoneNum.isEmpty {
            phoneNumTF.text = phoneNum
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }
}

extension FastLoginVC {
    fileprivate func setupUI() {
        title = "手机快速登录"
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
                if self!.isNeedRegister {
                    self?.registerAction()
                } else {
                    self?.loginAction()
                }
            })
            .disposed(by: disposeBag)
        
        getVerifiedCodeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if let num = self?.phoneNumTF.text {
                    self?.fastLoginVM.validate(phoneNum: num)
                        .then(execute: { isRegister -> Promise<Bool> in
                            if isRegister { // 已经注册，发送验证码，进行登录
                                self?.loginBtn.setTitle("登 录", for: .normal)
                                return self!.fastLoginVM.sendCaptcha(phoneNum: num, type: .phoneNumLogin)
                            } else { // 未注册，询问是否发送验证码
                                self?.shoAltertoRegisterVC() 
                               return Promise<Bool>(value: false)
                        }
                    }).then(execute: { isSuccess -> Void in
                        if isSuccess {
                            self?.isNeedRegister = false
                            self?.getVerifiedCodeBtn.start(withTime: 120, title: "获取验证码", countDownTitle: "S后重发", mainColor: self!.view.backgroundColor!, count: self!.view.backgroundColor!)
                        }
                    })
                    
                    .catch(execute: { error in
                        if let error = error as? AppError {
                            self?.view.makeToast(error.message)
                        }
                    })
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    fileprivate func shoAltertoRegisterVC() {
        let destVC = CallServiceViewController()
        destVC.configMsg("该手机号码还未注册，是否发送验证码进行注册", withEnterTitle: "发送", cancelTitle: "取消")
        destVC.enterAction = {() -> Void in
            if let phoneNum = self.phoneNumTF.text {
               self.fastLoginVM.sendCaptcha(phoneNum: phoneNum, type: .register)
                .then(execute: { isSuccess -> Void in
                    if isSuccess {
                        self.isNeedRegister = true
                        self.getVerifiedCodeBtn.start(withTime: 120, title: "获取验证码", countDownTitle: "S后重发", mainColor: self.view.backgroundColor!, count: self.view.backgroundColor!)
                        self.loginBtn.setTitle("下 一 步", for: .normal)
                    }
                })
                .catch(execute: { error in
                    if let error = error as? AppError {
                        self.view.makeToast(error.message)
                    }
                })
            }
            
        }
        destVC.transitioningDelegate = animator
        destVC.modalPresentationStyle = .custom
        present(destVC, animated: true, completion: { _ in })
     
    }
    
    fileprivate func registerAction() {
        if let num = self.phoneNumTF.text, let code = self.pwdTF.text {
            let param = SmsCaptchaParam()
            param.phone = num
            param.code = code
            param.type = .register
            HUD.show(true, show: "", enableUserActions: false, with: self)
            self.fastLoginVM.checkCaptcha(param: param)
                .then(execute: {  isSuccess -> Void in
                    if isSuccess {
                        let regisetrVC =  ThirdStepFastRegisterVC()
                        let param = UserRequestParam()
                        param.username =  num
                        param.code = code
                        regisetrVC.session = SessionHandleType.normal(.register, param)
                        self.navigationController?.pushViewController(regisetrVC, animated: true)
                    }
                })
                .always {
                    HUD.show(false, show: "", enableUserActions: false, with: self)
                }
                .catch(execute: { (error) in
                    if let error = error as? AppError {
                        self.view.makeToast(error.message)
                    }
                })
        }
    }
    
    fileprivate func loginAction() {
        let param = UserRequestParam()
        param.code = self.pwdTF.text
        param.username = self.phoneNumTF.text
        HUD.show(true, show: "", enableUserActions: false, with: self)
        self.fastLoginVM.login(sessionType: .normal(.fastLogin, param))
            .then(execute: { isSuccess -> Void in
                if isSuccess {
                    isToInfoVC(self)
                }
                
            })
            .always {
                HUD.show(false, show: "", enableUserActions: false, with: self)
            }
            .catch(execute: { (error) in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
            })
    }
}
