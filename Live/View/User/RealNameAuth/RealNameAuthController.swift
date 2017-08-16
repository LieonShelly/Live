//
//  RealNameAuthController.swift
//  Live
//
//  Created by fanfans on 2017/7/5.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class RealNameAuthController: BaseViewController {
    var certifiURL: String?
    fileprivate lazy var headerImgV: UIImageView = {
        let headerImgV: UIImageView = UIImageView()
        headerImgV.image = UIImage(named: "auth_succeed")
        headerImgV.contentMode = .scaleAspectFill
        return headerImgV
    }()
    fileprivate lazy var tipsLable: UILabel = {
        let tipsLable: UILabel = UILabel()
        tipsLable.text = "为了您的账户安全，请先完成\n实名认证哦~"
        tipsLable.textAlignment = .center
        tipsLable.textColor = UIColor(hex: 0x999999)
        tipsLable.numberOfLines = 2
        tipsLable.font = UIFont.systemFont(ofSize: 13)
        return tipsLable
    }()
    fileprivate lazy var alipayAuthBtn: UIButton = {
        let alipayAuthBtn: UIButton = UIButton()
        alipayAuthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        alipayAuthBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        alipayAuthBtn.setTitleColor(UIColor.white, for: .normal)
        alipayAuthBtn.setTitle("支付宝一键认证", for: .normal)
        alipayAuthBtn.layer.cornerRadius = 40 * 0.5
        alipayAuthBtn.layer.masksToBounds = true
        alipayAuthBtn.addTarget(self, action: #selector(self.aliPayAuthAction), for: .touchUpInside)
        return alipayAuthBtn
    }()
    fileprivate lazy var otherAuthBtn: UIButton = {
        let otherAuthBtn: UIButton = UIButton()
        otherAuthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        otherAuthBtn.backgroundColor = UIColor.white
        otherAuthBtn.setTitleColor(UIColor(hex: 0x999999), for: .normal)
        otherAuthBtn.setTitle("其他认证方式", for: .normal)
        otherAuthBtn.addTarget(self, action: #selector(self.otherAuthAction), for: .touchUpInside)
        return otherAuthBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实名认证"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(headerImgV)
        self.view.addSubview(tipsLable)
        self.view.addSubview(alipayAuthBtn)
        self.view.addSubview(otherAuthBtn)
        headerImgV.snp.makeConstraints { (maker) in
            maker.top.equalTo(37)
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.width.equalTo(75)
            maker.height.equalTo(75)
        }
        tipsLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerImgV.snp.bottom).offset(30)
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.width.equalTo(175)
        }
        alipayAuthBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipsLable.snp.bottom).offset(30)
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.width.equalTo(300)
            maker.height.equalTo(40)
        }
        otherAuthBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(alipayAuthBtn.snp.bottom).offset(5)
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.width.equalTo(300)
            maker.height.equalTo(40)
        }
        
        let userVM = UserInfoManagerViewModel()
        let param = IDVlidateRequestParam()
        param.trueName = "李仁军"
        param.idCardNumber = "511602199203167298"
        userVM.requestZhimaValid(with: param)
        .then { (response) -> Void in
            if  let obj = response.object, let certifyURL = obj.certifyURL {
                self.certifiURL = certifyURL
            }
        }
        .catch { _ in
            
        }
    }
    
    @objc fileprivate func aliPayAuthAction() {
        print("aliPayAuthAction")
        doVerify(with: "https://openapi.alipaydev.com/gateway.do?alipay_sdk=alipay-sdk-java-dynamicVersionNo&app_id=2016072900120157&biz_content=%7B%22biz_no%22%3A%2243cfae3f174c1564cf92a466548c6914%22%7D&charset=utf-8&format=json&method=zhima.customer.certification.certify&return_url=http%3A%2F%2Ftest.hlhdj.cn%2Flive-web%2Fapi%2FapproveReturn&sign=EmykuR6IeOZUoH5iNx5KrrRJzqEQmAIeyr%2FySIK1sQ9Zyx1lgCPXGPuoNTScNtuG9Z4BB248%2FxJ%2FJOCInqzYR6bC1eWBdefEqLFYzNTJL%2FKuXYm9cvrfeglrU%2BCirqC2cBL24xjSGFgtfXxljcWMRCuUxZwF%2Bsy7e0AHfWfjgTl0kKcdgiSdFqXAkrsG27BQu7TyKDaCiPqydJ8lm5b8BUcwkdL2RgbJkYXVd1XlHdwppo5j8E11QHkfcIT0FP%2Bp2oVAiM7zNnRgB3KQes8X7cJ%2BFB2xcPt3lRvrOZJhRQ5Jm8P%2BEoN7n6hxDoBWc769jXFwzzArmMKjPhk%2B70jBWg%3D%3D&sign_type=RSA2&timestamp=2017-08-03+13%3A38%3A22&version=1.0&sign=EmykuR6IeOZUoH5iNx5KrrRJzqEQmAIeyr%2FySIK1sQ9Zyx1lgCPXGPuoNTScNtuG9Z4BB248%2FxJ%2FJOCInqzYR6bC1eWBdefEqLFYzNTJL%2FKuXYm9cvrfeglrU%2BCirqC2cBL24xjSGFgtfXxljcWMRCuUxZwF%2Bsy7e0AHfWfjgTl0kKcdgiSdFqXAkrsG27BQu7TyKDaCiPqydJ8lm5b8BUcwkdL2RgbJkYXVd1XlHdwppo5j8E11QHkfcIT0FP%2Bp2oVAiM7zNnRgB3KQes8X7cJ%2BFB2xcPt3lRvrOZJhRQ5Jm8P%2BEoN7n6hxDoBWc769jXFwzzArmMKjPhk%2B70jBWg%3D%3D")
    }
    
    private func doVerify(with url: String) {
        if let encodeStr = url.urlEncoded(), let alipayURL = URL(string: "alipays://platformapi/startapp?appId=\(CustomKey.ThirdPartyKey.alipayAppID)&url=\(encodeStr)") {
             UIApplication.shared.openURL(alipayURL)
        }
        
    }
    
    @objc fileprivate func otherAuthAction() {
        let vc = RealInfoCommitController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
