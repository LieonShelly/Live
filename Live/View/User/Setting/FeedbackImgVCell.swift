//
//  FeedbackImgVCell.swift
//  Live
//
//  Created by fanfans on 2017/7/5.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class FeedbackImgVCell: UICollectionViewCell, ViewNameReusable {
    
    var removeBtnAction: (() -> Void)?
    
    fileprivate lazy var bgView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var cover: UIImageView = {
        let cover: UIImageView = UIImageView()
        cover.contentMode = .scaleAspectFill
        cover.layer.masksToBounds = true
        cover.isUserInteractionEnabled = true
        return cover
    }()
    lazy var removeBtn: UIButton = {
        let removeBtn: UIButton = UIButton()
        removeBtn.setImage(UIImage(named: "pulic_pic_deleted"), for: .normal)
        removeBtn.imageView?.contentMode = .scaleAspectFill
        removeBtn.addTarget(self, action: #selector(self.removeTapAction), for: .touchUpInside)
        return removeBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgView)
        bgView.addSubview(cover)
        cover.addSubview(removeBtn)
        
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
            maker.bottom.equalTo(0)
        }
        removeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.right.equalTo(0)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
    }
    
    @objc fileprivate  func removeTapAction() {
        removeBtnAction?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
