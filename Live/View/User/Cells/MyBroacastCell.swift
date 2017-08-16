//
//  MyBroacastCell.swift
//  Live
//
//  Created by lieon on 2017/7/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyBroacastCell: UITableViewCell, ViewNameReusable {
    var shareAction: ((Void) -> Void)?
    var deleteAction: ((Void) -> Void)?
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "blow me"
        label.textColor = UIColor(hex: 0x222222)
        return label
    }()

    fileprivate lazy var viewerCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.text = "550 人观看"
        label.textColor = UIColor(hex: 0x999999)
        return label
    }()
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.text = "2017-09-09  16:00"
        label.textColor = UIColor(hex: 0x999999)
        return label
    }()
    fileprivate lazy var desclabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.text = "sdfsdfasdfsdf"
        label.textColor = UIColor(hex: 0x222222)
        return label
    }()
    fileprivate lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40 * 0.5
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "placeholderImage_avatar")
        imageView.sizeToFit()
        return imageView
    }()
    fileprivate lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = UIImage(named: "placeholderImage_702_420.jpg")
        return imageView
    }()
     lazy var shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
         imageView.contentMode = .center
        imageView.image = UIImage(named: "nav_black_share@3x")
        imageView.highlightedImage = UIImage(named: "nav_black_share@3x")
        imageView.sizeToFit()
        return imageView
    }()
     lazy var deleteImageView: UIImageView = {
        let imageView = UIImageView()
         imageView.isUserInteractionEnabled = true
        imageView.contentMode = .center
        imageView.image = UIImage(named: "delete@3x")
        imageView.highlightedImage = UIImage(named: "delete@3x")
        imageView.sizeToFit()
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(viewerCountLabel)
        bgView.addSubview(desclabel)
        bgView.addSubview(coverImageView)
        bgView.addSubview(shareImageView)
        bgView.addSubview(deleteImageView)
        bgView.addSubview(avatarImageView)
        bgView.addSubview(dateLabel)
        let shareTap: UITapGestureRecognizer = UITapGestureRecognizer()
        let deleteTap: UITapGestureRecognizer = UITapGestureRecognizer()
        shareImageView.addGestureRecognizer(shareTap)
        deleteImageView.addGestureRecognizer(deleteTap)
        
        shareTap.rx.event
            .subscribe(onNext: {[weak self] (_) in
                self?.shareAction?()
            })
            .disposed(by: disposeBag)
        
        deleteTap.rx.event
            .subscribe(onNext: { [weak self] (_) in
                 self?.deleteAction?()
            })
            .disposed(by: self.disposeBag)
        
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(0)
            maker.top.equalTo(12)
        }
        
        avatarImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(12)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(avatarImageView.snp.right).offset(12)
            maker.top.equalTo(avatarImageView.snp.top).offset(5)
            maker.right.equalTo(-75)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.right.equalTo(-75)
            maker.top.equalTo(nameLabel.snp.bottom).offset(3)
        }

        viewerCountLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.top.equalTo(15)
        }

        coverImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(avatarImageView.snp.bottom).offset(12)
            maker.height.equalTo(175)
        }

        desclabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(-100)
            maker.top.equalTo(coverImageView.snp.bottom).offset(12)
            
        }

        deleteImageView.snp.makeConstraints { (maker) in
            maker.right.equalTo(-20)
            maker.centerY.equalTo(desclabel.snp.centerY)
            maker.width.equalTo(45)
             maker.height.equalTo(30)
        }

        shareImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(deleteImageView.snp.centerY)
            maker.right.equalTo(deleteImageView.snp.left).offset(-12)
            maker.width.equalTo(45)
            maker.height.equalTo(30)
        }
    }
    
    func config(_ model: LiveListModel, isDetailVC: Bool = false) {
        let iconURL = CustomKey.URLKey.baseImageUrl + (model.avatar ?? "")
        avatarImageView.kf.setImage(with: URL(string: iconURL), placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = model.userName
        viewerCountLabel.text = "\(model.seeCount)" + "人观看"
        let coverURL = CustomKey.URLKey.baseImageUrl + (model.cover ?? "")
        coverImageView.kf.setImage(with: URL(string: coverURL), placeholder: UIImage(named: "placeholderImage_702_420.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        desclabel.text = model.name ?? ""
        dateLabel.text = String.dateStrFormTimeInterval(with: "\(model.startTime)", format: "MM-dd HH:mm")
        if isDetailVC {
            deleteImageView.isHidden = true
            shareImageView.snp.remakeConstraints { (maker) in
                maker.centerY.equalTo(deleteImageView.snp.centerY)
                maker.right.equalTo(-20)
                maker.width.equalTo(45)
                maker.height.equalTo(30)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
