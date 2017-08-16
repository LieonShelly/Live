//
//  BasePlayerVC.swift
//  Live
//
//  Created by lieon on 2017/7/7.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class BasePlayerVC: BaseViewController {
     lazy var txLivePlayer: TXLivePlayer = TXLivePlayer()
    
     lazy var avatarImgeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholderImage_avatar")
        return imageView
    }()
     lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
     lazy  var svcontainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
     lazy  var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
     }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    lazy var viplevLabel: UILabel = {
        let viplevLabel = UILabel()
        viplevLabel.font = UIFont.systemFont(ofSize: 11)
        viplevLabel.textAlignment = .center
        viplevLabel.textColor = UIColor.white
        viplevLabel.layer.masksToBounds = true
        viplevLabel.layer.cornerRadius = 8
        return viplevLabel
    }()
    
     lazy var collectionBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "guanzhu_normal"), for: .normal)
        btn.setImage(UIImage(named: "details_iscollect_btn"), for: .selected)
        return btn
    }()
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .center
        btn.setImage(UIImage(named: "common_close@3x"), for: .normal)
        btn.setImage(UIImage(named: "common_close@3x"), for: .highlighted)
        return btn
    }()
    
     lazy var IDlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.text = "1231231233"
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var seecountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    lazy var  viewerView: ViewerView = ViewerView()
    lazy var coverImageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllContainerView()
        setupUserTagView()
        setupPlayer()
        setupViewerView()
        setupIDView()
        setupCover()
    }
}

extension BasePlayerVC {
    fileprivate func setupAllContainerView() {
        svcontainerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        scrollView.contentSize = CGSize(width: view.bounds.width * 2, height: 0)
        scrollView.contentOffset = CGPoint(x: view.bounds.width, y: 0)
        view.addSubview( svcontainerView)
        svcontainerView.addSubview(scrollView)
        containerView.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        scrollView.addSubview(containerView)
    }
    
    fileprivate func setupUserTagView() {
        //room_header_bgView@3x
        let bgView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 80))
        bgView.image = UIImage(named: "room_header_bgView")
        bgView.isUserInteractionEnabled = true
        containerView.addSubview(bgView)
        
        let view = UIView()//底层的透明
        view.backgroundColor = UIColor(hex: 0x605c56, alpha: 0.5)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        containerView.addSubview(view)
        view.addSubview(avatarImgeView)
        view.addSubview(seecountLabel)
        
        avatarImgeView.layer.cornerRadius = 17
        avatarImgeView.layer.masksToBounds = true
        view.addSubview(nameLabel)
        view.addSubview(collectionBtn)
        
        view.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(35)
            maker.width.equalTo(150)
            maker.height.equalTo(40)
        }
        
        avatarImgeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(2)
            maker.centerY.equalTo(view.snp.centerY)
            maker.width.equalTo(34)
            maker.height.equalTo(34)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(avatarImgeView.snp.right).offset(4)
            maker.top.equalTo(5)
            maker.width.equalTo(50)
        }
        view.addSubview(viplevLabel)
        viplevLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.bottom.equalTo(-2)
            maker.height.equalTo(16)
            maker.width.equalTo(32)
        }
        seecountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(viplevLabel.snp.right).offset(12)
            maker.bottom.equalTo(-2)
            maker.height.equalTo(16)
        }
        collectionBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-10)
            maker.centerY.equalTo(avatarImgeView.snp.centerY)
            maker.size.equalTo(CGSize(width: 16, height: 16))
        }
    }
    
    fileprivate func setupPlayer() {
        txLivePlayer.enableHWAcceleration = true
        txLivePlayer.setupVideoWidget(svcontainerView.bounds, contain: svcontainerView, insert: 0)
    }
    
    fileprivate func setupViewerView() {
        viewerView.backgroundColor = .clear
        containerView.addSubview(viewerView)
        viewerView.snp.makeConstraints { (maker) in
            maker.right.equalTo(-45)
            maker.top.equalTo(35)
            maker.height.equalTo(40)
            maker.width.equalTo(34 * 4)
        }
        
        containerView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.centerY.equalTo(viewerView.snp.centerY)
            maker.width.equalTo(45)
            maker.height.equalTo(30)
        }
        
    }
    
    fileprivate func setupIDView() {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        containerView.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.top.equalTo(35 + 40 + 5)
            maker.width.equalTo(145)
            maker.height.equalTo(18)
        }
        view.addSubview(IDlabel)
        IDlabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(view.snp.right).offset(-5)
            maker.centerY.equalTo(view.snp.centerY)
        }
        
        let beanLabel = UILabel()
        beanLabel.text = "哆集直播ID: "
        beanLabel.textColor = UIColor.white
        beanLabel.font = UIFont.systemFont(ofSize: 11)
        view.addSubview(beanLabel)
        beanLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(IDlabel.snp.left).offset(5)
            maker.centerY.equalTo(view.snp.centerY)
        }
        
        let cover = UILabel()
        cover.backgroundColor = UIColor(hex: 0x605c56, alpha: 0.5)
        cover.layer.cornerRadius = 9
        cover.layer.masksToBounds = true
        view.insertSubview(cover, at: 0)
        cover.snp.makeConstraints { (maker) in
            maker.left.equalTo(beanLabel.snp.left).offset(-5)
            maker.top.equalTo(view.snp.top)
            maker.bottom.equalTo(view.snp.bottom)
            maker.right.equalTo(IDlabel.snp.right).offset(5)
        }
    }
    
    fileprivate func setupCover() {
        coverImageView.backgroundColor = .red
        coverImageView.frame = containerView.bounds
        view.insertSubview(coverImageView, at: 0)
    }
    
}
