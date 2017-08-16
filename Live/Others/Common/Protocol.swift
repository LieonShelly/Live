//
//  Protocol.swift
//  Live
//
//  Created by lieon on 2017/6/30.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

protocol EndPointProtocol {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var endpoint: String { get }
    
    func URL() -> String
}

extension EndPointProtocol {
    
    var baseURL: String {
//        return "http://192.168.50.97:8080/live-web"
        return (Bundle.main.infoDictionary?["BASE_URL"] as? String) ?? ""
    }
    
    func URL() -> String {
        return baseURL + path + endpoint
    }
    
}

protocol UserEndPointProtocol: EndPointProtocol { }

protocol ContentEndPointProtocol: EndPointProtocol { }

extension UserEndPointProtocol {
    var method: HTTPMethod {
        return .post
    }
}

extension ContentEndPointProtocol {
    var method: HTTPMethod {
        return .get
    }
}

protocol ViewNameReusable:class { }

extension ViewNameReusable where Self:UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

protocol ViewCotrollerProtocol {
    func addEndingAction()
    func setupNaigationBarDefaultStyle()
}

extension ViewCotrollerProtocol where Self: UIViewController {
    
    func addEndingAction() {
        let tapBackground = UITapGestureRecognizer()
        _ = tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
        view.addGestureRecognizer(tapBackground)
    }
    
    func setupNaigationBarDefaultStyle() {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: 0xffffff, alpha: 0.5)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }
    
}
