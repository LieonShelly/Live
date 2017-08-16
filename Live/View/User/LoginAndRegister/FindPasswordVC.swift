//
//  FindPasswordVC.swift
//  Live
//
//  Created by lieon on 2017/6/26.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit
import PromiseKit
import RxCocoa
import RxSwift

class FindPasswordVC: BaseViewController, ViewCotrollerProtocol {
    var phoneNum: String = ""
    var popVC: UIViewController?
     fileprivate lazy var findPasswordVM: UserSessionViewModel = UserSessionViewModel()
    fileprivate var verifiCode: String = ""
   fileprivate lazy  var phoneNumTF: UITextField = {
        let phoneNumTF = UITextField()
        phoneNumTF.placeholder = "请输入手机号"
        phoneNumTF.textColor = UIColor(hex: 0x222222)
        phoneNumTF.font = UIFont.sizeToFit(with: 14)
        phoneNumTF.keyboardType = .numberPad
        phoneNumTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        return phoneNumTF
    }()
    fileprivate lazy var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = false
        pwdTF.placeholder = "请输入右侧验证码"
        pwdTF.textColor =  UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    fileprivate lazy var userLog: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_phone_num"))
        imageView.contentMode = .center
        return imageView
    }()
   fileprivate lazy  var pwdLog: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_captch"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
     fileprivate lazy var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
   fileprivate lazy  var line2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy var forgetPwdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        forgetPwdBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        forgetPwdBtn.setTitle("忘记密码", for: .normal)
        forgetPwdBtn.setTitleColor(UIColor(hex: 0x808080), for: .normal)
        return forgetPwdBtn
    }()
    fileprivate lazy var loginBtn: UIButton = {
          let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("下 一 步", for: .normal)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.isEnabled = false
        return loginBtn
    }()
    fileprivate lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        descLabel.textColor = UIColor(hex: 0x808080)
        descLabel.text = "我们将发送验证码到您的手机"
        return descLabel
    }()
    
    fileprivate lazy var contactBtn: UIButton = {
        let contactBtn = UIButton()
        contactBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(16))
        contactBtn.setTitle("联系客服", for: .normal)
        contactBtn.setTitleColor(UIColor.white, for: .normal)
        contactBtn.sizeToFit()
        return contactBtn
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
        verifiCode = String.randomStr(withLength: 4)
        forgetPwdBtn.setTitle(verifiCode, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }
}

extension FindPasswordVC {
    fileprivate func setupUI() {
        title = "找回密码"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contactBtn)
        view.addSubview(descLabel)
        view.addSubview(userLog)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdLog)
        view.addSubview(pwdTF)
        view.addSubview(line1)
        view.addSubview(forgetPwdBtn)
        view.addSubview(line2)
        view.addSubview(loginBtn)
        
        descLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(30)
            maker.top.equalTo(40)
            maker.bottom.equalTo(userLog.snp.top).offset(-30)
        }
        userLog.snp.makeConstraints { (maker) in
            maker.left.equalTo(30)
            maker.top.equalTo(110)
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
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-35)
            maker.centerY.equalTo(pwdLog.snp.centerY)
        }
        line1.snp.makeConstraints { (maker) in
            maker.right.equalTo(forgetPwdBtn.snp.left).offset(-12)
            maker.height.equalTo(20)
            maker.centerY.equalTo(pwdLog.snp.centerY)
            maker.width.equalTo(0.5)
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
            maker.top.equalTo(line2.snp.bottom).offset(70)
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(40)
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
        
        forgetPwdBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.verifiCode = String.randomStr(withLength: 4)
                self?.forgetPwdBtn.setTitle(self?.verifiCode, for: .normal)
               })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.view.endEditing(true)
                let verifiCode: String = self?.verifiCode.lowercased() ?? ""
                let inputCode: String = (self?.pwdTF.text ?? "").lowercased() 
                if !(inputCode == verifiCode) {
                    UIApplication.shared.keyWindow?.makeToast("验证码输入错误")
                    return
                }
                HUD.show(true, show: "", enableUserActions: false, with: self)
                if let phoneNum = self?.phoneNumTF.text {
                    self?.findPasswordVM.validate(phoneNum: phoneNum)
                    .then(execute: { isRegisetr -> Promise<Bool> in
                        if isRegisetr { // 已经注册,发送验证码 找回密码
                         return   self!.findPasswordVM.sendCaptcha(phoneNum: phoneNum, type: CaptchaType.findPassword)
                        } else { // 未注册发送验证，跳转到注册页，进行注册
                            self?.shoAltertoRegisterVC()
                            return Promise<Bool>(value: false)
                        }
                    }).then(execute: { isSuccess -> Void in
                        if isSuccess {
                            let vcc = FindPasswordSecondVC()
                            vcc.phoneNum = self?.phoneNumTF.text ?? ""
                            if let popVC = self?.popVC {
                                vcc.popVC = popVC
                            }
                            self?.navigationController?.pushViewController(vcc, animated: true)
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
                }
            })
            .disposed(by: disposeBag)
        
        contactBtn.rx.tap.subscribe(onNext: { [weak self] in
            let destVC = CallServiceViewController()
            destVC.configMsg("400-189-0090", withEnterTitle: "拨打")
            destVC.enterAction = {() -> Void in
                let str: String = "telprompt://\("400-189-0090")"
                if  UIApplication.shared.canOpenURL(URL(string: str)!) {
                    UIApplication.shared.openURL(URL(string: str)!)
                }
            }
            destVC.transitioningDelegate = self?.animator
            destVC.modalPresentationStyle = .custom
            self?.present(destVC, animated: true, completion: { _ in })
        })
            .disposed(by: disposeBag)
        
    }
   
    fileprivate func shoAltertoRegisterVC() {
        let destVC = CallServiceViewController()
        destVC.configMsg("该手机号码还未注册，请先注册?", withEnterTitle: "去注册", cancelTitle: "取消")

        destVC.enterAction = {() -> Void in
            let vcc = FastRegisterViewController()
            if let phoneNum = self.phoneNumTF.text {
                let param = UserRequestParam()
                param.username = phoneNum
                let newSession = SessionHandleType.normal(.register, param)
                vcc.session = newSession
            }
            self.navigationController?.pushViewController(vcc, animated: true)
        }
        destVC.transitioningDelegate = animator
        destVC.modalPresentationStyle = .custom
        present(destVC, animated: true, completion: { _ in })
    }
    
}
