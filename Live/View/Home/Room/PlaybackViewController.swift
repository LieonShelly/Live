//
//  PlaybackViewController.swift
//  Live
//
//  Created by lieon on 2017/7/8.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable variable_name

import UIKit
import RxSwift
import RxCocoa

class PlaybackViewController: BasePlayerVC {
    var video: LiveListModel?
    fileprivate var sliderValue: Float = 0
    fileprivate var isPause: Bool = false
    fileprivate var isStartSeek: Bool = false
    lazy var bottomView: PlaybackBottomView = {
        let view = PlaybackBottomView()
        return view
    }()
    fileprivate lazy var shareView: ShareView = {
        let share = ShareView()
        share.backgroundColor = .white
        share.configApperance(textClor: UIColor.black)
        return share
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        txLivePlayer.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startPlay()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closePlay()
    }
}

extension PlaybackViewController {
    fileprivate func setupUI() {
    if let coverImage = video?.coverImage {
        let backImageNewHeight = self.view.bounds.height
        let backImageNewWidth =  backImageNewHeight * coverImage.size.width / coverImage.size.height
        let gsimage = coverImage.gsImagewithGsNumber(10)
        let scaleImage = gsimage?.scale(to: CGSize(width: backImageNewWidth, height: backImageNewHeight))
        let clipImage = scaleImage?.clipImage(in: CGRect(x: (backImageNewWidth - self.view.bounds.width)/2, y: (backImageNewHeight - self.view.bounds.height)/2, width: self.view.bounds.width, height: self.view.bounds.height))
        coverImageView.image = clipImage
    }
    seecountLabel.isHidden = true
        closeBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        setupBottomView()
        setupShareView()
        
        collectionBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                let  param: CollectionRequstParam = CollectionRequstParam()
                guard let userId = self?.video?.userId, let liveId = self?.video?.liveId else { return }
                param.userId = userId
                param.liveId = liveId
                guard let weakSelf = self, let room = weakSelf.video else {  return }
                let roomVM = RoomViewModel()
                if room.isFollow {
                    roomVM.cancleCollectionLiver(with: param).then(execute: { (isCancle) -> Void in
                        weakSelf.video?.isFollow = !isCancle
                        weakSelf.collectionBtn.isSelected = !isCancle
                    })
                        .catch { (error) in
                            if let error = error as? AppError {
                                self?.view.makeToast(error.message)
                            }
                    }
                } else {
                    roomVM.collectionLiver(with: param)
                        .then(execute: { (isFollow) -> Void in
                            weakSelf.video?.isFollow = isFollow
                            weakSelf.collectionBtn.isSelected = isFollow
                        })
                        .catch { (error) in
                            if let error = error as? AppError {
                                self?.view.makeToast(error.message)
                            }
                    }
                }
                
            })
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func setupBottomView() {
        containerView.insertSubview(bottomView, aboveSubview: scrollView)
        bottomView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(50)
        }
        
        bottomView.shareBtn.rx.tap
            .subscribe(onNext: { (value) in
                UIView.animate(withDuration: 0.25, animations: {
                    let translate = CGAffineTransform.init(translationX: 0, y: -168)
                    self.shareView.transform = translate
                })
                
            })
            .disposed(by: self.disposeBag)
        
        let cover = UIButton(frame: self.containerView.bounds)
        bottomView.shareBtn.rx.tap
            .subscribe(onNext: { (value) in
                self.containerView.insertSubview(cover, belowSubview: self.shareView)
            })
            .disposed(by: self.disposeBag)
        
        cover.rx.tap
            .subscribe(onNext: { (value) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.shareView.transform = CGAffineTransform.identity
                }, completion: { _ in
                    cover.removeFromSuperview()
                })
            })
            .disposed(by: self.disposeBag)
        
        bottomView.onSeeckAction = {[unowned self] slider in
            self.txLivePlayer.seek(self.sliderValue)
            self.isStartSeek = false
        }
        
        bottomView.onSeekBeginAction = { [unowned self]  _ in
            self.isStartSeek = true
        }
        
        bottomView.onDragAction = { [unowned self] slider in
            let progress = slider.value
            self.sliderValue = progress
            self.bottomView.setup(displayTime: progress)
        }
        
        bottomView.playAction = { [unowned self] btn in
            if self.isPause {
                self.txLivePlayer.resume()
                self.isPause = false
                btn.isSelected = false
            } else {
                self.txLivePlayer.pause()
                self.isPause = true
                btn.isSelected = true
            }
        }
    }
    
    fileprivate func startPlay() {
        guard let video  = video else {
            return
        }
        if  let avatarURL = URL(string: CustomKey.URLKey.baseImageUrl + (video.avatar ?? "")) {
            avatarImgeView.kf.setImage(with: avatarURL)
        }
        guard let replayMap4 = video.replayUrlMp4 else {
            HUD.showAlert(from: self, title: "提示", enterTitle: "退出", mesaage: "回放地址解析失败", success: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            return
        }
        nameLabel.text = video.userName ?? ""
        IDlabel.text = "\(video.userId)"
        txLivePlayer.startPlay(replayMap4, type: .PLAY_TYPE_VOD_MP4)
    }
    
    fileprivate func closePlay() {
        txLivePlayer.stopPlay()
    }
    
    fileprivate func setupShareView() {
        shareView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 168)
        containerView.addSubview(shareView)
        weak var weakSelf = self
        guard let liveId = weakSelf?.video?.liveId else { return }
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
    }
}

extension PlaybackViewController: TXLivePlayListener {
    func onNetStatus(_ param: [AnyHashable : Any]!) {
        
    }
    
    func onRecvConnectNofity() {
        
    }
    
    func onPlayEvent(_ EvtID: Int32, withParam param: [AnyHashable : Any]!) {
        print("**********onPlayEvent:\(EvtID)*******************")
        if PLAY_ERR_NET_DISCONNECT == EventID.init(rawValue: EvtID) {
            HUD.showAlert(from: self, title: "提示", enterTitle: "退出", mesaage: "资源未找到", success: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        let queue = DispatchQueue.main
        queue.async {[weak self] in
            guard let weakSelf = self  else {   return }
            if PLAY_EVT_PLAY_PROGRESS == EventID.init(rawValue: EvtID)  && weakSelf.isStartSeek == false {
                if   let progress = param[EVT_PLAY_PROGRESS] as? Float, let duration = param[EVT_PLAY_DURATION] as? Float, duration != 0.0 {
                    weakSelf.bottomView.setup(progress: progress, duration: duration)
                }
            }
          
        }
    }
}
