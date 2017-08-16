//
//  FinishBroadcastVC.swift
//  Live
//
//  Created by lieon on 2017/7/10.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FinishBroadcastVC: BaseViewController {
    var live: EndLiveModel?
    fileprivate lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "placeholderImage_avatar")
        iconView.layer.cornerRadius = 120.fitWidth * 0.5
        iconView.layer.masksToBounds = true
        iconView.isUserInteractionEnabled = true
        iconView.backgroundColor = .red
        return iconView
    }()
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "a big man"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0xffffff)
        return label
    }()
    fileprivate lazy var idLabel: UILabel = {
        let label = UILabel()
        label.text = "哆集主播ID: 123123"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0xffffff)
        return label
    }()
    fileprivate lazy var beansCountLabel: UILabel = {
        let label = UILabel()
        label.text = "88"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = UIColor(hex: CustomKey.Color.mainColor)
        return label
    }()
    fileprivate lazy var enterBtn: UIButton = {
        let startBtn = UIButton()
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        startBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        startBtn.setTitle("确定", for: .normal)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .disabled)
        return startBtn
    }()
    fileprivate lazy var fansCountLabel: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0xffffff)
        return label
    }()
    fileprivate lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0xffffff)
        return label
    }()
    fileprivate lazy var viewCountLabel: UILabel = {
        let label = UILabel()
       label.text = "25"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0xffffff)
        return label
    }()
    fileprivate lazy var maxCountLabel: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0xffffff)
        return label
    }()
    fileprivate lazy var shareView: ShareView = {
        let view = ShareView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupUIData()
        setupAction()
    }

}

extension FinishBroadcastVC {
    fileprivate func setupUI() {
        let bgView = UIImageView(image: UIImage(named: "broadcatBg.jpg"))
        view.addSubview(bgView)
        bgView.alpha = 0.6
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        
        let cover = UIView()
        view.addSubview(cover)
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        cover.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (maker) in
            maker.top.equalTo(65.0.fitHeight)
            maker.centerX.equalTo(view.snp.centerX)
            maker.width.equalTo(120.fitWidth)
            maker.height.equalTo(120.fitWidth)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconView.snp.bottom).offset(12)
            maker.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(idLabel)
        idLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(beansCountLabel)
        beansCountLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(idLabel.snp.bottom).offset(24)
             maker.centerX.equalTo(view.snp.centerX)
        }
        
        let beansLabel = UILabel()
        beansLabel.text = "哆豆"
        beansLabel.font = UIFont.systemFont(ofSize: 12)
        beansLabel.textAlignment = .center
        beansLabel.textColor = UIColor.white
        view.addSubview(beansLabel)
        beansLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(beansCountLabel.snp.bottom).offset(12)
            maker.centerX.equalTo(view.snp.centerX)
        }
        
        view.addSubview(fansCountLabel)
        fansCountLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(beansLabel.snp.bottom).offset(49.0.fitHeight)
            maker.right.equalTo(beansLabel.snp.left).offset(-77)
        }

        let fansLabel = UILabel()
        fansLabel.text = "粉丝"
        fansLabel.font = UIFont.systemFont(ofSize: 12)
        fansLabel.textAlignment = .center
        fansLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        view.addSubview(fansLabel)
        fansLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(fansCountLabel)
            maker.top.equalTo(fansCountLabel.snp.bottom).offset(12)
        }

        view.addSubview(commentCountLabel)
        commentCountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(beansLabel.snp.right).offset(77)
            maker.top.equalTo(fansCountLabel.snp.top)
        }
        let commentLabel = UILabel()
        commentLabel.text = "礼物"
        commentLabel.font = UIFont.systemFont(ofSize: 12)
        commentLabel.textAlignment = .center
        commentLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        view.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(commentCountLabel.snp.centerX)
            maker.top.equalTo(commentCountLabel.snp.bottom).offset(12)
        }

        /// views
        view.addSubview(viewCountLabel)
        viewCountLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(beansLabel.snp.left).offset(-77)
            maker.top.equalTo(fansLabel.snp.bottom).offset(33)
        }
        let viewLabel = UILabel()
        viewLabel.text = "累计观看"
        viewLabel.font = UIFont.systemFont(ofSize: 12)
        viewLabel.textAlignment = .center
        viewLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        view.addSubview(viewLabel)
        viewLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(viewCountLabel.snp.centerX)
            maker.top.equalTo(viewCountLabel.snp.bottom).offset(12)
        }
        
        /// 同时更高
        view.addSubview(maxCountLabel)
        maxCountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(beansLabel.snp.right).offset(77)
            maker.top.equalTo(viewCountLabel.snp.top)
        }
        let maxLabel = UILabel()
        maxLabel.text = "同时更高"
        maxLabel.font = UIFont.systemFont(ofSize: 12)
        maxLabel.textAlignment = .center
        maxLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        view.addSubview(maxLabel)
        maxLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(maxCountLabel.snp.centerX)
            maker.top.equalTo(viewLabel)
        }
        
        let shareLabel = UILabel()
        shareLabel.text = "分享直播到:"
        shareLabel.font = UIFont.systemFont(ofSize: 14)
        shareLabel.textAlignment = .center
        shareLabel.textColor = UIColor.white
        view.addSubview(shareLabel)
        shareLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view.snp.centerX)
            maker.top.equalTo(viewLabel.snp.bottom).offset(39.0.fitHeight)
        }
        
        view.addSubview(shareView)
        shareView.cancleBtn.isHidden = true
        shareView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(85)
            maker.top.equalTo(shareLabel.snp.bottom).offset(22.5)
        }
        
        view.addSubview(enterBtn)
        enterBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(37.5)
            maker.right.equalTo(-37.5)
            maker.top.equalTo(shareView.snp.bottom).offset(15)
            maker.height.equalTo(40.0)
        }
        enterBtn.layer.cornerRadius = 40.0 * 0.5
        enterBtn.layer.masksToBounds = true
        
    }
    
    fileprivate func setupAction() {
        weak var weakSelf = self
        guard let liveId = weakSelf?.live?.liveId else { return }
        let shareURL = CustomKey.URLKey.baseURL + "/live" + "/" + "\(liveId)" + "/html"
        let shareName = "Test"
        let shareContext = "Test"
        shareView.weiBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.typeSinaWeibo, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)
        
        shareView.qqZoneBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeQZone, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)
        
        shareView.weiChatBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeWechatSession, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)
        
        shareView.qqBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeQQFriend, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)
        
        shareView.friendCircleBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeWechatTimeline, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)

         enterBtn.rx.tap
            .subscribe(onNext: {[unowned self] _ in
                let rootVC = TabBarController()
                rootVC.selectedIndex = 0
                UIView.transition(with: self.view, duration: 1.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.view.removeFromSuperview()
                    UIApplication.shared.keyWindow?.addSubview(rootVC.view)
                }, completion: { (_) in
                    UIApplication.shared.keyWindow?.rootViewController = rootVC
                })
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupUIData() {
        weak var weakSelf = self
        guard let liveModel = weakSelf?.live else { return }
        let imgStr = CustomKey.URLKey.baseImageUrl + (liveModel.avastar ?? "")
        if let imgURL = URL(string: imgStr) {
            iconView.kf.setImage(with: imgURL, placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        nameLabel.text = liveModel.nickName ?? ""
        idLabel.text = "哆集直播ID: " + "\(liveModel.userId)"
        beansCountLabel.text = "\(liveModel.pointCount)"
        fansCountLabel.text = "\(liveModel.fansCount)"
        commentCountLabel.text = "\(liveModel.giftCount)"
        viewCountLabel.text = "\(liveModel.seeCount)"
        maxCountLabel.text = "\(liveModel.maxSeeingCount)"
    }
}
