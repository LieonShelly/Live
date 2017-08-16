//
//  WithdrawDepositAuthCodeCell.swift
//  Live
//
//  Created by fanfans on 2017/7/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WithdrawDepositAuthCodeCell: UITableViewCell, ViewNameReusable {
    var getverifiedCodeAction: ((Void) -> Void)?
    private let disposeBg: DisposeBag = DisposeBag()
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var inputTF: UITextField = {
        let inputTF = UITextField()
        inputTF.font = UIFont.systemFont(ofSize: 14)
        inputTF.textAlignment = .left
        inputTF.textColor = UIColor(hex: 0x222222)
        inputTF.placeholder = "请输入短信验证码"
        return inputTF
    }()
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    lazy var authCodeBtn: UIButton = {
        let authCodeBtn = UIButton()
        authCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        authCodeBtn.setTitle("获取验证码", for: .normal)
        authCodeBtn.setTitleColor(UIColor(hex: 0x222222), for: .normal)
        return authCodeBtn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(inputTF)
        bgView.addSubview(line0)
        bgView.addSubview(authCodeBtn)
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
        inputTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.width.equalTo(150)
        }
        line0.snp.makeConstraints { (maker) in
            maker.width.equalTo(0.5)
            maker.height.equalTo(17)
            maker.right.equalTo(-95)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        authCodeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.left.equalTo(line0.snp.right)
        }
        authCodeBtn.rx.tap
            .subscribe(onNext: { [weak  self] in
                self?.getverifiedCodeAction?()
            })
        .disposed(by: disposeBg)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
