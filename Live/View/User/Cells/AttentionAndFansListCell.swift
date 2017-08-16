//
//  AttentionAndFansListCell.swift
//  Live
//
//  Created by fanfans on 2017/7/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AttentionAndFansListCell: UITableViewCell, ViewNameReusable {
    var attentAction: ((Void) -> Void)?
    fileprivate let disposeBag = DisposeBag()
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var avatar: UIImageView = {
        let avatar: UIImageView = UIImageView()
        avatar.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 37 * 0.5
        avatar.layer.masksToBounds = true
        return avatar
    }()
    fileprivate lazy var nameLable: UILabel = {
        let nameLable: UILabel = UILabel()
        nameLable.textAlignment = .left
        nameLable.textColor = UIColor(hex: 0x222222)
        nameLable.text = "苏小白老司机"
        nameLable.font = UIFont.systemFont(ofSize: 14)
        return nameLable
    }()
    fileprivate lazy var subNameLable: UILabel = {
        let subNameLable: UILabel = UILabel()
        subNameLable.textAlignment = .left
        subNameLable.textColor = UIColor(hex: 0x999999)
        subNameLable.text = "109.2万粉丝"
        subNameLable.font = UIFont.systemFont(ofSize: 11)
        return subNameLable
    }()
    fileprivate lazy var vipTagView: UIImageView = {
        let vipTagView: UIImageView = UIImageView()
        vipTagView.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        vipTagView.contentMode = .scaleAspectFill
        vipTagView.layer.masksToBounds = true
        vipTagView.layer.cornerRadius = 15 * 0.5
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
    lazy var attentionBtn: UIButton = {
        let attentionBtn: UIButton = UIButton()
        attentionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        attentionBtn.setTitle("关注", for: .normal)
        attentionBtn.setTitle("已关注", for: .selected)
        attentionBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .normal)
        attentionBtn.setTitleColor(UIColor(hex: 0x999999), for: .selected)
        attentionBtn.layer.cornerRadius = 25 * 0.5
        attentionBtn.layer.masksToBounds = true
        attentionBtn.layer.borderWidth = 1
        return attentionBtn
    }()
    fileprivate lazy var line: UIView = {
        let line: UIView = UIView()
        line.backgroundColor = UIColor(hex: 0xe5e5e5)
        return line
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(avatar)
        bgView.addSubview(nameLable)
        bgView.addSubview(subNameLable)
        bgView.addSubview(vipTagView)
        vipTagView.addSubview(vipLevelLable)
        bgView.addSubview(attentionBtn)
        bgView.addSubview(line)
        
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        avatar.snp.makeConstraints { (maker) in
            maker.top.equalTo(10)
            maker.left.equalTo(12)
            maker.width.equalTo(37)
            maker.height.equalTo(37)
        }
        nameLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(avatar.snp.top)
            maker.left.equalTo(avatar.snp.right).offset(12)
        }
        subNameLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLable.snp.left)
            maker.top.equalTo(nameLable.snp.bottom).offset(5)
        }
        vipTagView.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLable.snp.right).offset(15)
            maker.centerY.equalTo(nameLable.snp.centerY)
            maker.width.equalTo(15)
            maker.height.equalTo(15)
        }
        vipLevelLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        attentionBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(bgView.snp.centerY)
            maker.width.equalTo(60)
            maker.height.equalTo(25)
            maker.right.equalTo(-12)
        }
        line.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLable.snp.left)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(0)
            maker.right.equalTo(0)
        }
        
        attentionBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                print("***********btn********")
                self?.attentAction?()
            })
         .disposed(by: disposeBag)
    }
    
    func config(_ model: UserModel) {
         let urlStr = CustomKey.URLKey.baseImageUrl + (model.avatar ?? "")
        if let avatarURL = URL(string: urlStr) {
            avatar.kf.setImage(with: avatarURL, placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        nameLable.text = model.nickName ?? ""
        subNameLable.text = "\(model.fansCount)" + "粉丝"
        attentionBtn.isSelected = model.isFollowed
        if model.isFollowed {
            attentionBtn.layer.borderColor = UIColor(hex: 0x999999).cgColor
        } else {
            attentionBtn.layer.borderColor = UIColor(hex: CustomKey.Color.mainColor).cgColor
        }
        if model.level > 0 {
            vipLevelLable.isHidden = false
            vipLevelLable.text = "V" + "\(model.level)"
        } else {
            vipLevelLable.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
