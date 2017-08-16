//
//  BroadcastViewController.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable variable_name

import UIKit
import Device
import AVKit
import AVFoundation
import SnapKit
import RxSwift
import RxCocoa
import PromiseKit
import RxDataSources
import FXDanmaku
import Photos

class BroadcastViewController: BaseViewController {
    lazy var broacastVM: BroacastViewModel =  BroacastViewModel()
    fileprivate var roomVM: RoomViewModel = RoomViewModel()
    fileprivate lazy var txLivePlayer: TXLivePlayer = TXLivePlayer()
    fileprivate lazy var avatarImgeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholderImage_avatar")
        return imageView
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    fileprivate lazy  var svcontainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    fileprivate lazy  var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "00:00:00"
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    fileprivate lazy var seecountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = "10000人"
        label.textAlignment = .left
        label.textColor = UIColor(hex: CustomKey.Color.mainColor)
        return label
    }()
    fileprivate lazy var collectionBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "details_iscollect_btn@3x"), for: .normal)
        btn.setImage(UIImage(named: "details_iscollect_btn@3x"), for: .highlighted)
        return btn
    }()
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "common_close@3x"), for: .normal)
        btn.setImage(UIImage(named: "common_close@3x"), for: .highlighted)
        return btn
    }()
    fileprivate lazy var beansCountlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.text = "12"
        label.textColor = UIColor.white
        return label
    }()
    fileprivate lazy var IDlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.text = "1231231233"
        label.textColor = UIColor.white
        return label
    }()
    fileprivate var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play_share@3x"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    fileprivate var screenShotBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "screenshot"), for: .normal)
         btn.contentMode = .scaleAspectFit
        return btn
    }()
    fileprivate var messageBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "anchor_message3x"), for: .normal)
        btn.setImage(UIImage(named: "anchor_message_highighlight"), for: .highlighted)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    fileprivate var switchCamerabtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "switch_camera"), for: .normal)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    fileprivate var beautifyBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "meifu@3x"), for: .normal)
        btn.setImage(UIImage(named: "meifu_hightlight@3x"), for: .highlighted)
        btn.contentMode = .scaleAspectFit
        return btn
    }()
    fileprivate lazy var videoParentView: UIImageView = UIImageView(frame: self.view.bounds)
    fileprivate lazy var alterView: CloseBroadcastView = CloseBroadcastView()
    fileprivate lazy var shareView: ShareView = {
        let share = ShareView()
        share.backgroundColor = .white
        share.configApperance(textClor: UIColor.black)
        return share
    }()
    fileprivate  var timer: Timer?
    fileprivate var time: Float = 0
    fileprivate var messageHandler: MsgHandler = MsgHandler()
    fileprivate lazy var messageTableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.backgroundColor = .clear
        view.backgroundView = nil
        view.isOpaque = true
        view.separatorStyle = .none
        view.allowsSelection = false
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        return view
    }()
    fileprivate lazy var chatView: ChatInputView = {
        let view = ChatInputView()
        return view
    }()
    struct CustomSize {
        static let inputH: CGFloat = 60
        static let messageTableH: CGFloat = 150
        static let messageTableInset: CGFloat = 60
        static let bottomViewH: CGFloat = 50
        static let chatViewHeight: CGFloat = 80
        static let beautiftyViewH: CGFloat = 80
    }
    fileprivate var danmakuView: FXDanmaku = FXDanmaku()
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, NSAttributedString>>()
    fileprivate lazy var gitftAnimateView: GiftConatainerView = {
        let view = GiftConatainerView(frame: CGRect(x: 0, y: 120, width: 250, height: 200))
        return view
    }()
    fileprivate var viewerView: ViewerView = ViewerView()
    fileprivate var realTimer: Timer?
    fileprivate var bigGiftView = BigGiftAnimationView()
    fileprivate lazy var beautifyView: BeautifyView = BeautifyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllContainerView()
        setupMessageView()
        setupDanaku()
        setupGitAnimateView()
        setupBigGiftView()
        setupChatView()
        setupBeautifyView()
        addRealTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        endBroacast()
        removeTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupIM()
    }
}

// MARK: BASE UI
extension BroadcastViewController {
    /// 设置所有父视图
    fileprivate func setupAllContainerView() {
        view.addSubview(videoParentView)
        broacastVM.videoParentView = videoParentView
        
        let label = MGCustomCountDown.downView()
        label?.frame = UIScreen.main.bounds
        label?.delegate = self
        label?.backgroundColor = .clear
        view.addSubview(label ?? MGCustomCountDown())
        
        containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(containerView)
        if broacastVM.openCamera() {
            setupUserTagView()
            setupViewerView()
            setupBeansView()
            setupIDView()
            setupBottomView()
            label?.addTimerForAnimationDownView()
        }
        setupShareView()
    }
    
    /// 设置用户头像视图
    fileprivate func setupUserTagView() {
        let view = UIView()
        view.backgroundColor = .clear
        view.backgroundColor = UIColor(hex: 0x605c56, alpha: 0.5)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        containerView.addSubview(view)
        view.addSubview(avatarImgeView)
        avatarImgeView.layer.cornerRadius = 17
        avatarImgeView.layer.masksToBounds = true
        view.addSubview(seecountLabel)
        view.addSubview(timeLabel)
        
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
        
         timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(avatarImgeView.snp.right).offset(4)
            maker.centerY.equalTo(avatarImgeView.snp.centerY).offset(-10)
            maker.width.equalTo(80)
            
        }
        
        seecountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(timeLabel.snp.left)
            maker.top.equalTo(timeLabel.snp.bottom).offset(3)
            
        }
    }
    
    /// 设置播放器
    fileprivate func setupPlayer() {
        txLivePlayer.setupVideoWidget(svcontainerView.bounds, contain: svcontainerView, insert: 0)
    }
    
    /// 设置观众列表
    fileprivate func setupViewerView() {
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
        
        closeBtn.rx.tap
            .subscribe(onNext: {[weak self] (value) in
                self?.showAlertView()
            })
            .disposed(by: self.disposeBag)
        
        alterView.closeBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                self?.roomVM.messageHandler.quitLiveRoom().catch(execute: {_ in })
                self?.broacastVM.endLive()
                .then(execute: { (endlive) -> Void in
                    self?.broacastVM.stopRtmp()
                    let vcc = FinishBroadcastVC()
                    vcc.live = endlive
                    self?.present(vcc, animated: true, completion: nil)
                })
                .catch(execute: { error  in
                    
                })
            })
            .disposed(by: disposeBag)
        
        alterView.continueBtn.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                UIView.animate(withDuration: 0.25, animations: {
                    self?.alterView.removeFromSuperview()
                })
               _ = self?.broacastVM.startRtmp()
            })
            .disposed(by: disposeBag)
    }
    
    /// 设置哆豆 视图
    fileprivate func setupBeansView() {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 9
        view.layer.masksToBounds = true
        containerView.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(35 + 40 + 5)
            maker.width.equalTo(115)
            maker.height.equalTo(18)
        }
        let beanLabel = UILabel()
        beanLabel.text = "哆豆:"
        beanLabel.textColor = UIColor.white
        beanLabel.font = UIFont.systemFont(ofSize: 11)
        view.addSubview(beanLabel)
        beanLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(3)
            maker.centerY.equalTo(view.snp.centerY)
        }
        
        view.addSubview(beansCountlabel)
        beansCountlabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(beanLabel.snp.right).offset(5)
            maker.centerY.equalTo(beanLabel.snp.centerY)
        }
        
        let cover = UILabel()
        cover.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        cover.layer.cornerRadius = 9
        cover.layer.masksToBounds = true
        view.insertSubview(cover, at: 0)
        cover.snp.makeConstraints { (maker) in
            maker.left.equalTo(view.snp.left)
            maker.top.equalTo(view.snp.top)
            maker.bottom.equalTo(view.snp.bottom)
            maker.right.equalTo(beansCountlabel.snp.right).offset(5)
        }
    }
    
    /// 设置哆豆ID视图
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
        setupUserUIData()
    }
    
    /// 设置用户信息
    private func setupUserUIData() {
        let info = broacastVM.liveInfo
        if  let avatarURL = URL(string: CustomKey.URLKey.baseImageUrl + (info.avastar ?? "")) {
            avatarImgeView.kf.setImage(with: avatarURL)
        }
        IDlabel.text = " " + "\(info.userId)"
    }
    
    /// 设置底部视图
    fileprivate func setupBottomView() {
        let cover = UIButton(frame: self.containerView.bounds)
        containerView.addSubview(messageBtn)
        messageBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.bottom.equalTo(-12)
            maker.size.equalTo(CGSize(width: 34, height: 34))
        }
        
        containerView.addSubview(screenShotBtn)
        screenShotBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(-12)
            maker.right.equalTo(-12)
             maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        containerView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(-12)
            maker.right.equalTo(screenShotBtn.snp.left).offset(-30)
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        containerView.addSubview(switchCamerabtn)
        switchCamerabtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(-12)
            maker.right.equalTo(shareBtn.snp.left).offset(-30)
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        containerView.addSubview(beautifyBtn)
        beautifyBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(-12)
            maker.right.equalTo(switchCamerabtn.snp.left).offset(-30)
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        beautifyBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                UIView.animate(withDuration: 0.25, animations: {
                    let translate = CGAffineTransform.init(translationX: 0, y: -CustomSize.beautiftyViewH)
                    weakSelf.beautifyView.transform = translate
                     weakSelf.containerView.insertSubview(cover, belowSubview: weakSelf.beautifyView)
                })
            })
            .disposed(by: disposeBag)
        
        switchCamerabtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.broacastVM.switchCamera()
            })
            .disposed(by: disposeBag)
        
        messageBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.chatView.messageTf.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        screenShotBtn.rx.tap
            .subscribe(onNext: { (value) in
                let shot = UIScreen.getScreenShot()
                PHPhotoLibrary.shared().performChanges({ 
                    PHAssetChangeRequest.creationRequestForAsset(from: shot)
                }, completionHandler: { (isSuccess, error) in
                    if isSuccess {
                        HUD.showAlert(from: self, title: "提示", enterTitle: "确定", mesaage: "截图保存成功", success: {_ in })
                    } else {
                        HUD.showAlert(from: self, title: "提示", enterTitle: "确定", mesaage: "截图保存失败", success: { _ in })
                    }
                })
            })
            .disposed(by: self.disposeBag)
        
         shareBtn.rx.tap
            .subscribe(onNext: { (value) in
                UIView.animate(withDuration: 0.25, animations: {
                    let translate = CGAffineTransform.init(translationX: 0, y: -CustomKey.CustomSize.shareViewHight)
                        self.shareView.transform = translate
                })
                
            })
            .disposed(by: self.disposeBag)

         shareBtn.rx.tap
            .subscribe(onNext: { (value) in
                self.containerView.insertSubview(cover, belowSubview: self.shareView)
            })
            .disposed(by: self.disposeBag)
        
        cover.rx.tap
            .subscribe(onNext: { (value) in
              UIView.animate(withDuration: 0.25, animations: {
                    self.shareView.transform = CGAffineTransform.identity
                    self.beautifyView.transform = CGAffineTransform.identity
              }, completion: { _ in
                cover.removeFromSuperview()
              })
            })
           .disposed(by: self.disposeBag)
        
    }
    
    /// 设置分享UI
    fileprivate func setupShareView() {
        shareView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: CustomKey.CustomSize.shareViewHight)
        containerView.addSubview(shareView)
        weak var weakSelf = self
        guard let liveId = weakSelf?.broacastVM.liveInfo.liveNo else { return }
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
    
    /// 关闭直播的弹框
    private func showAlertView() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.25) { 
            self.alterView.frame = self.view.bounds
            self.containerView.addSubview(self.alterView)
        }
    }
    
    /// 设置消息记录View
    fileprivate func setupMessageView() {
        let bottomH: CGFloat = CustomSize.bottomViewH
        let inset: CGFloat = CustomSize.messageTableInset
        let messageH: CGFloat = CustomSize.messageTableH
        messageTableView.frame = CGRect(x: 0, y: UIScreen.height - bottomH - inset - messageH, width: UIScreen.width, height: messageH)
        containerView.insertSubview(messageTableView, at: 0)
        dataSource.configureCell = { (dataSource, tableView, indexPath, element) in
            let cell: MessageTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configAttributeMessage(element)
            return cell
        }
        
        roomVM.messageHandler.recievedMessageCallback = { message in
            self.setupRecieveMessage(message)
        }
    }
    
    /// 收到信息的处理
    fileprivate func setupRecieveMessage(_ message: IMMessage) {
        if message.userAction == .danmaku {
            setupDanmakuData(message)
        }
        if message.userAction == .commonGift {
            setupGiftAnimation(message: message)
            return
        }
        if message.userAction == .bigGift {
            setupGiftAnimation(message: message)
            return
        }
        self.roomVM.transFormIIMessgae(message)
        self.roomVM.caculateTextMessageHeight(message)
        let items = Observable.just([
            SectionModel(model: "First section", items: self.roomVM.attributeMessages)
            ])
        items
            .bind(to: self.messageTableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        self.messageTableView.scrollToRow(at: IndexPath(row: self.roomVM.attributeMessages.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    /// 结束直播
    fileprivate func endBroacast() {
        broacastVM.stopRtmp()
        timer?.invalidate()
        timer = nil
        roomVM.messageHandler.quitLiveRoom().catch(execute: {_ in })
        broacastVM.endLive().catch { (_) in}
        danmakuView.stop()
    }
    
    /// 聊天输入视图
    fileprivate func setupChatView() {
        weak var weaksSelf = self
        guard let weakSelf = weaksSelf else { return }
        let chatViewHeight: CGFloat = CustomSize.chatViewHeight
        chatView.frame = CGRect(x: 0, y: UIScreen.height + chatViewHeight, width: UIScreen.width, height: chatViewHeight)
        containerView.addSubview(chatView)
        chatView.backgroundColor = .white
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
            .subscribe(onNext: { (note) in
                if  let keyboardF = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect, let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                    
                    UIView.animate(withDuration: duration, animations: {
                        weakSelf.chatView.frame.origin.y = keyboardF.origin.y - CustomSize.inputH
                        weakSelf.messageTableView.frame.origin.y = weakSelf.chatView.frame.origin.y -  weakSelf.messageTableView.frame.height
                    })
                }
                
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
            .subscribe(onNext: { (note) in
                if  let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                    UIView.animate(withDuration: duration, animations: {
                        weakSelf.chatView.frame.origin.y = UIScreen.height + chatViewHeight
                        let bottomH: CGFloat = CustomSize.bottomViewH
                        let inset: CGFloat = CustomSize.messageTableInset
                        let messageH: CGFloat = CustomSize.messageTableH
                        weakSelf.messageTableView.frame.origin.y = UIScreen.height - bottomH - inset - messageH
                    })
                }
                
            })
            .disposed(by: disposeBag)
        
        chatView.sendBtn.rx.tap
            .subscribe(onNext: {(note) in
                weakSelf.sendTextInputMessage()
            })
            .disposed(by: disposeBag)
        
        chatView.returnKeyPressAction = { _ in
            weakSelf.sendTextInputMessage()
        }
        
        roomVM.messageHandler.recievedMessageCallback = { message in
            weakSelf.setupRecieveMessage(message)
        }
    }
    
    //// 设置美颜美白视图
    fileprivate func setupBeautifyView() {
        beautifyView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height:  CustomSize.beautiftyViewH)
        beautifyView.backgroundColor = .white
        containerView.addSubview(beautifyView)
        
        let faceSliderValue = Variable<Float>(0.5)
        _ =  beautifyView.faceSlider.rx.value <-> faceSliderValue
        faceSliderValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                 self?.broacastVM.beautify(x)
                
            })
            .disposed(by: disposeBag)
        
        let whiteSliderValue = Variable<Float>(0.5)
        _ =  beautifyView.whiteSlider.rx.value <-> whiteSliderValue
        whiteSliderValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.broacastVM.whitenfy(x)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: IM
extension BroadcastViewController {
    /// 登录房间 -> 加入房间
    fileprivate func setupIM() {
        roomVM.loginRoom().then { _ -> Void  in
            weak var weakSelf = self
            if let weakSelf = weakSelf, let groupId = weakSelf.broacastVM.liveInfo.groupId {
                weakSelf.roomVM.messageHandler.joinLiveRoom(with: groupId)
                    .then(on: DispatchQueue.main, execute: { (_) -> Void in
                        weakSelf.roomVM.messageHandler.joinGrooup()
                        let myMessage = IMMessage()
                        myMessage.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? 0
                        myMessage.nickName = CoreDataManager.sharedInstance.getUserInfo()?.nickName ?? ""
                        myMessage.msg = "进入直播间"
                        myMessage.userAction = .enterLive
                        myMessage.level = CoreDataManager.sharedInstance.getUserInfo()?.level ?? 0
                        weakSelf.setupRecieveMessage(myMessage)
                        if weakSelf.broacastVM.startRtmp() {
                           weakSelf.addTimeLineTimer()
                        }
                    })
                    .catch(execute: { (error) in
                        HUD.showAlert(from: weakSelf, title: "提示",
                                      enterTitle: "重试",
                                      cancleTitle: "取消",
                                      mesaage: "聊天室创建失败，请重试",
                                      success: { 
                                             weakSelf.setupIM()  },
                                      failure: {
                                             weakSelf.dismiss(animated: true, completion: nil) })
                    })
                
            }
        }.catch { error in
            if let error = error as? AppError {
                self.view.makeToast(error.message)
            }
        }
    }
    
    /// 发送文字消息
    fileprivate func sendTextInputMessage() {
        weak var weaksSelf = self
        guard let weakSelf = weaksSelf else { return }
        if let message = chatView.messageTf.text, !message.isEmpty {
            let myMessage = IMMessage()
            myMessage.headPic = CoreDataManager.sharedInstance.getUserInfo()?.avatar ?? ""
            myMessage.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? 0
            myMessage.nickName = CoreDataManager.sharedInstance.getUserInfo()?.nickName ?? ""
            myMessage.msg = message
            myMessage.level = CoreDataManager.sharedInstance.getUserInfo()?.level ?? 0
            if chatView.isDanakuMessage {
                let danmakuParam = ChatRequestParam()
                danmakuParam.liveId = roomVM.room?.liveId ?? 0
                roomVM.requestSendDanmaku(with: danmakuParam)
                    .then(on: .main, execute: { (_) -> Void in
                        myMessage.userAction = .danmaku
                        weakSelf.roomVM.messageHandler.sendMessage(with: myMessage)
                        weakSelf.setupRecieveMessage(myMessage)
                    })
                    .catch(execute: { (error) in
                        if let error = error as? AppError, error.erroCode == .pointUnavailable {
                            weakSelf.toRechargeVC()
                        }
                    })
            } else {
                myMessage.userAction = .text
                roomVM.messageHandler.sendTextMessage(message)
                setupRecieveMessage(myMessage)
            }
            chatView.messageTf.text = ""
        }
    }
    
    /// 跳转到充值界面
    fileprivate func toRechargeVC() {
        HUD.showAlert(from: self, title: "提示", mesaage: "余额不足，请充值", doneActionTitle: "去充值", handle: {
            let vcc = RechargeController()
            self.present(NavigationController(rootViewController: vcc), animated: true, completion: nil)
            vcc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_nav_arrow_black"), style: .plain, target: self, action: nil)
            vcc.navigationItem.leftBarButtonItem?.rx.tap
                .subscribe(onNext: { (value) in
                    vcc.dismiss(animated: true, completion: nil)
                })
                .disposed(by: self.disposeBag)
        })
    }
}

/// MARK: COUNTDOWN
extension BroadcastViewController: MGCustomCountDownDelagete {
    /// 倒计时结束
    func customCountDown(_ downView: MGCustomCountDown!) {
        downView.isHidden = true
        downView.removeFromSuperview()
        getRealTimerInfo()
    }
    
    /// 添加定时器计算直播时长
    fileprivate func addTimeLineTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer ?? Timer(), forMode: RunLoopMode.commonModes)
    }
    
    /// 显示推流的时长
    @objc private func timerAction() {
        time += 1
      let timeText  = String(format: "%02d:%02d:%02d", Int(time / 3600.0), Int((time / 60.0).truncatingRemainder(dividingBy: 60.0)), Int(time.truncatingRemainder(dividingBy: 60.0)))
     timeLabel.text = timeText
    }
}

/// 设置消息列表cell的高度
extension BroadcastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < roomVM.cellHeights.count {
            return roomVM.cellHeights[indexPath.row]
        }
        return 30.0
    }
}

// MARK: DANAKU
extension BroadcastViewController: FXDanmakuDelegate {
    /// 设置弹幕
    fileprivate func setupDanaku() {
        danmakuView.frame = CGRect(x: -UIScreen.width, y: 100, width: UIScreen.width * 2, height: 200)
        containerView.insertSubview(danmakuView, at: 0)
        let config = FXDanmakuConfiguration.default()
        config?.rowHeight = 40
        config?.itemInsertOrder = .random
        danmakuView.configuration = config
        danmakuView.delegate = self
        danmakuView.register(DanmakuItem.self, forItemReuseIdentifier: "DanmakuItem")
    }
    
    /// 点击某一条弹幕
    func danmaku(_ danmaku: FXDanmaku, didClick item: FXDanmakuItem, with data: FXDanmakuItemData) {
        
    }
    
    /// 根据消息设置弹幕样式
    fileprivate func setupDanmakuData(_ message: IMMessage) {
        if let  data = DanmakuItemData(itemReuseIdentifier: "DanmakuItem") {
            data.message = message
            danmakuView.add(data)
        }
        if !danmakuView.isRunning {
            danmakuView.start()
        }
    }
    
}

/// MARK: GIFT
extension BroadcastViewController {
    /// 礼物列表
    fileprivate func setupGitAnimateView() {
        gitftAnimateView.backgroundColor = UIColor.clear
        containerView.insertSubview(gitftAnimateView, at: 0)
    }
    
    /// 将礼物消息处理为动画
    fileprivate func setupGiftAnimation(message: IMMessage) {
        switch message.userAction {
        case .commonGift:
            gitftAnimateView.addGift(message)
        case .bigGift:
            gitftAnimateView.addGift(message)
            bigGiftView.addGift(message)
        default:
            break
        }
    }
    
    /// 大礼物动画视图
    fileprivate func setupBigGiftView() {
        bigGiftView.frame = containerView.bounds
        containerView.insertSubview(bigGiftView, at: 0)
    }
}

/// MARK:TIMER
/// 定时获取用户信息
extension BroadcastViewController {
    fileprivate func addRealTimer() {
        realTimer?.invalidate()
        realTimer = nil
        realTimer = Timer(timeInterval: 5, target: self, selector: #selector(self.getRealTimerInfo), userInfo: nil, repeats: true)
        RunLoop.main.add(realTimer ?? Timer(), forMode: RunLoopMode.commonModes)
        
    }
    
    fileprivate  func removeTimer() {
        realTimer?.invalidate()
        realTimer = nil
        timer?.invalidate()
        timer = nil
    }
    
    @objc fileprivate func getRealTimerInfo() {
        roomVM.requestRealTime(with: "\(broacastVM.liveInfo.liveId)")
            .then(execute: { [unowned self] (info) -> Void in
                self.beansCountlabel.text = "\(info.income)"
                self.seecountLabel.text = "\(info.seeingCount)" + "人"
                if let users = info.users {
                    self.viewerView.config(Observable.just(users))
                }
            })
            .catch(execute: { _ in })
    }
}
