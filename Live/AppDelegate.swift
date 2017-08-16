//
//  AppDelegate.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import CoreData
import RxDataSources
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa
import CoreLocation
import DZNEmptyDataSet

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    fileprivate lazy var delegateHelper = DelegateHelper()
    fileprivate let disposebag: DisposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupUI()
        setupThirdPartySDK()
        configIQKeyBord()
        addNotification()
        chooseRootVC()
        locationHandle()
        setupIM()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.hasPrefix("tencent" + CustomKey.ThirdPartyKey.qqAppID + "://") {
            QQApiInterface.handleOpen(url, delegate: delegateHelper)
            return TencentOAuth.handleOpen(url)
        }
        if url.absoluteString.hasPrefix("wb" + CustomKey.ThirdPartyKey.sinaWeiboAppKey + "://") {
            return WeiboSDK.handleOpen(url, delegate: delegateHelper)
        }
        if url.absoluteString.hasPrefix(CustomKey.ThirdPartyKey.weChatAppID) {
            return WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        if url.absoluteString.hasPrefix("tencent" + CustomKey.ThirdPartyKey.qqAppID + "://") {
            QQApiInterface.handleOpen(url, delegate: delegateHelper)
            return TencentOAuth.handleOpen(url)
        }
        if url.absoluteString.hasPrefix("wb" + CustomKey.ThirdPartyKey.sinaWeiboAppKey + "://") {
            return WeiboSDK.handleOpen(url, delegate: delegateHelper)
        }
        if url.absoluteString.hasPrefix(CustomKey.ThirdPartyKey.weChatAppID) {
            return WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.saveContext()
    }
}

extension AppDelegate {
    
    fileprivate func chooseRootVC() {
      window = UIWindow(frame: UIScreen.main.bounds)
      var rootVC: UIViewController?
      if let token = UserSessionInfo.getSession().token, !token.isEmpty {
        if let isComplete = CoreDataManager.sharedInstance.getUserInfo()?.isComplete {
            rootVC = isComplete == false ? NavigationController(rootViewController: LoginViewController()):  TabBarController()
        } else {
             rootVC = NavigationController(rootViewController: LoginViewController())
        }
      } else {/// 没有token进行登录
          rootVC = NavigationController(rootViewController: LoginViewController())
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    fileprivate func addNotification() {
        NotificationCenter.default.rx
            .notification(CustomKey.NotificationName.loginInvalid)
            .subscribe(onNext: { _ in
                guard let view = self.window else { return }
                let rootVC = NavigationController(rootViewController: LoginViewController())
                UIView.transition(with: view, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.window?.rootViewController?.view.removeFromSuperview()
                }, completion: { (_) in
                    UIApplication.shared.keyWindow?.rootViewController = rootVC
                })

            })
            .disposed(by: disposebag)
        
    }
    
    fileprivate func configIQKeyBord() {
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enableAutoToolbar = false
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.shouldShowTextFieldPlaceholder = false
    }
    
    fileprivate func setupUI() {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(hex: CustomKey.Color.tabBackgroundColor)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor(hex: CustomKey.Color.mainColor)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        if let font = UIFont(name: "PingFangSC-Medium", size: 18) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSForegroundColorAttributeName: UIColor.white,
                 NSFontAttributeName: font]
        }
    }
    
    fileprivate func setupThirdPartySDK() {
        WXApi.registerApp(CustomKey.ThirdPartyKey.weChatAppID, withDescription: "wechat")
        let platforms = [
                         SSDKPlatformType.typeSinaWeibo.rawValue,
                         SSDKPlatformType.typeQQ.rawValue,
                         SSDKPlatformType.typeWechat.rawValue
                        ]
        
        ShareSDK.registerApp(CustomKey.ThirdPartyKey.shareSDKKey, activePlatforms: platforms, onImport: { platformType in
            switch platformType {
            case .typeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.self)
                break
            case .typeQQ:
                ShareSDKConnector.connectQQ(QQApiInterface.self, tencentOAuthClass: TencentOAuth.self)
                break
            case .typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.self)
                break
            default:
                break
            }
        }) { (platformType, appInfo) in
            switch platformType {
            case .typeSinaWeibo:
                appInfo?.ssdkSetupSinaWeibo(byAppKey: CustomKey.ThirdPartyKey.sinaWeiboAppKey, appSecret: CustomKey.ThirdPartyKey.sinaWeiboAppSecret, redirectUri: CustomKey.ThirdPartyKey.sinaWeiboRedirectURI, authType: SSDKAuthTypeBoth)
                break
            case .typeQQ:
                appInfo?.ssdkSetupQQ(byAppId: CustomKey.ThirdPartyKey.qqAppID, appKey: CustomKey.ThirdPartyKey.qqAppSecret, authType: SSDKAuthTypeBoth)
                break
            case .typeWechat:
                appInfo?.ssdkSetupWeChat(byAppId: CustomKey.ThirdPartyKey.weChatAppID, appSecret: CustomKey.ThirdPartyKey.weChatAppSecret)
                break
            default:
                break
            }
        }
    }
    
    fileprivate func locationHandle() {
        LocationViewModel.share.startLocate()
    }
    
    fileprivate func setupIM() {
        let imManager = TIMManager.sharedInstance()
        let config = TIMSdkConfig()
        config.sdkAppId = CustomKey.ThirdPartyKey.TIMSdkAppId
        config.accountType = CustomKey.ThirdPartyKey.TIMAccountType
        imManager?.initSdk(config)
    }
}

extension AppDelegate: WXApiDelegate {
    func onResp(_ resp: BaseResp!) {
        print("*************onResp************")
        if !resp.isKind(of: SendAuthResp.self) {
            return
        }
        if let response = resp as? SendAuthResp, let code = response.code {
            let dict = ["code": code]
            if response.errCode == 0 {
                NotificationCenter.default.post(name: CustomKey.NotificationName.wechatDidLoginNotification, object: nil, userInfo: dict)
            }
        }
    }
}
