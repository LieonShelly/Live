//
//  RequestManager.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import Alamofire
import ObjectMapper
import PromiseKit
import RxSwift
import RxCocoa

public enum NeedToken {
    case `true`
    case `false`
    case `default`
}
class RequestManager {
    /// 封装为请求对象的方法 链式回调
    /*
     调用方式:
     // 0.请求参数和返回的模型全都继承自Model这个类
     // 1. 指定返回的数据类型 Promise<NullDataResponse>
     // 2. 指定router，包括请求路径，参数，请求方式
     // 3. 在then中获取请求结果
     // 4. cathch中获取错误信息
       备注： PromiseKit的具体调用方式可以参照github
     let req: Promise<NullDataResponse> = RequestManager.request(.endpoint(CollectionPath.disFollow, param: param), needToken: .true)
     let valid = req.then { value -> Bool in
                return value.result == .success ? true: false
        }
     */
    static func request<T: Mappable>(_ router: Router, needToken: NeedToken = .true) -> Promise<T> {
        return Promise { fulfill, reject in
            var urlRequest = router.urlRequest
            var header = Header().toJSON()
            if case .false = needToken {
                header.removeValue(forKey: "token")
            }
            if case .default = needToken {
                header.removeValue(forKey: "token")
            }
            header.forEach { (key, value) in
                if let string = value as? String {
                    urlRequest?.setValue(string, forHTTPHeaderField: key)
                }
            }
            
            let requst = Alamofire.request(urlRequest!)
            let body = try? JSONSerialization.jsonObject(with: (requst.request?.httpBody) ?? Data(), options: JSONSerialization.ReadingOptions.allowFragments)
            print("******Header*******\(requst.request?.allHTTPHeaderFields ?? [:])")
            print("******RequestURL*******\(urlRequest!.url?.absoluteString ?? "")")
            print("******Method*******\(urlRequest!.httpMethod ?? "")")
            print("******Body*******\(body ?? [: ])")
            
            requst
                .validate()
                .responseJSON(completionHandler: { response in
            switch response.result {
            case .success( let value):
                var appError = AppError()
                if let responseJson = value as? [String: Any] {
                    print("******Response: \(responseJson)*******")
                    if let responseObj = Mapper<BaseResponseObject<T>>().map(JSON: responseJson) {
                        if responseObj.result == .success {
                            if let obj = Mapper<T>().map(JSON: responseJson) {
                                 fulfill(obj)
                            } else {
                                appError.message = "Data Parase Error"
                                reject(appError)
                            }
                        }
                        if responseObj.result == .fail {
                            appError.message = responseObj.errorMsg ?? "response failed"
                            appError.erroCode = responseObj.errorCode
                            reject(appError)
                            if responseObj.errorCode == .loginInValid { /// 通知重新登录
                                  print("*******Login Invalid*******")
                                NotificationCenter.default.post(name: CustomKey.NotificationName.loginInvalid, object: nil)
                            }
                        }
                    }
                }
                
            case .failure(let error):
                reject(error)
            }
        })
    }
    }
    
    /// 最原始的请求方法   闭包回调
    /*
     let phoneNum = "15608066219"
     let pwd = "123456"
     let param: [String: Any] = [
                                "username": phoneNum,
                                "password": pwd
                                ]
     let baseURLStr = "http://test.hlhdj.cn/live-web/"
     RequestManager.request(baseURLStr: baseURLStr,
                            path: "user/login",
                            param: param,
                            method: .post,
                            success: { (json) in
     
        }) { (appError) in
     
     }
     */
    static func request(baseURLStr: String,
                        path: String,
                        param: [String: Any]?,
                        method: HTTPMethod,
                        needToken: NeedToken = .true,
                        success: @escaping (([String: Any]) -> Void),
                        failure: @escaping ((AppError) -> Void)) {
        let fullURLStr = baseURLStr + path
        let url = URL(string: fullURLStr)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        var header = Header().toJSON()
        if case .false = needToken {
            header.removeValue(forKey: "token")
        }
        if case .default = needToken {
            header.removeValue(forKey: "token")
        }
        header.forEach { (key, value) in
            if let string = value as? String {
                urlRequest.setValue(string, forHTTPHeaderField: key)
            }
        }
        if method == .post {
            urlRequest = try! JSONEncoding.default.encode(urlRequest, with: param).urlRequest!
        }
        let request = Alamofire.request(urlRequest)
        print("******Header*******\(urlRequest.allHTTPHeaderFields ?? [:])")
        print("******RequestURL*******\(urlRequest.url?.absoluteString ?? "")")
        print("******Method*******\(urlRequest.httpMethod ?? "")")
        print("******Body*******\(param ?? [: ])")
        request
            .validate()
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success( let value):
                    if let responseJson = value as? [String: Any], let result = responseJson["result"] as? String {
                        print("******Response: \(responseJson)*******")
                        if result == "ok" {
                             success(responseJson)
                        } else if result == "fail" {
                            if let  errorCode = responseJson["errorCode"] as? String, errorCode == "1001" { // 登录失效
                                print("*******Login Invalid*******")
                                NotificationCenter.default.post(name: CustomKey.NotificationName.loginInvalid, object: nil)
                                return
                            }
                            var appError = AppError()
                            appError.message = responseJson["errorMsg"] as? String ?? ""
                            failure(appError)
                        }
                    }
                    
                case .failure(let error):
                    var appError = AppError()
                    appError.message = "响应失败:\(error.localizedDescription)"
                    failure(appError)
                }
            })
        
    }
}
