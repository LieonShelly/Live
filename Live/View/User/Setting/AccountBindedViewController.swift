//
//  AccountBindedViewController.swift
//  Live
//
//  Created by fanfans on 2017/7/13.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift

class AccountBindedViewController: BaseViewController {
    var phoneNum: String?
    fileprivate lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "setting_binded_icon")
        return icon
    }()
    fileprivate lazy var tipsLable: UILabel = {
        let tipsLable = UILabel()
        tipsLable.text = "已绑定的手机号"
        tipsLable.font = UIFont.systemFont(ofSize: 13)
        tipsLable.textAlignment = .center
        tipsLable.textColor = UIColor(hex: 0x999999)
        return tipsLable
    }()
    fileprivate lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.text = "13800000000"
        phoneLabel.font = UIFont.systemFont(ofSize: 16)
        phoneLabel.textAlignment = .center
        phoneLabel.textColor = UIColor(hex: 0x222222)
        return phoneLabel
    }()
    fileprivate lazy var modifyBtn: UIButton = {
        let modifyBtn = UIButton()
        modifyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        modifyBtn.setTitle("更换手机号", for: .normal)
        modifyBtn.setTitleColor(UIColor.white, for: .normal)
        modifyBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        modifyBtn.layer.cornerRadius = 40 * 0.5
        modifyBtn.layer.masksToBounds = true
        return modifyBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "已绑定手机号"
        self.view.backgroundColor = UIColor.white
        phoneLabel.text = phoneNum ?? ""
         // MARK: congfigUI
        self.view.addSubview(icon)
        self.view.addSubview(tipsLable)
        self.view.addSubview(phoneLabel)
        self.view.addSubview(modifyBtn)
        
        // MARK: layout
        icon.snp.makeConstraints { (maker) in
            maker.top.equalTo(38)
            maker.width.equalTo(59)
            maker.height.equalTo(75)
            maker.centerX.equalTo(self.view.snp.centerX)
        }
        tipsLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(icon.snp.bottom) .offset(25)
            maker.centerX.equalTo(self.view.snp.centerX)
        }
        phoneLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipsLable.snp.bottom) .offset(15)
            maker.centerX.equalTo(self.view.snp.centerX)
        }
        modifyBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(phoneLabel.snp.bottom) .offset(30)
            maker.width.equalTo(300)
            maker.height.equalTo(40)
            maker.centerX.equalTo(self.view.snp.centerX)
        }
        // MARK: modifyBtnAction
        modifyBtn.rx.tap
            .subscribe(onNext: { [weak  self] in
                let vcc = VerifyPhoneViewController()
                guard let phoneNum = self?.phoneNum  else { return }
                vcc.phoneNum = phoneNum
                let accountVM = UserSessionViewModel()
                HUD.show(true, show: "", enableUserActions: false, with: self)
                accountVM.sendCaptcha(phoneNum: phoneNum, type: .changePhoneNum)
                    .then(execute: { (_) -> Void in
                        self?.navigationController?.pushViewController(vcc, animated: true)
                    })
                    .always {
                         HUD.show(false, show: "", enableUserActions: false, with: self)
                    }
                .catch(execute: { error in
                    if let error = error as? AppError {
                        self?.view.makeToast(error.message)
                    }
                })
            })
            .disposed(by: disposeBag)
    }
}
