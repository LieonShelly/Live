//
//  EarningsController.swift
//  Live
//
//  Created by fanfans on 2017/7/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class EarningsController: BaseViewController {
    fileprivate lazy var imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "earnings_icon")
        return imgV
    }()
    fileprivate lazy var tipsLable: UILabel = {
        let tipsLable = UILabel()
        tipsLable.text = "我的哆豆"
        tipsLable.font = UIFont.systemFont(ofSize: 14)
        tipsLable.textAlignment = .center
        tipsLable.textColor = UIColor(hex: 0x222222)
        return tipsLable
    }()
    fileprivate lazy var countLable: UILabel = {
        let countLable = UILabel()
        countLable.text = "\(CoreDataManager.sharedInstance.getUserInfo()?.point ?? 0)"
        countLable.font = UIFont.systemFont(ofSize: 40)
        countLable.textAlignment = .center
        countLable.textColor = UIColor(hex: CustomKey.Color.mainColor)
        return countLable
    }()
    fileprivate lazy var sureBtn: UIButton = {
        let sureBtn: UIButton = UIButton()
        sureBtn.layer.cornerRadius = 40 * 0.5
        sureBtn.layer.masksToBounds = true
        sureBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sureBtn.setTitle("确认提现", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.addTarget(self, action: #selector(self.sureTapAction), for: .touchUpInside)
        return sureBtn
    }()
    
    fileprivate lazy var historyBtn: UIButton = {
        let historyBtn = UIButton()
        historyBtn.frame = CGRect(x:UIScreen.width - 60, y: 20, width: 60, height: 44)
        historyBtn.setTitle("提现记录", for: .normal)
        historyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        historyBtn.setTitleColor(UIColor.white, for: .normal)
        historyBtn.addTarget(self, action: #selector(self.historyTapAction), for: .touchUpInside)
        return historyBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0xfafafa)
        self.title = "收益"
        
        let rightBtnItem = UIBarButtonItem(customView: historyBtn)
        navigationItem.rightBarButtonItem = rightBtnItem
        
        self.view.addSubview(imgV)
        self.view.addSubview(tipsLable)
        self.view.addSubview(countLable)
        self.view.addSubview(sureBtn)
        
        imgV.snp.makeConstraints { (maker) in
            maker.top.equalTo(50)
            maker.width.equalTo(76)
            maker.height.equalTo(76)
            maker.centerX.equalTo(self.view.snp.centerX)
        }
        tipsLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(imgV.snp.bottom).offset(26)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
        countLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipsLable.snp.bottom).offset(20)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
        sureBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(300)
            maker.height.equalTo(40)
            maker.centerX.equalTo(self.view.snp.centerX)
            maker.top.equalTo(countLable.snp.bottom).offset(38)
        }
    }
    
    // MARK: btnAction
    @objc fileprivate  func sureTapAction() {
        self.navigationController?.pushViewController(WithdrawDepositToAliPayController(), animated: true)
    }
    
    @objc fileprivate  func historyTapAction() {
        self.navigationController?.pushViewController(WithdrawDepositHistoryController(), animated: true)
    }
}
