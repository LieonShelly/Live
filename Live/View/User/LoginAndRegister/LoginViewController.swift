//
//  LoginViewController.swift
//  Live
//
//  Created by lieon on 2017/6/22.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import PromiseKit

class LoginViewController: BaseViewController, ViewCotrollerProtocol {
    // MARK: Lazy
   fileprivate var QQParam: UserRequestParam = UserRequestParam()
   fileprivate  var tentcentAuth: TencentOAuth?
   fileprivate var thirdPartyParam: UserRequestParam?
   fileprivate  var tencentOAuth: TencentOAuth?
   fileprivate lazy var loginVM: UserSessionViewModel = UserSessionViewModel()
   fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入用户名"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
//        textField.text = "15608066219"
        return textField
    }()
   fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入您的登录密码"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
//        pwdTF.text = "123456"
        return pwdTF
    }()
   fileprivate lazy  var userLog: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_account"))
        imageView.contentMode = .center
        return imageView
    }()
   fileprivate lazy   var pwdLog: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_pwd"))
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
   fileprivate lazy   var forgetPwdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        forgetPwdBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        forgetPwdBtn.setTitle("忘记密码", for: .normal)
        forgetPwdBtn.setTitleColor(UIColor(hex: 0x999999), for: .normal)
        return forgetPwdBtn
    }()
   fileprivate lazy  var fastloginBtn: UIButton = {
        let fastloginBtn = UIButton()
        fastloginBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        fastloginBtn.setTitle("手机快速登录", for: .normal)
        fastloginBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        fastloginBtn.sizeToFit()
        return fastloginBtn
    }()
   fileprivate lazy  var fastlRegisterBtn: UIButton = {
        let fastlRegisterBtn = UIButton()
        fastlRegisterBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        fastlRegisterBtn.setTitle("手机快速注册", for: .normal)
        fastlRegisterBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        fastlRegisterBtn.sizeToFit()
        return fastlRegisterBtn
    }()
   fileprivate lazy  var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("登 录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        loginBtn.isEnabled = false
         return loginBtn
    }()
   fileprivate lazy  var qqLoginBtn: UIButton = {
        let qqLoginBtn = UIButton()
        qqLoginBtn.setBackgroundImage(UIImage(named: "login_qq"), for: .normal)
        qqLoginBtn.sizeToFit()
        return qqLoginBtn
    }()
   fileprivate lazy  var sinaLoginBtn: UIButton = {
        let sinaLoginBtn = UIButton()
        sinaLoginBtn.setBackgroundImage(UIImage(named: "login_sina"), for: .normal)
        sinaLoginBtn.sizeToFit()
        return sinaLoginBtn
    }()
   fileprivate lazy  var wechatLoginBtn: UIButton = {
        let wechatLoginBtn = UIButton()
        wechatLoginBtn.setBackgroundImage(UIImage(named: "login_wechat"), for: .normal)
        wechatLoginBtn.sizeToFit()
         return wechatLoginBtn
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupThirdPartAction()
        addEndingAction()
        setupAction()
        print("**********viewDidLoad**********")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.weiboDidLogin(notification:)), name: CustomKey.NotificationName.weiboDidLoginNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.fastRegisterVCHandle(notification:)), name: CustomKey.NotificationName.fastRegisterSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getWechatUserInfo(note:)), name: CustomKey.NotificationName.wechatDidLoginNotification, object: nil)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

}

    // MARK: Inner Method
extension LoginViewController {
    fileprivate func setupUI() {
       navigationItem.title = "登录"
         view.backgroundColor = .white
        view.addSubview(userLog)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdLog)
        view.addSubview(pwdTF)
        view.addSubview(line1)
        view.addSubview(forgetPwdBtn)
        view.addSubview(line2)
        view.addSubview(fastloginBtn)
        view.addSubview(fastlRegisterBtn)
        view.addSubview(loginBtn)
        view.addSubview(sinaLoginBtn)
        view.addSubview(wechatLoginBtn)
        view.addSubview(qqLoginBtn)
        userLog.snp.makeConstraints { (maker) in
            maker.top.equalTo(73)
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
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-35)
            maker.centerY.equalTo(pwdLog.snp.centerY)
            maker.height.equalTo(40)
        }
        line1.snp.makeConstraints { (maker) in
            maker.right.equalTo(forgetPwdBtn.snp.left).offset(-12)
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
        
        fastlRegisterBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(userLog.snp.left)
            maker.top.equalTo(line2.snp.bottom).offset(15)
        }
        fastloginBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(line2.snp.right)
            maker.top.equalTo(fastlRegisterBtn.snp.top)
        }
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(fastlRegisterBtn.snp.bottom).offset(50)
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(40)
        }
        let inset: CGFloat = (view.bounds.width - 3 * qqLoginBtn.bounds.size.width) * 0.25
        
        if UIApplication.shared.canOpenURL(URL(string: "weixin://")!) {
            qqLoginBtn.snp.makeConstraints({ (maker) in
                maker.left.equalTo(inset)
                maker.bottom.equalTo(-35)
            })
            wechatLoginBtn.snp.makeConstraints({ (maker) in
                maker.centerY.equalTo(qqLoginBtn.snp.centerY)
                maker.left.equalTo(qqLoginBtn.snp.right).offset(inset)
            })
            sinaLoginBtn.snp.makeConstraints({ (maker) in
                maker.centerY.equalTo(qqLoginBtn.snp.centerY)
                maker.left.equalTo(wechatLoginBtn.snp.right).offset(inset)
            })
            wechatLoginBtn.isHidden = false
        } else {
            wechatLoginBtn.isHidden = true
            qqLoginBtn.snp.makeConstraints({ (maker) in
                maker.left.equalTo(inset)
                maker.bottom.equalTo(-35)
            })
            sinaLoginBtn.snp.makeConstraints({ (maker) in
                maker.centerY.equalTo(qqLoginBtn.snp.centerY)
                maker.left.equalTo(qqLoginBtn.snp.right).offset(inset)
            })
        }
       
    }
    
    fileprivate func setupAction() {
        
        let usernameValid = phoneNumTF.rx.text.orEmpty
            .map { $0.characters.count >= 11}
            .shareReplay(2)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 6 }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
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
        
        fastlRegisterBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let registerVC = FastRegisterViewController()
                if let phoneNUm =  self?.phoneNumTF.text, !phoneNUm.isEmpty {
                    let param = UserRequestParam()
                    param.username = phoneNUm
                    let newSession = SessionHandleType.normal(.register, param)
                    registerVC.session = newSession
                }
                self?.navigationController?.pushViewController(registerVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap.asObservable().bind {
               self.view.endEditing(true)
            }.disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
               let param = UserRequestParam()
                param.username = self?.phoneNumTF.text
                param.password = self?.pwdTF.text?.md5()
                HUD.show(true, show: "", enableUserActions: false, with: self)
                self?.loginVM.login(sessionType: .normal(UserPath.login, param))
                .then(execute: { isLogin -> Void in
                    if isLogin {
                        isToInfoVC(self)
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
 
        forgetPwdBtn.rx.tap
           .subscribe(onNext: { [weak self] in
              let finfVC = FindPasswordVC()
               if let phoneNUm =  self?.phoneNumTF.text {
                finfVC.phoneNum  = phoneNUm
               }
             self?.navigationController?.pushViewController(finfVC, animated: true)
          })
            .disposed(by: disposeBag)
        
        fastloginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let loginVC = FastLoginVC()
                if let phoneNUm =  self?.phoneNumTF.text {
                    loginVC.phoneNum  = phoneNUm
                }
                self?.navigationController?.pushViewController(loginVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupThirdPartAction() {
        tentcentAuth = TencentOAuth(appId: CustomKey.ThirdPartyKey.qqAppID, andDelegate: self)
        
        qqLoginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
                self?.tentcentAuth?.authorize(permissions, inSafari: true)
            })
            .disposed(by: disposeBag)
        
        sinaLoginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.sinaAction()
            })
            .disposed(by: disposeBag)
        
        wechatLoginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.wechatAction()
            })
            .disposed(by: disposeBag)
    }
  
    fileprivate func thirdPartyLogin(_ type: SessionHandleType) {
        HUD.show(true, show: "", enableUserActions: false, with: self)
        loginVM.login(sessionType: type)
            .then(execute: { isNewUser -> Void in
                print(isNewUser)
                if isNewUser {//如果是第一次登录,将会跳转到第三方登录页面进行，注册，或者绑定
                    self.pushToThirdPartyVC(with: type)
                } else {
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
    
    fileprivate func pushToThirdPartyVC(with type: SessionHandleType) {
        let vcc = ThirdPartyLoginVC()
        switch type {
        case .QQ:
            tentcentAuth?.getUserInfo()
        default:
            vcc.session = type
            navigationController?.pushViewController(vcc, animated: true)
        }
    }
}

// MARK: Wechat
extension LoginViewController {
    
   fileprivate func wechatAction() {
    if UIApplication.shared.canOpenURL(URL(string: "weixin://")!) {
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.openID = CustomKey.ThirdPartyKey.weChatAppID
            req.state = "Live"
           WXApi.send(req)
    } else {
        HUD.showAlert(from: self, title: "温馨提示", enterTitle: "确定", mesaage: "您还未下载安装微信,不能使用微信登录", success: {  })
        }
    }
    
    @objc fileprivate func getWechatUserInfo(note: Notification) {
        guard let code = note.userInfo?["code"] as? String else { return }
        print("************getWechatUserInfo**************")
        let wechatParam: UserRequestParam = UserRequestParam()
        requestWechatAccesRelated(with: code)
        .then { acctokenDict -> Promise<Bool> in
            print(acctokenDict)
            guard  let accessToken =  acctokenDict["access_token"] as? String, let openid = acctokenDict["openid"] as? String, let unionid = acctokenDict["unionid"] as? String else {
                var error = AppError()
                error.message = "微信数据获取失败，您可以再试一下"
                return Promise<Bool>(error: error)
            }
            print("*******unionId:\(unionid)*********accessToken:\(accessToken)*********openid:\(openid)")
            wechatParam.accessToken = accessToken
             wechatParam.openId = openid
             wechatParam.unionId = unionid
            return self.loginVM.login(sessionType: .wechat(.thirdPartyLoginWechat, wechatParam))
        }
       .then { (isNewUser) -> Promise<[String: Any]> in
            if isNewUser {
               return self.requestWechatUserInfo(accessToken: wechatParam.accessToken ?? "", openId:  wechatParam.openId ?? "")
            } else {
                return Promise<[String: Any]>(value: [String: Any]())
            }
         }
        .then { (info) -> Void in
            if !info.keys.isEmpty {
                print("*********info:\((info))*********")
                let thirdVC = ThirdPartyLoginVC()
                 wechatParam.thirdPartyInfo = info
                let session = SessionHandleType.wechat(.register, wechatParam)
                thirdVC.session = session
                self.navigationController?.pushViewController(thirdVC, animated: true)
            } else {
                isToInfoVC(self)
            }
        }
        .catch { error in
            if let error = error as? AppError {
                self.view.makeToast(error.message)
            }
        }
    }
    
    //// 获取微信的acckoten，openID，unionid
    private func requestWechatAccesRelated(with code: String) -> Promise<[String: Any]> {
        return Promise {fullfil, reject in
            let urlstr: String = String(format: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", CustomKey.ThirdPartyKey.weChatAppID, CustomKey.ThirdPartyKey.weChatAppSecret, code)
            Alamofire.request(urlstr, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        if let dict = value as? [String: Any], !dict.keys.isEmpty {
                            fullfil(dict)
                        } else {
                            var error = AppError()
                            error.message = "微信数据获取失败，您可以再试一下"
                            reject(error)
                        }
                    case .failure(_):
                        var error = AppError()
                        error.message = "微信数据获取失败，您可以再试一下"
                        reject(error)
                    }
                    
            }

        }
    }
    
    /// 根据微信的acckoten，openID 获取userInfo
    private func requestWechatUserInfo(accessToken: String, openId: String) -> Promise<[String: Any]> {
        return Promise {fullfil, reject in
            Alamofire.request(String(format: "https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken, openId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let infoValue):
                        if let info = infoValue as? [String: Any], !info.keys.isEmpty {
                            fullfil(info)
                        } else {
                            var error = AppError()
                            error.message = "微信数据获取失败，您可以再试一下"
                            reject(error)
                        }
                    case .failure(_):
                        var error = AppError()
                        error.message = "微信数据获取失败，您可以再试一下"
                         reject(error)
                    }
                })
        }
    }
}

// MARK: Sina
extension LoginViewController {
    fileprivate func sinaAction() {
        ShareSDK.authorize(.typeSinaWeibo, settings: [SSDKAuthSettingKeyScopes: ["follow_app_official_microblog"]]) { (state, user, error) in
            print(error.debugDescription)
            if state == .success {
                let param = UserRequestParam()
                param.accessToken = user?.credential.token
                param.openId = user?.uid
                let info =  self.getWeiboUserInfo(param)
                param.thirdPartyInfo = info
                self.thirdPartyLogin(SessionHandleType.weibo(.thirdPartyLoginSina, param))
            }
            print(error.debugDescription)
        }
        
    }
    
    fileprivate func getWeiboUserInfo(_ param: UserRequestParam) -> [String: Any] {
        if  let token = param.accessToken, let uid = param.openId {
            let urlstr: String = "https://api.weibo.com/2/users/show.json?access_token=" + token + "&uid=" + uid
            if let zoneURL = URL(string: urlstr), let zonestr = try? String(contentsOf: zoneURL, encoding: .utf8), let data = zonestr.data(using: .utf8), let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                return dic ?? [:]
            }
        }
        return [:]
    }
    
    @objc  fileprivate func weiboDidLogin(notification: Notification) {
        if let userInfo = notification.userInfo, let accessToken = userInfo["accessToken"] as? String,
            let uid = userInfo["userId"] as? String {
            let param = UserRequestParam()
            param.accessToken = accessToken
            param.openId = uid
            let info = getWeiboUserInfo(param)
            param.thirdPartyInfo = info
            thirdPartyLogin(.weibo(.thirdPartyLoginSina, param))
        }
    }
}

// MARK: QQ
extension LoginViewController: TencentSessionDelegate {
    func tencentDidLogin() {
        if let token = tentcentAuth?.accessToken, let openID = tentcentAuth?.openId {
            QQParam.accessToken = token
            QQParam.openId = openID
            self.thirdPartyLogin(.QQ(.thirdPartyLoginQQ, QQParam))

        }
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func tencentNeedPerformIncrAuth(_ tencentOAuth: TencentOAuth!, withPermissions permissions: [Any]!) -> Bool {
        tencentOAuth.incrAuth(withPermissions: permissions)
        return false
    }

    func getUserInfoResponse(_ response: APIResponse!) {
        if let dic = response.jsonResponse as? [String: Any], !dic.isEmpty {
            print(dic)
             QQParam.thirdPartyInfo = dic
            let vcc = ThirdPartyLoginVC()
            vcc.session = .QQ(.thirdPartyLoginQQ, QQParam)
            navigationController?.pushViewController(vcc, animated: true)
        } else {
            view.makeToast("获取QQ消息失败,您可以再试一下")
        }
    }
}

extension LoginViewController {
    @objc fileprivate func fastRegisterVCHandle(notification: NSNotification) {
        if let userInfo = notification.userInfo, let phoneNum = userInfo["phoneNum"] as? String {
            phoneNumTF.text = phoneNum
             phoneNumTF.becomeFirstResponder()
            pwdTF.text = ""
        }
    }
}

// MARK: Pubilc Method
func  isToInfoVC(_ VCC: UIViewController?) {
        let userInfoVM = UserInfoManagerViewModel()
        userInfoVM.requstUserInfo().then(execute: {[weak VCC] response -> Void in
            // 判断是否完善资料
            if userInfoVM.userInfo?.isComplete == false {
                VCC?.navigationController?.pushViewController(UserInfoManagerController(), animated: true)
            } else {
                let rootVC = TabBarController()
                UIView.transition(with: VCC!.view, duration: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    VCC?.view.removeFromSuperview()
                    UIApplication.shared.keyWindow?.addSubview(rootVC.view)
                }, completion: { (_) in
                    UIApplication.shared.keyWindow?.rootViewController = rootVC
                })
                
            }
        })
            .catch(execute: { error in
                if let error = error as? AppError {
                    VCC?.view.makeToast(error.message)
                }
            })
}
