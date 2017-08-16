//
//  WithdrawDepositSucceedController.swift
//  Live
//
//  Created by fanfans on 2017/7/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class WithdrawDepositSucceedController: BaseViewController {
    fileprivate lazy var imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "cash_out_succeed")
        return imgV
    }()
    fileprivate lazy var tipsLable: UILabel = {
        let tipsLable = UILabel()
        tipsLable.text = "请关注您的支付宝入账，1-2天内到账"
        tipsLable.font = UIFont.systemFont(ofSize: 13)
        tipsLable.textAlignment = .center
        tipsLable.textColor = UIColor(hex: 0x999999)
        return tipsLable
    }()
    fileprivate lazy var sureBtn: UIButton = {
        let sureBtn: UIButton = UIButton()
        sureBtn.layer.cornerRadius = 40 * 0.5
        sureBtn.layer.masksToBounds = true
        sureBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.addTarget(self, action: #selector(self.sureTapAction), for: .touchUpInside)
        return sureBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0xfafafa)
        self.title = "提现到支付宝"
        
        self.view.addSubview(imgV)
        self.view.addSubview(tipsLable)
        self.view.addSubview(sureBtn)
        
        imgV.snp.makeConstraints { (maker) in
            maker.top.equalTo(37)
            maker.width.equalTo(60)
            maker.height.equalTo(75)
            maker.centerX.equalTo(self.view.snp.centerX)
        }
        tipsLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(imgV.snp.bottom).offset(26)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
        sureBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(300)
            maker.height.equalTo(40)
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.top.equalTo(tipsLable.snp.bottom).offset(37)
        }
    }
    
    @objc fileprivate  func sureTapAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
