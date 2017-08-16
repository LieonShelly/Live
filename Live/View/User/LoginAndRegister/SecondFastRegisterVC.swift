//
//  SecondFastRegisterVC.swift
//  Live
//
//  Created by lieon on 2017/6/26.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit

class SecondFastRegisterVC: BaseViewController, ViewCotrollerProtocol {
      var session: SessionHandleType?
     fileprivate var phoneNum: String = ""
     fileprivate lazy var regisetrVM: UserSessionViewModel = UserSessionViewModel()
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
        getVerifiedCodeBtn.setTitle("重新获取", for: .normal)
        getVerifiedCodeBtn.setTitleColor(UIColor.gray, for: .disabled)
        getVerifiedCodeBtn.setTitleColor(UIColor.gray, for: .normal)
        return getVerifiedCodeBtn
    }()
    fileprivate lazy  var loginBtn: UIButton = {
       let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.layer.cornerRadius = 22.5
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitle("下 一 步", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.isEnabled = false
        return loginBtn
    }()
    fileprivate lazy  var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        descLabel.textColor = UIColor(hex: 0x808080)
        descLabel.text = "手机验证码已发送至*********"
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
        if let session = session {
             let param = session.param
             let phoneNum = param.username ?? ""
             if !phoneNum.isEmpty {
                descLabel.text = "手机验证码已发送至\(phoneNum.implicitPhoneNumFormat())"
                self.phoneNum = phoneNum
                pwdTF.becomeFirstResponder()
            }
           
        }
    }
    
}

extension SecondFastRegisterVC {
    fileprivate func setupUI() {
        title = "手机快速注册"
     navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contactBtn)
        view.backgroundColor = .white
        view.addSubview(line0)
        view.addSubview(pwdLog)
        view.addSubview(pwdTF)
        view.addSubview(line1)
        view.addSubview(getVerifiedCodeBtn)
        view.addSubview(loginBtn)
        view.addSubview(descLabel)

        descLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(73)
        }
        pwdLog.snp.makeConstraints { (maker) in
            maker.left.equalTo(descLabel.snp.left)
            maker.top.equalTo(descLabel.snp.bottom).offset(25)
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
        loginBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(45)
            maker.top.equalTo(line1.snp.bottom).offset(35)
        }
       
    }
    
    fileprivate func setupAction() {
        let usernameValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 4 }
            .shareReplay(1)
        
        usernameValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 4 ? text: text.substring(to: "1560".endIndex)
            }
            .shareReplay(1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        contactBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.contactAction()
        })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap.subscribe(onNext: { [weak self] in

            let param = SmsCaptchaParam()
            param.phone = self?.phoneNum
            param.type = .register
            param.code = self?.pwdTF.text
            self?.nextAction(param: param)
        })
            .disposed(by: disposeBag)
        
        getVerifiedCodeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
            self?.sendVerifiedCodeAgain()
        })
            .disposed(by: disposeBag)
    }
    
    fileprivate func contactAction() {
        let destVC = CallServiceViewController()
        destVC.configMsg("400-189-0090", withEnterTitle: "拨打")
        destVC.enterAction = {() -> Void in
            let str: String = "telprompt://\("400-189-0090")"
            if  UIApplication.shared.canOpenURL(URL(string: str)!) {
                UIApplication.shared.openURL(URL(string: str)!)
            }
        }
        destVC.transitioningDelegate = animator
        destVC.modalPresentationStyle = .custom
        present(destVC, animated: true, completion: { _ in })
    }
    
    fileprivate func nextAction(param: SmsCaptchaParam) {
        HUD.show(true, show: "", enableUserActions: false, with: self)
        regisetrVM.checkCaptcha(param: param)
            .then { isRightCode -> Void in
            if isRightCode {
                print("isRightCode")
                let param = UserRequestParam()
                param.username = self.phoneNum
                param.code = self.pwdTF.text
                let thirdVC = ThirdStepFastRegisterVC()
                if let session = self.session { /// 若是第三方登录过来的，要重新进行session重构
                    switch session {
                    case .QQ(_, let handleParam):
                        handleParam.username = self.phoneNum
                        handleParam.code = self.pwdTF.text
                        thirdVC.session = .QQ(UserPath.thirdPartyRegiseterQQ, handleParam)
                    case .wechat(_, let handleParam):
                        handleParam.username = self.phoneNum
                        handleParam.code = self.pwdTF.text
                        thirdVC.session = .wechat(.thirdPartyRegiseterWechat, handleParam)
                    case .weibo(_, let handleParam):
                        handleParam.username = self.phoneNum
                        handleParam.code = self.pwdTF.text
                        thirdVC.session = .weibo(.thirdPartyRegiseterWeibo, handleParam)
                    case .normal(_, _):
                        let newSession = SessionHandleType.normal(.register, param)
                        thirdVC.session = newSession
                    }
                    self.navigationController?.pushViewController(thirdVC, animated: true)
                }
               
                }
            }
            .always {
                HUD.show(false, show: "", enableUserActions: false, with: self)
            }
            .catch { error in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
            }
    }
    
    fileprivate func sendVerifiedCodeAgain() {
        regisetrVM.sendCaptcha(phoneNum: self.phoneNum, type: .register)
        .then { _ -> Void in
            self.getVerifiedCodeBtn.start(withTime: 120, title: "获取验证码", countDownTitle: "S后重发", mainColor: self.view.backgroundColor!, count: self.view.backgroundColor!)
        }.catch { error in
            if let error = error as? AppError {
                self.view.makeToast(error.message)
            }
        }
    }
}
