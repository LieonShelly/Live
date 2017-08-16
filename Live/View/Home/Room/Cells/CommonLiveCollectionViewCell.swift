//
//  CommonLiveCollectionViewCell.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class CommonLiveCollectionViewCell: UICollectionViewCell, ViewNameReusable {
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var cover: UIImageView = {
        let cover: UIImageView = UIImageView()
        cover.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        cover.contentMode = .scaleAspectFill
        cover.layer.masksToBounds = true
        return cover
    }()
    fileprivate lazy var liveStatusView: CollectionLiveTagView = {
        let liveStatusView: CollectionLiveTagView = CollectionLiveTagView(frame: CGRect(x: self.bounds.size.width - 55, y: 8, width: 50, height: 15))
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
        return vipTag
    }()
    fileprivate lazy var lookPerson: UILabel = {
        let lookPerson: UILabel = UILabel()
        lookPerson.text = "33.8万人"
        lookPerson.textAlignment = .right
        lookPerson.textColor = UIColor(hex: 0x222222)
        lookPerson.font = UIFont.systemFont(ofSize: 12)
        return lookPerson
    }()
    
    func configCellWirthLiveListModel(item: LiveListModel) {
        liveStatusView.configWithListLiveType(type: item.type)
        userName.text = item.name
        lookPerson.text = "33.8万人"
        let baseImageUrl = (Bundle.main.infoDictionary?["BASE_IMAGE_URL"] as? String) ?? ""
        let coverStr = item.cover ?? ""
        if let url = URL(string: baseImageUrl + coverStr) {
            print("rulStr:\(url.absoluteString)")
            cover.kf.setImage(with: url, placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        }
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
        bgView.addSubview(lookPerson)
        
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
            maker.bottom.equalTo(-37)
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
            maker.top.equalTo(cover.snp.bottom)
            maker.width.equalTo(80)
            maker.bottom.equalTo(0)
        }
        vipTag.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(userName.snp.centerY)
            maker.left.equalTo(userName.snp.right).offset(10)
            maker.width.equalTo(19)
            maker.height.equalTo(19)
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
