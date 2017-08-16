//
//  ThirdStepFastRegisterVC.swift
//  Live
//
//  Created by lieon on 2017/6/26.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit

class ThirdStepFastRegisterVC: BaseViewController, ViewCotrollerProtocol {
    var session: SessionHandleType?
    fileprivate lazy var regisetrVM: UserSessionViewModel = UserSessionViewModel()
    fileprivate lazy  var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入6-20位字符"
        pwdTF.textColor = UIColor(hex:0x333333)
        pwdTF.font = UIFont.systemFont(ofSize: 13)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    fileprivate lazy  var pwdLog: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_pwd"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
    fileprivate lazy  var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy  var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitle("完 成", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.isEnabled = false
        return loginBtn
    }()
    fileprivate lazy  var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x808080)
        descLabel.text = "请设置登录密码"
        return descLabel
    }()
    // 
    fileprivate lazy  var descPwdLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        descLabel.textColor = UIColor(hex: 0x808080)
        descLabel.text = "密码由6-20位字母组成、数字组成，不能有特殊符号，字母需区分大小写"
        descLabel.numberOfLines = 0
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pwdTF.becomeFirstResponder()
    }
}

extension ThirdStepFastRegisterVC {
    fileprivate func setupUI() {
        title = "手机快速注册"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contactBtn)
        view.addSubview(pwdLog)
        view.addSubview(pwdTF)
        view.addSubview(line1)
        view.addSubview(loginBtn)
        view.addSubview(descLabel)
        view.addSubview(descPwdLabel)
        descLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(84)
        }
        pwdLog.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(self.descLabel.snp.bottom).offset(35)
            maker.width.equalTo(20)
        }
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(pwdLog.snp.right).offset(20)
            maker.right.equalTo(view.snp.right).offset(-60)
            maker.centerY.equalTo(pwdLog.snp.centerY)
            maker.height.equalTo(35)
        }
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.top.equalTo(pwdLog.snp.bottom).offset(12)
            maker.height.equalTo(0.5)
        }
        descPwdLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.top.equalTo(line1.snp.bottom).offset(10)
        }
        loginBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.top.equalTo(line1.snp.bottom).offset(70)
            maker.height.equalTo(40)
        }
       
    }
    
    fileprivate func setupAction() {
        let usernameValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 6 }
            .shareReplay(1)
        
        usernameValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 12 ? text: text.substring(to: "012345678901".endIndex)
            }
            .shareReplay(1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        contactBtn.rx.tap
            .subscribe(onNext: { [weak self] in
            self?.contactAction()
            })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.registerAction()
            
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
    
    fileprivate func registerAction() {
        session?.param.password = pwdTF.text?.md5()
         HUD.show(true, show: "", enableUserActions: false, with: self)
        if let session = session {
            regisetrVM.register(sessionType: session)
            .then(execute: {  isRegisetr-> Void in
                print(isRegisetr)
                if isRegisetr {
                  isToInfoVC(self)
                }
            })
            .always {
                    HUD.show(false, show: "", enableUserActions: false, with: self)
                }
            .catch(execute: { error in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
            })
        }
    }
}
