//
//  FastRegisterViewController.swift
//  Live
//
//  Created by lieon on 2017/6/26.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit
import RxSwift
import RxCocoa
import PromiseKit

class FastRegisterViewController: BaseViewController, ViewCotrollerProtocol {
     var session: SessionHandleType?
    
    fileprivate lazy var regisetrVM: UserSessionViewModel = UserSessionViewModel()
    fileprivate lazy var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机号"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        return textField
    }()
    fileprivate lazy  var userLog: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "user_phone_num"))
        imageView.contentMode = .center
        return imageView
    }()
    fileprivate lazy var line0: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy  var loginBtn: UIButton = {
       let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitle("下 一 步", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.isEnabled = false
        return loginBtn
    }()
    fileprivate lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        descLabel.textColor = UIColor(hex: CustomKey.Color.mainColor)
        descLabel.text = "注册即视为同意"
        return descLabel
    }()
    fileprivate lazy var contactBtn: UIButton = {
        let contactBtn = UIButton()
        contactBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contactBtn.setTitle("联系客服", for: .normal)
        contactBtn.setTitleColor(UIColor.white, for: .normal)
        contactBtn.sizeToFit()
          return contactBtn
    }()
    fileprivate lazy var tapLabel: UIButton = {
        let tapLabel = UIButton()
        tapLabel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        tapLabel.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        tapLabel.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .highlighted)
        tapLabel.setTitle("《哆集服务条款》", for: .normal)
        tapLabel.sizeToFit()
        return tapLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        addEndingAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let session = self.session {
            let param = session.param
            let phoneNum = param.username ?? ""
            if !phoneNum.isEmpty {
                phoneNumTF.text = phoneNum
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         phoneNumTF.becomeFirstResponder()
    }
}

extension FastRegisterViewController {
    fileprivate func setupUI() {
        title = "手机快速注册"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contactBtn)
        view.backgroundColor = .white
        view.addSubview(userLog)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(loginBtn)
        view.addSubview(descLabel)
        view.addSubview(tapLabel)
        view.addSubview(userLog)

        userLog.snp.makeConstraints { maker in
            maker.left.equalTo(30)
            maker.top.equalTo(73)
            maker.width.equalTo(20)
        }
        phoneNumTF.snp.makeConstraints { maker in
            maker.left.equalTo(userLog.snp.right).offset(20)
            maker.centerY.equalTo(userLog.snp.centerY)
            maker.right.equalTo(view.snp.right).inset(30)
        }
        line0.snp.makeConstraints { maker in
            maker.left.equalTo(userLog.snp.left).offset(0)
            maker.right.equalTo(view.snp.right).inset(30)
            maker.height.equalTo(0.5)
            maker.top.equalTo(phoneNumTF.snp.bottom).offset(12)
        }
        descLabel.snp.makeConstraints { maker in
            maker.left.equalTo(view.snp.left).offset(10)
            maker.top.equalTo(line0.snp.bottom).offset(15.5)
        }
        tapLabel.snp.makeConstraints { maker in
            maker.left.equalTo(descLabel.snp.right)
            maker.centerY.equalTo(descLabel.snp.centerY).offset(0)
        }
        loginBtn.snp.makeConstraints { maker in
            maker.left.equalTo(view.snp.left).offset(10)
            maker.right.equalTo(view.snp.right).inset(10)
            maker.height.equalTo(40)
            maker.top.equalTo(line0.snp.bottom).offset(59)
        }
    }
    
    fileprivate func setAction() {
        let usernameValid = phoneNumTF.rx.text.orEmpty
            .map { $0.characters.count >= 11 }
            .shareReplay(1)
        usernameValid
        .bind(to: loginBtn.rx.isEnabled)
        .disposed(by: disposeBag)
        
        phoneNumTF.rx.text.orEmpty
            .map { (text) -> String in
                    return text.characters.count <= 11 ? text: text.substring(to: "15608006621".endIndex)
               }
            .shareReplay(1)
            .bind(to: phoneNumTF.rx.text)
            .disposed(by: disposeBag)
        
         loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
            self?.handleAction()
            })
            .disposed(by: disposeBag)
        
        tapLabel.rx.tap
            .subscribe(onNext: { [weak self] in
            self?.toWebViewAction()
        })
            .disposed(by: disposeBag)
        
        contactBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.contactAction()
        })
            .disposed(by: disposeBag)
    }
    
    fileprivate func handleAction() {
        if let num = phoneNumTF.text {
            HUD.show(true, show: "", enableUserActions: false, with: self)
            regisetrVM.validate(phoneNum: num)
            .then(execute: { isRegister -> Promise<Bool>  in
                if isRegister { // 已经注册，去登录页面
                    self.shoAltertoLoginVC()
                    return Promise<Bool>(value: false)
                } else { // 未注册发送验证码
                    return self.regisetrVM.sendCaptcha(phoneNum: num, type: .register)
                }
            }).then(execute: { isSuccess -> Void in
                if isSuccess {
                    let secondVC = SecondFastRegisterVC()
                    let param = UserRequestParam()
                    param.username = num
                    if let handleSession = self.session {
                        switch handleSession {
                        case .QQ(let path, let handleParam):
                            handleParam.username = num
                            secondVC.session = .QQ(path, handleParam)
                       case .weibo(let path, let handleParam):
                            handleParam.username = num
                            secondVC.session = .weibo(path, handleParam)
                      case .wechat(let path, let handleParam):
                            handleParam.username = num
                            secondVC.session = .wechat(path, handleParam)
                     case .normal(_, _):
                            let newSession = SessionHandleType.normal(.register, param)
                            secondVC.session = newSession
                      }
                    } else {
                        let newSession = SessionHandleType.normal(.register, param)
                        secondVC.session = newSession
                    }
                    self.navigationController?.pushViewController(secondVC, animated: true)
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
    
    fileprivate func shoAltertoLoginVC() {
        let destVC = CallServiceViewController()
        destVC.configMsg("该手机号已被注册，是否立即登录?", withEnterTitle: "确定", cancelTitle: "找回密码")
        destVC.enterAction = {() -> Void in
            if let num = self.phoneNumTF.text {
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fastRegisterVCHandle"), object: self, userInfo: ["phoneNum": num])
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
        destVC.cancelAction = {() -> Void in
            let vcc = FindPasswordVC()
            vcc.phoneNum = self.phoneNumTF.text ?? ""
            self.navigationController?.pushViewController(vcc, animated: true)
        }
        destVC.transitioningDelegate = animator
        destVC.modalPresentationStyle = .custom
        present(destVC, animated: true, completion: { _ in })
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

   fileprivate func toWebViewAction() {
        view.endEditing(true)
        let webVC = WebPageController(urlStr: "http://duoji.b0.upaiyun.com/default/protocol/reg-live.html", navTitle: "")
        navigationController?.pushViewController(webVC, animated: true)
    }

}
