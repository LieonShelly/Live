//
//  ThirdPartyLoginVC.swift
//  Live
//
//  Created by lieon on 2017/6/28.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import Kingfisher

class ThirdPartyLoginVC: BaseViewController, ViewCotrollerProtocol {
    var session: SessionHandleType?
   fileprivate lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.image = UIImage(named: "placeholderImage_avatar")
        avatar.layer.cornerRadius = 200.0.fitHeight * 0.5
        avatar.layer.masksToBounds = true
        return avatar
    }()
   fileprivate lazy var nameTipLabel: UILabel = {
        let nameTipLabel = UILabel()
        nameTipLabel.textColor = UIColor(hex: 0x808080)
        nameTipLabel.textAlignment = .left
        nameTipLabel.font = UIFont.sizeToFit(with: 13)
        return nameTipLabel
    }()
   fileprivate lazy var nameLable: UILabel = {
       let nameLable = UILabel()
        nameLable.textColor = UIColor(hex: 0x222222)
        nameLable.textAlignment = .left
        nameLable.font = UIFont.sizeToFit(with: 13)
        return nameLable
    }()
   fileprivate lazy var tipsLable: UILabel = {
        let tipsLable = UILabel()
        tipsLable.text = "为了给您更方便的服务，请你关联一个哆集账号"
        tipsLable.textColor = UIColor(hex: 0x222222)
        tipsLable.font = UIFont.sizeToFit(with: 13)
        tipsLable.textAlignment = .left
        return tipsLable
    }()
   fileprivate lazy var noAccountLable: UILabel = {
        let noAccountLable = UILabel()
        noAccountLable.text = "还没有哆集账号?"
        noAccountLable.textColor = UIColor(hex: 0x808080)
        noAccountLable.font = UIFont.sizeToFit(with: 13)
        noAccountLable.textAlignment = .left
        return noAccountLable
    }()
   fileprivate lazy var registerBtn: UIButton = {
        let registerBtn = UIButton()
        registerBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        registerBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        registerBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        registerBtn.setTitle("立即注册", for: .normal)
        registerBtn.setTitleColor(UIColor.white, for: .normal)
        return registerBtn
    }()
   fileprivate lazy var bindingLabel: UILabel = {
        let bindingLabel = UILabel()
        bindingLabel.text = "已有哆集账号?"
        bindingLabel.textColor = UIColor(hex: 0x808080)
        bindingLabel.font = UIFont.sizeToFit(with: 14)
        bindingLabel.textAlignment = .left
        return bindingLabel
    }()
   fileprivate lazy var bindingBtn: UIButton = {
        let bindingBtn = UIButton()
        bindingBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        bindingBtn.backgroundColor = UIColor.white
        bindingBtn.layer.borderColor = UIColor(hex: 0xcccccc).cgColor
        bindingBtn.layer.cornerRadius = 3
        bindingBtn.layer.borderWidth = 1
        bindingBtn.setTitle("立即关联", for: .normal)
        bindingBtn.setTitleColor(UIColor(hex: 0x808080), for: .normal)
        return bindingBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        addEndingAction()
    }

}

extension ThirdPartyLoginVC {
    fileprivate func setupUI() {
        title = "第三方登录"
        view.backgroundColor = .white
        view.addSubview(avatar)
        view.addSubview(nameTipLabel)
        view.addSubview(nameLable)
        view.addSubview(tipsLable)
        view.addSubview(noAccountLable)
        view.addSubview(registerBtn)
        view.addSubview(bindingLabel)
        view.addSubview(bindingBtn)
        
        avatar.snp.makeConstraints { (maker) in
            maker.top.equalTo(88.0.fitHeight)
            maker.width.equalTo(200.0.fitHeight)
            maker.height.equalTo(200.0.fitHeight)
            maker.centerX.equalTo(view.snp.centerX)
        }
        
        nameTipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(36.0.fitWidth)
            maker.top.equalTo(avatar.snp.bottom).offset(60.0.fitHeight)
        }

        nameLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTipLabel.snp.right).offset(2)
            maker.top.equalTo(nameTipLabel.snp.top)
        }
        
        tipsLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTipLabel.snp.left)
            maker.top.equalTo(nameLable.snp.bottom).offset(10)
        }

        noAccountLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTipLabel.snp.left)
            maker.top.equalTo(tipsLable.snp.bottom).offset(60.0.fitHeight)
        }
        
        registerBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(24.0.fitWidth)
            maker.right.equalTo(-24.0.fitWidth)
            maker.top.equalTo(noAccountLable.snp.bottom).offset(5)
            maker.height.equalTo(90.0.fitHeight)
        }

        bindingLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameTipLabel.snp.left)
            maker.top.equalTo(registerBtn.snp.bottom).offset(90.0.fitHeight)
        }
        
        bindingBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(24.0.fitWidth)
            maker.right.equalTo(-24.0.fitWidth)
            maker.top.equalTo(bindingLabel.snp.bottom).offset(5)
            maker.height.equalTo(90.0.fitHeight)
        }
        
        var nikiname = ""
        var avatarURL = ""
        if let seesion = session {
            nameTipLabel.text = "亲爱的" + seesion.title + "用户"
            switch seesion {
            case .QQ(_, let param):
                avatarURL = param.thirdPartyInfo?["figureurl_qq_2"] as? String  ?? ""
                nikiname = param.thirdPartyInfo?["nickname"] as? String ?? ""
                break
            case .wechat(_, let param):
                avatarURL = param.thirdPartyInfo?["headimgurl"] as? String  ?? ""
                nikiname = param.thirdPartyInfo?["nickname"] as? String ?? ""
                break
            case .weibo(_, let param):
                avatarURL = param.thirdPartyInfo?["profile_image_url"] as? String  ?? ""
                nikiname = param.thirdPartyInfo?["name"] as? String ?? ""
                break
            default:
                break
            }
        }
        if let url = URL(string: avatarURL) {
            avatar.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        nameLable.text = nikiname
    }
    
    fileprivate func setupAction() {
        registerBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let regisetrVC = FastRegisterViewController()
                if let seesion = self?.session {
                    switch seesion {
                    case .QQ(_, let param):
                         regisetrVC.session = .QQ(UserPath.thirdPartyRegiseterQQ, param)
                    case .wechat(_, let param):
                        regisetrVC.session = .wechat(UserPath.thirdPartyBindWechat, param)
                    case .weibo(_, let param):
                        regisetrVC.session = .weibo(UserPath.thirdPartyBindWeibo, param)
                    default:
                        break
                    }
                }
                self?.navigationController?.pushViewController(regisetrVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        bindingBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let bindVC = ThirdpartyBindingController()
                bindVC.session = self?.session
                self?.navigationController?.pushViewController(bindVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
