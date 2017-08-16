//
//  ThirdpartyBindingController.swift
//  Live
//
//  Created by lieon on 2017/6/28.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PromiseKit
import Alamofire

class ThirdpartyBindingController: BaseViewController, ViewCotrollerProtocol {
     var session: SessionHandleType?
    fileprivate lazy var bindVM: UserSessionViewModel = UserSessionViewModel()
    fileprivate var phoneNumTF: UITextField!
    fileprivate var pwdTF: UITextField!
    fileprivate var codeTF: UITextField!
    fileprivate var pooCodeView: PooCodeView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addEndingAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }
    
    fileprivate func setup() {
        title = "账户绑定"
        let bgView = UIView(frame: CGRect(x: 0, y: 20.0.fitHeight, width: UIScreen.width, height: 320.0.fitHeight))
        bgView.backgroundColor = UIColor.white
        view.addSubview(bgView)
        let phoneNumLable = UILabel(frame: CGRect(x:30.0.fitHeight, y: CGFloat(0), width: 200.0.fitHeight, height: 110.0.fitHeight))
        phoneNumLable.textColor = UIColor(hex: 0x222222)
        phoneNumLable.font = UIFont.sizeToFit(with: 14)
        phoneNumLable.text = "哆集账号"
        bgView.addSubview(phoneNumLable)
        
        phoneNumTF = UITextField(frame: CGRect(x: CGFloat(phoneNumLable.frame.origin.x + phoneNumLable.frame.size.width), y: CGFloat(0), width: 470.0.fitWidth, height: CGFloat(phoneNumLable.frame.size.height)))
        phoneNumTF.placeholder = "请输入您的手机号码"
        phoneNumTF.textColor = UIColor(hex:0x333333)
        phoneNumTF.font = UIFont.sizeToFit(with: 15)
        phoneNumTF.keyboardType = .numberPad
        phoneNumTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        bgView.addSubview(phoneNumTF)
        
        let line1 = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(phoneNumLable.frame.origin.y + phoneNumLable.frame.size.height), width: CGFloat(UIScreen.width), height: CGFloat(0.5)))
        line1.backgroundColor = UIColor(hex: 0xe6e6e6)
        bgView.addSubview(line1)
        let pwdLable = UILabel(frame: CGRect(x: CGFloat(phoneNumLable.frame.origin.x), y: CGFloat(line1.frame.origin.y), width: CGFloat(phoneNumLable.frame.size.width), height: 100.0.fitHeight))
        pwdLable.textColor = UIColor(hex: 0x222222)
        pwdLable.font = UIFont.sizeToFit(with: 14)
        pwdLable.text = "密码"
        bgView.addSubview(pwdLable)
        
        pwdTF = UITextField(frame: CGRect(x: CGFloat(phoneNumTF.frame.origin.x), y: CGFloat(pwdLable.frame.origin.y), width: CGFloat(phoneNumTF.frame.size.width), height: CGFloat(phoneNumTF.frame.size.height)))
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入密码"
        pwdTF.textColor =  UIColor(hex: 0x333333)
        pwdTF.font = UIFont.sizeToFit(with: 15)
        pwdTF.tintColor =  UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .next
        bgView.addSubview(pwdTF)
        
        let line2 = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(pwdLable.frame.origin.y + pwdLable.frame.size.height), width: UIScreen.width, height: CGFloat(0.5)))
        line2.backgroundColor = UIColor(hex: 0xe6e6e6)
        bgView.addSubview(line2)
        let codeLable = UILabel(frame: CGRect(x: CGFloat(phoneNumLable.frame.origin.x), y: CGFloat(line2.frame.origin.y), width: CGFloat(phoneNumLable.frame.size.width), height: 110.0.fitHeight))
        codeLable.textColor = UIColor(hex: 0x222222)
        codeLable.font = UIFont.sizeToFit(with: 14)
        codeLable.text = "验证码"
        bgView.addSubview(codeLable)
        
        codeTF = UITextField(frame: CGRect(x: CGFloat(phoneNumTF.frame.origin.x), y: CGFloat(codeLable.frame.origin.y), width: 320.0.fitWidth, height: CGFloat(phoneNumTF.frame.size.height)))
        codeTF.placeholder = "请输入验证码"
        codeTF.textColor = UIColor(hex: 0x333333)
        codeTF.font = UIFont.sizeToFit(with: 15)
        codeTF.tintColor =  UIColor(hex: CustomKey.Color.mainColor)
        codeTF.returnKeyType = .done
        bgView.addSubview(codeTF)
        
        pooCodeView = PooCodeView(frame: CGRect(x: 585.0.fitWidth, y: 235.0.fitHeight, width: (140.0.fitWidth), height: 60.0.fitHeight))
        let changePooCodeTap = UITapGestureRecognizer()
        pooCodeView.addGestureRecognizer(changePooCodeTap)
        
        bgView.addSubview(pooCodeView)
        let line3 = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(codeLable.frame.origin.y + codeLable.frame.size.height), width: UIScreen.width, height: CGFloat(0.5)))
        line3.backgroundColor = UIColor(hex: 0xe6e6e6)
        bgView.addSubview(line3)
        
        let tipsLable = UILabel(frame: CGRect(x: 30.0.fitWidth, y: CGFloat(380.0.fitHeight), width: UIScreen.width - 30.0.fitWidth, height: 60.0.fitHeight))
        tipsLable.text = "关联后,您的\(session?.title ?? "")账号和哆集账号都可以登录"
        tipsLable.textColor = UIColor(hex: 0x222222)
        tipsLable.font = UIFont.sizeToFit(with: 13)
        view.addSubview(tipsLable)
        
        let loginBtn = UIButton(frame: CGRect(x: 24.0.fitWidth, y: CGFloat(tipsLable.frame.origin.y + tipsLable.frame.size.height + 42.0.fitHeight), width: UIScreen.width - 48.0.fitWidth, height: 90.0.fitHeight))
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.titleLabel?.font =  UIFont.sizeToFit(with:16)
        loginBtn.setTitle("确 定", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(loginBtn)
        
        let forgateBtn = UIButton(frame: CGRect(x: CGFloat(UIScreen.width - 180.0.fitWidth - 24.0.fitWidth), y: CGFloat(loginBtn.frame.origin.y + loginBtn.frame.size.height + 20.0.fitHeight), width: 180.0.fitWidth, height: 80.0.fitHeight))
        forgateBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        forgateBtn.titleLabel?.font =  UIFont.sizeToFit(with:13)
        forgateBtn.setTitle("忘记密码", for: .normal)
        view.addSubview(forgateBtn)
        changePooCode()
        
        let usernameValid = phoneNumTF.rx.text.orEmpty
            .map { $0.characters.count >= 11}
            .shareReplay(1)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 6 }
            .shareReplay(1)
        
        let pooCodeValid = codeTF.rx.text.orEmpty
            .map { $0.characters.count >= 4 }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid, pooCodeValid) { $0 && $1 && $2}
            .shareReplay(1)
        
        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 20 ? text: text.substring(to: "01234567890123456789".endIndex)
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
        
        codeTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 4 ? text: text.substring(to: "1560".endIndex)
            }
            .shareReplay(1)
            .bind(to: codeTF.rx.text)
            .disposed(by: disposeBag)
        
        forgateBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let findVC = FindPasswordVC()
                findVC.phoneNum = self?.phoneNumTF.text ?? ""
                findVC.popVC = self
                self?.navigationController?.pushViewController(findVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap.asObservable()
            .bind {
                self.view.endEditing(true)
                }
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let inputCode = self?.codeTF.text ?? "".lowercased()
                let code = (String.init(describing: self?.pooCodeView.changeString ?? "")).lowercased()
                if inputCode.caseInsensitiveCompare(code) != .orderedSame {
                    self?.view.makeToast("验证码有误，请重新输入验证码")
                    return
                }
                var requstSession: SessionHandleType?
                guard let handleSession = self?.session else {
                    return
                }
                switch handleSession {
                case .QQ(_, let param):
                    param.username = self?.phoneNumTF.text
                    param.password = self?.pwdTF.text?.md5()
                    param.code = inputCode
                    requstSession = .QQ(UserPath.thirdPartyBindQQ, param)
                case .weibo(_, let param):
                    param.username = self?.phoneNumTF.text
                    param.password = self?.pwdTF.text?.md5()
                    param.code = inputCode
                    requstSession = .weibo(UserPath.thirdPartyBindWeibo, param)
                case .wechat(_, let param):
                    param.username = self?.phoneNumTF.text
                    param.password = self?.pwdTF.text?.md5()
                    param.code = inputCode
                    requstSession = .weibo(UserPath.thirdPartyBindWechat, param)
                default:
                    return
                }
                if let session = requstSession {
                     HUD.show(true, show: "", enableUserActions: false, with: self)
                    self?.bindVM.register(sessionType: session)
                    .then(execute: { [weak self] isSuccess -> Void in
                        if isSuccess {
                            NotificationCenter.default.post(name: CustomKey.NotificationName.fastRegisterSuccess, object: nil, userInfo: ["phoneNum": session.param.username ?? ""])
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                    .always {
                             HUD.show(false, show: "", enableUserActions: false, with: self)
                        }
                    .catch(execute: { error  in
                            if let error = error as? AppError {
                                self?.view.makeToast(error.message)
                            }
                    })
                }
                
            })
            .disposed(by: disposeBag)
        
        changePooCodeTap.rx
            .event
            .subscribe(onNext: {  [weak self] _ in
                self?.changePooCode()
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func  changePooCode() {
        let requestParam = GetValidationCodeParam()
        guard let handleSession = session else {
                return
        }
        switch handleSession {
        case .QQ:
            requestParam.type = .qq
        case .weibo:
            requestParam.type = .weibo
        case .wechat:
            requestParam.type = .wechat
        default:
            return
        }
        requestParam.openId = session?.param.openId
        HUD.show(true, show: "", enableUserActions: false, with: self)
        let request: Promise<ValidationResponse> = RequestManager.request(.endpoint(CommonPath.getQQValidationCode, param: requestParam), needToken: .false)
        request.then { value -> Void in
            if let object = value.object, let code = object.code {
                self.pooCodeView.changeString = NSMutableString(string: code )
                self.pooCodeView.setNeedsDisplay()
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
   
}
