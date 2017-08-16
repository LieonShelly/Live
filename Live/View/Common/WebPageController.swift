//
//  WebPageController.swift
//  Live
//
//  Created by lieon on 2017/6/26.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit
import WebKit

class WebPageController: BaseViewController {
   fileprivate lazy var webView: WKWebView = {
     let webView =  WKWebView(frame: CGRect(x: CGFloat(0), y: CGFloat(44), width: CGFloat(UIScreen.width), height: CGFloat(UIScreen.height - 44)))
        return webView
    }()
    fileprivate  lazy var progressView: UIProgressView = UIProgressView()
    var urlStr: String = ""
    var navTitle: String = ""
    var request: URLRequest?
    var isShowRight: Bool = false
    var isInviteUser: Bool = false
    //nav
    fileprivate  lazy var navView: UIView = UIView()
    fileprivate  lazy var titleLable: UILabel = UILabel()
    fileprivate  lazy var leftBtn: UIButton = UIButton()
    fileprivate  lazy var leftCloseBtn: UIButton = UIButton()
    fileprivate  lazy var rightBtn: UIButton = UIButton()
    fileprivate  lazy  var line: UIView = UIView()
    fileprivate  lazy  var shareMarkView: UIView = UIView()
//    var shareView: ShareView?
    var requestCount: Int = 0
    var backNavigation: WKNavigation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .old, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .init(rawValue: 0), context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        webView.navigationDelegate = nil
        webView.uiDelegate = nil
    }

    convenience init(urlStr url: String, navTitle navTilte: String, isShowRightBtn: Bool = false) {
        self.init()
        self.urlStr = url
        self.navTitle = navTilte
        self.isShowRight = isShowRightBtn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = navTitle
        requestCount = 0
        webView = WKWebView(frame: CGRect(x: CGFloat(0), y: CGFloat(64), width: CGFloat(UIScreen.width), height: CGFloat(UIScreen.height - 64)))
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.isScrollEnabled = true
        request = URLRequest(url: URL(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        webView.load(request!)
        webView.scrollView.alwaysBounceVertical = true
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        view.addSubview(webView)
        progressView.frame = CGRect(x: CGFloat(0), y: CGFloat(64), width: CGFloat(view.frame.width), height: CGFloat(2))
        progressView.trackTintColor = UIColor(hex: 0xf7f7f7)
        progressView.progressTintColor = UIColor(hex: CustomKey.Color.mainColor)
        progressView.progressViewStyle = .default
        view.addSubview(progressView)
        configNav()
    }
    
    func configNav() {
        navView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.width), height: CGFloat(64))
        navView.backgroundColor = .black
        view.addSubview(navView)
        leftBtn = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(20), width: CGFloat(44), height: CGFloat(44)))
        leftBtn.setImage(UIImage(named: "new_nav_arrow_white"), for: .normal)
        leftBtn.addTarget(self, action: #selector(self.leftItemHandle), for: .touchUpInside)
        leftBtn.contentMode = .center
        navView.addSubview(leftBtn)
        leftCloseBtn.frame = CGRect(x: CGFloat(44), y: CGFloat(20), width: CGFloat(44), height: CGFloat(44))
        leftCloseBtn.setImage(UIImage(named: "web_nav_close"), for: .normal)
        leftCloseBtn.addTarget(self, action: #selector(self.close_coupons), for: .touchUpInside)
        leftCloseBtn.contentMode = .center
        leftCloseBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        leftCloseBtn.isHidden = true
        navView.addSubview(leftCloseBtn)
        titleLable.frame =  CGRect(x: CGFloat(88), y: CGFloat(20), width: CGFloat(UIScreen.width - 176), height: CGFloat(44))
        titleLable.textAlignment = .center
        titleLable.textColor = UIColor.white
        titleLable.font = UIFont(name: "Helvetica-Bold", size: CGFloat(17))
        navView.addSubview(titleLable)
        
        rightBtn.frame = CGRect(x: CGFloat(UIScreen.width - 44), y: CGFloat(20), width: CGFloat(44), height: CGFloat(44))
        rightBtn.setImage(UIImage(named: "nav_black_share"), for: .normal)
        rightBtn.addTarget(self, action: #selector(self.rightItemHandle), for: .touchUpInside)
        rightBtn.contentMode = .center
        rightBtn.isHidden = !isShowRight
        navView.addSubview(rightBtn)
        let line = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(63.5), width: CGFloat(UIScreen.width), height: CGFloat(0.5)))
        line.backgroundColor = UIColor(hex: 0xbababa)
        navView.addSubview(line)

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {() -> Void in
                    self.progressView.alpha = 0.0
                }, completion: {(_ finished: Bool) -> Void in
                   self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
        if keyPath == "title" {
            self.titleLable.text = webView.title
        }
    }

    func leftItemHandle() {
        if webView.canGoBack {
            webView.goBack()
//            webView.scrollView.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat(-40)), animated: true)
        } else {
            leftCloseBtn.isHidden = true
            navigationController?.popViewController(animated: true)
        }
    }
    
    func close_coupons() {
        navigationController?.popViewController(animated: true)
    }

    func rightItemHandle() {
    }
}

extension WebPageController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let url: URL? = webView.url
        print("url.absoluteString : \(url?.absoluteString ?? "")")
        if (url?.absoluteString.hasPrefix("https://cn.hlhdj.duoji/product/"))! {
            //单品详情
            let str: String? = url?.absoluteString.replacingOccurrences(of: "https://cn.hlhdj.duoji/product/", with: "")
            print(str ?? "")
            /*var singleItemVC = SingleProductNewController(productId: str)
            singleItemVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(singleItemVC, animated: true) */
            return
        }
        if (url?.absoluteString.hasPrefix("https://cn.hlhdj.duoji/activity/new-user-invite"))! {
            isInviteUser = true
            rightItemHandle()
            return
        }
        self.requestCount += 1
        if self.requestCount > 1 {
            self.leftCloseBtn.isEnabled = false
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation) {
    }

}
