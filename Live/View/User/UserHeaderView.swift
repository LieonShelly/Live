//
//  UserHeaderView.swift
//  Live
//
//  Created by lieon on 2017/6/30.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class UserHeaderView: UIView {
    let iconTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let nameLabelTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let fansLabelTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let folowsLabelTap: UITapGestureRecognizer = UITapGestureRecognizer()
    
    fileprivate lazy  var insetView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xf1f1f1)
        return view
    }()
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy   var line1: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "placeholderImage_avatar")
        iconView.layer.cornerRadius = 120.fitWidth * 0.5
        iconView.layer.borderWidth = 2
        iconView.layer.masksToBounds = true
        iconView.layer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
        iconView.isUserInteractionEnabled = true
        return iconView
    }()
    fileprivate lazy var genderImgV: UIImageView = {
        let genderImgV = UIImageView()
        return genderImgV
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
         nameLabel.text = "登录/注册"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor(hex: 0x222222)
         nameLabel.isUserInteractionEnabled = true
        return nameLabel
    }()
    fileprivate lazy var vipTagView: UIImageView = {
        let vipTagView: UIImageView = UIImageView()
        vipTagView.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        vipTagView.contentMode = .scaleAspectFill
        vipTagView.layer.masksToBounds = true
        vipTagView.layer.cornerRadius = 16 * 0.5
        return vipTagView
    }()
    fileprivate lazy var vipLevelLable: UILabel = {
        let vipLevelLable: UILabel = UILabel()
        vipLevelLable.textAlignment = .center
        vipLevelLable.textColor = UIColor.white
        vipLevelLable.font = UIFont.systemFont(ofSize: 10)
        vipLevelLable.adjustsFontSizeToFitWidth = true
        return vipLevelLable
    }()
    fileprivate lazy var subTitleLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "多集主播ID:2323432423424"
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.gray
        return nameLabel

    }()
    fileprivate lazy var fansLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "粉丝 6"
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = UIColor(hex: 0x222222)
         nameLabel.isUserInteractionEnabled = true
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    fileprivate lazy var followLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "关注 6"
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .center
         nameLabel.isUserInteractionEnabled = true
        nameLabel.textColor = UIColor(hex: 0x222222)
        return nameLabel
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconView.addGestureRecognizer(iconTap)
        nameLabel.addGestureRecognizer(nameLabelTap)
        fansLabel.addGestureRecognizer(fansLabelTap)
        followLabel.addGestureRecognizer(folowsLabelTap)
        backgroundColor = .white
         addSubview(iconView)
         addSubview(genderImgV)
         addSubview(nameLabel)
         addSubview(vipTagView)
         vipTagView.addSubview(vipLevelLable)
         addSubview(subTitleLabel)
         addSubview(fansLabel)
         addSubview(followLabel)
         addSubview(line0)
         addSubview(line1)
         addSubview(insetView)
        
        iconView.snp.makeConstraints { maker in
            maker.left.equalTo(20)
            maker.top.equalTo(25)
            maker.width.equalTo(120.fitWidth)
            maker.height.equalTo(120.fitWidth)
        }
        genderImgV.snp.makeConstraints { maker in
            maker.left.equalTo(iconView.snp.left).offset(83.fitWidth)
            maker.top.equalTo(iconView.snp.top)
            maker.width.equalTo(15)
            maker.height.equalTo(15)
        }
        nameLabel.snp.makeConstraints { maker in
            maker.left.equalTo(iconView.snp.right).offset(15)
            maker.top.equalTo(25)
            maker.height.equalTo(30)
        }
        vipTagView.snp.makeConstraints { maker in
            maker.left.equalTo(nameLabel.snp.right).offset(10)
            maker.centerY.equalTo(nameLabel.snp.centerY)
            maker.width.equalTo(16)
            maker.height.equalTo(16)
        }
        vipLevelLable.snp.makeConstraints { maker in
            maker.left.equalTo(0)
            maker.top.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        subTitleLabel.snp.makeConstraints { maker in
            maker.left.equalTo(nameLabel.snp.left)
            maker.top.equalTo(nameLabel.snp.bottom).offset(0)
            maker.height.equalTo(30)
        }
        
        line0.snp.makeConstraints { maker in
            maker.left.equalTo(0)
            maker.top.equalTo(iconView.snp.bottom).offset(13)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
        fansLabel.snp.makeConstraints { maker in
            maker.left.equalTo(0)
            maker.top.equalTo(iconView.snp.bottom).offset(16)
            maker.width.equalTo((UIScreen.width) * 0.5)
            maker.height.equalTo(45)
        }
        
        followLabel.snp.makeConstraints { maker in
            maker.right.equalTo(0)
            maker.top.equalTo(fansLabel.snp.top).offset(0)
            maker.width.equalTo(UIScreen.width * 0.5)
            maker.height.equalTo(45)
        }
        
        insetView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(fansLabel.snp.bottom).offset(0)
            maker.right.equalTo(0)
            maker.height.equalTo(10)
        }
        
        line1.snp.makeConstraints { maker in
            maker.top.equalTo(line0.snp.bottom).offset(5)
            maker.bottom.equalTo(insetView.snp.top).offset(-5)
            maker.left.equalTo(fansLabel.snp.right)
            maker.width.equalTo(0.5)
        }
        
    }
    
    func config(user: UserInfo?) {
        guard let userInfo =  user else {
            return
        }
         let iconURL = CustomKey.URLKey.baseImageUrl + (userInfo.avatar ?? "")
        iconView.kf.setImage(with: URL(string: iconURL), placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = userInfo.nickName ?? "登录/注册"
        subTitleLabel.text = "多集主播ID: " + "\(userInfo.liveNo ?? "")"
        fansLabel.text = "粉丝 " + " \(userInfo.fans)"
        followLabel.text = "关注 " + " \(userInfo.follow)"
        switch userInfo.gender {
            case .unknown:
                genderImgV.isHidden = true
            case .male:
                genderImgV.isHidden = false
                genderImgV.image = UIImage(named: "gender_male")
            case .female:
                genderImgV.isHidden = false
                genderImgV.image = UIImage(named: "gender_female@3x")
        }
        if userInfo.level > 0 {
            vipLevelLable.isHidden = false
            vipLevelLable.text = "V" + "\(userInfo.level)"
        } else {
            vipLevelLable.isHidden = false
        }
    }
    
    func config(anchor: AnchorDetail) {
        let iconURL = CustomKey.URLKey.baseImageUrl + (anchor.avatar ?? "")
        iconView.kf.setImage(with: URL(string: iconURL), placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = anchor.nickName ?? "登录/注册"
        subTitleLabel.text = "哆集主播ID: " + "\(anchor.liveNo ?? "")"
        fansLabel.text = "粉丝 " + " \(anchor.fansCount)"
        followLabel.text = "关注 " + " \(anchor.followCount)"
        if anchor.level > 0 {
            vipLevelLable.isHidden = false
            vipLevelLable.text = "V" + "\(anchor.level)"
        } else {
            vipLevelLable.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
