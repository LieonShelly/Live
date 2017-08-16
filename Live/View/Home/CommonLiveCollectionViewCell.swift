//
//  CommonLiveCollectionViewCell.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import Kingfisher

class CommonLiveCollectionViewCell: UICollectionViewCell, ViewNameReusable {
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    
  lazy var cover: UIImageView = {
        let cover: UIImageView = UIImageView()
        cover.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        cover.contentMode = .scaleAspectFill
        cover.layer.masksToBounds = true
        return cover
    }()
    fileprivate lazy var liveStatusView: CollectionLiveTagView = {
        let liveStatusView: CollectionLiveTagView = CollectionLiveTagView(frame: CGRect(x: self.bounds.width - 50-12, y: 8, width: 50, height: 15))
        return liveStatusView
    }()
    fileprivate lazy var locationLable: UILabel = {
        let locationLable: UILabel = UILabel()
        locationLable.text = "1.6km"
        locationLable.textAlignment = .right
        locationLable.textColor = UIColor.white
        locationLable.font = UIFont.systemFont(ofSize: 11)
        return locationLable
    }()
    fileprivate lazy var locationImgV: UIImageView = {
        let locationImgV: UIImageView = UIImageView()
        locationImgV.image = UIImage(named: "live_location_image")
        return locationImgV
    }()
    fileprivate lazy var userName: UILabel = {
        let userName: UILabel = UILabel()
        userName.text = "香香大美眉也是小公举"
        userName.textAlignment = .left
        userName.textColor = UIColor(hex: 0x222222)
        userName.font = UIFont.systemFont(ofSize: 12)
        return userName
    }()
    fileprivate lazy var vipTag: UIImageView = {
        let vipTag: UIImageView = UIImageView()
        vipTag.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        vipTag.layer.masksToBounds = true
        vipTag.layer.cornerRadius = 19 * 0.5
        return vipTag
    }()
    fileprivate lazy var vipLevelLable: UILabel = {
        let vipLevelLable: UILabel = UILabel()
        vipLevelLable.textAlignment = .center
        vipLevelLable.textColor = UIColor.white
        vipLevelLable.font = UIFont.systemFont(ofSize: 10)
        vipLevelLable.adjustsFontSizeToFitWidth = true
        return vipLevelLable
    }()
    fileprivate lazy var lookPerson: UILabel = {
        let lookPerson: UILabel = UILabel()
        lookPerson.text = "33.8万人"
        lookPerson.textAlignment = .right
        lookPerson.textColor = UIColor(hex: 0x222222)
        lookPerson.font = UIFont.systemFont(ofSize: 12)
        return lookPerson
    }()
    
    fileprivate lazy var topicLabel: UILabel = {
        let userName: UILabel = UILabel()
        userName.text = "香香大美眉也是小公举"
        userName.textAlignment = .left
        userName.textColor = UIColor.lightGray
        userName.font = UIFont.systemFont(ofSize: 11)
        return userName
    }()
    
    func configCellWirthLiveListModel(item: LiveListModel, rowType: OrderType = .byNew) {
        liveStatusView.configWithListLiveType(type: item.type)
        userName.text = item.userName ?? ""
        if item.seeingCount > 10000 {
            lookPerson.text = "\(Float(item.seeingCount) / 10000.0) 万人"
        } else {
             lookPerson.text = "\(item.seeingCount) 人"
        }
        if rowType == .byNew || rowType == .byHot {
            locationLable.text = item.city ?? ""
        } else {
            if item.distance > 1000 {
                locationLable.text = "\(Float(Float(item.distance) / 1000.0))" + "km"
            } else {
                locationLable.text = "\(item.distance)" + "m"
            }
        }
        let baseImageUrl = (Bundle.main.infoDictionary?["BASE_IMAGE_URL"] as? String) ?? ""
        let coverStr = item.cover ?? ""
        if let url = URL(string: baseImageUrl + coverStr) {
            let img  = UIImage.placeholderImage(with: CGSize(width: UIScreen.width, height: 190))
            cover.kf.setImage(with: url, placeholder:img, options:  [.transition(ImageTransition.fade(1)), .targetCache(ImageCache(name: "Home"))], progressBlock: nil, completionHandler: nil)
        }
        if item.level > 0 {
            vipLevelLable.isHidden = false
            vipLevelLable.text = "V" + "\(item.level)"
        } else {
            vipLevelLable.isHidden = false
        }
        topicLabel.text = item.name ?? ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgView)
        bgView.addSubview(cover)
        cover.addSubview(liveStatusView)
        cover.addSubview(locationLable)
        cover.addSubview(locationImgV)
        bgView.addSubview(userName)
        bgView.addSubview(vipTag)
        vipTag.addSubview(vipLevelLable)
        bgView.addSubview(lookPerson)
        bgView.addSubview(topicLabel)
        let locationBg = UIImageView(image: UIImage(named: "mengchen"))
        cover.insertSubview(locationBg, at: 0)
        locationBg.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(locationLable.snp.top).offset(-5)
            maker.left.equalTo(locationImgV.snp.left).offset(-10)
        }
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        cover.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(-50)
        }
        locationLable.snp.makeConstraints { (maker) in
            maker.right.equalTo(-10)
            maker.bottom.equalTo(-5)
        }
        locationImgV.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(locationLable.snp.centerY)
            maker.left.equalTo(locationLable.snp.left).offset(-10)
        }
        userName.snp.makeConstraints { (maker) in
            maker.left.equalTo(11)
            maker.top.equalTo(cover.snp.bottom).offset(10)
            maker.width.lessThanOrEqualTo(80)
        }

        topicLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(userName.snp.left)
            maker.right.equalTo(0)
            maker.top.equalTo(userName.snp.bottom)
            maker.bottom.equalTo(-5)
        }
        
        vipTag.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(userName.snp.centerY)
            maker.left.equalTo(userName.snp.right).offset(15)
            maker.width.equalTo(19)
            maker.height.equalTo(19)
        }
        vipLevelLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        lookPerson.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(userName.snp.centerY)
            maker.right.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
