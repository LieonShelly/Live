//
//  RoomViewController.swift
//  Live
//
//  Created by lieon on 2017/6/25.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PromiseKit
import RxDataSources
import FXDanmaku
import Device
import ObjectMapper

class RoomViewController: BasePlayerVC {
    var roomVM = RoomViewModel()
    fileprivate lazy var shareView: ShareView = {
        let share = ShareView()
        share.backgroundColor = .white
        share.configApperance(textClor: UIColor.black)
        return share
    }()
    fileprivate lazy var emitterLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.renderMode = kCAEmitterLayerUnordered
        var emitterCellArr = [CAEmitterCell]()
        for i in 0 ..< 10 {
            let cell = CAEmitterCell()
            cell.birthRate = 1
            cell.lifetime = Float(arc4random_uniform(4) + 1)
            cell.lifetimeRange = 1.5
            let image = UIImage(named: "good\(i)_30x30_")
            cell.contents = image?.cgImage
            cell.velocity = CGFloat(arc4random_uniform(100) + 100)
            cell.velocityRange = 80
            cell.emissionLongitude = CGFloat.pi + CGFloat.pi * 0.5
            cell.emissionRange = (CGFloat.pi * 0.5) / 6.0
            cell.scale = 0.3
            emitterCellArr.append(cell)
        }
        layer.emitterCells = emitterCellArr
        return layer
    }()
    fileprivate lazy var beansCountlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    
    
    fileprivate lazy var bottomView: RoomBottomView = {
        let view = RoomBottomView()
        return view
    }()
    fileprivate lazy var chatView: ChatInputView = {
        let view = ChatInputView()
        return view
    }()
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
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, NSAttributedString>>()
    fileprivate var danmakuView: FXDanmaku = FXDanmaku()
    struct CustomSize {
        static let inputH: CGFloat = 60
        static let messageTableH: CGFloat = 150
        static let messageTableInset: CGFloat = 60
        static let bottomViewH: CGFloat = 50
        static let chatViewHeight: CGFloat = 80
        static let gitftH: CGFloat = 245
    }
    fileprivate lazy var giftView: GiftView = GiftView()
    fileprivate lazy var gitftAnimateView: GiftConatainerView = {
        let view = GiftConatainerView(frame: CGRect(x: 0, y: 120, width: 200, height: 200))
        return view
    }()
    fileprivate var realTimer: Timer?
    fileprivate var bigGiftView = BigGiftAnimationView()
    
    /// 设置一些基础UI
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBeansView()
        setupBottomView()
        setupEmitter()
        setupAction()
        setupChatView()
        addKeyboadNotification()
        setupMessageView()
        setupDanaku()
        setupShareView()
        setupGiftView()
        setupGitftData()
        setupGitAnimateView()
        setupBigGiftView()
    }
    
   /// 登录房间 -> 加入聊天室内 -> 获取房间信息
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let liveId = roomVM.room?.liveId {
           roomVM.loginRoom()
            .then(execute: {[unowned self] (_) -> Void in
                self.joinGroup()
                self.loadRoomData(roomID: "\(liveId)")
           }).catch(execute: {[unowned self] (error) in
            if let error = error as? AppError {
                self.view.makeToast(error.message)
            }
           })
        }
        getRealTimerInfo()
        addRealTimer()
    }
    
    /// 离开房间（调用服务器端）-> 离开聊天室（IM端）-> 移除定时器
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leaveRoom()
        roomVM.messageHandler.quitLiveRoom().catch(execute: {_ in })
        danmakuView.stop()
        removeTimer()
        containerView.removeFromSuperview()
         NotificationCenter.default.removeObserver(self)
    }
            
    deinit {
        print("**********deinit")
    }
            
    @objc fileprivate func keyboardShow (note: Notification) {
        if  let keyboardF = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect, let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: duration, animations: { [unowned self] in
                self.chatView.frame.origin.y = keyboardF.origin.y - CustomSize.inputH
                self.messageTableView.frame.origin.y = self.chatView.frame.origin.y -  self.messageTableView.frame.height
            })
        }
    }
            
    @objc fileprivate func keyboardHide(note: Notification) {
            let chatViewHeight: CGFloat = CustomSize.chatViewHeight
            if  let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                UIView.animate(withDuration: duration, animations: { [unowned self] in
                    self.chatView.frame.origin.y = UIScreen.height + chatViewHeight
                    let bottomH: CGFloat = CustomSize.bottomViewH
                    let inset: CGFloat = CustomSize.messageTableInset
                    let messageH: CGFloat = CustomSize.messageTableH
                    self.messageTableView.frame.origin.y = UIScreen.height - bottomH - inset - messageH
                })
            }
        }
}

// MARK: BASE UI
extension RoomViewController {
    /// 哆豆数的UI
    fileprivate func setupBeansView() {
        if let coverImage = roomVM.room?.coverImage {
            let backImageNewHeight = self.view.bounds.height
            let backImageNewWidth =  backImageNewHeight * coverImage.size.width / coverImage.size.height
            let gsimage = roomVM.room?.coverImage?.gsImagewithGsNumber(10)
            let scaleImage = gsimage?.scale(to: CGSize(width: backImageNewWidth, height: backImageNewHeight))
            let clipImage = scaleImage?.clipImage(in: CGRect(x: (backImageNewWidth - self.view.bounds.width)/2, y: (backImageNewHeight - self.view.bounds.height)/2, width: self.view.bounds.width, height: self.view.bounds.height))
            coverImageView.image = clipImage
        }
        
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
        beanLabel.textColor = .white
        beanLabel.font = UIFont.systemFont(ofSize: 11)
        view.addSubview(beanLabel)
        beanLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(8)
            maker.centerY.equalTo(view.snp.centerY)
        }
        
        view.addSubview(beansCountlabel)
        beansCountlabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(beanLabel.snp.right).offset(5)
            maker.centerY.equalTo(beanLabel.snp.centerY)
        }
        
        let cover = UIImageView()
        cover.image = UIImage(named: "bean_bg_image")
        view.insertSubview(cover, at: 0)
        cover.snp.makeConstraints { (maker) in
            maker.left.equalTo(view.snp.left)
            maker.top.equalTo(view.snp.top)
            maker.bottom.equalTo(view.snp.bottom)
            maker.width.equalTo(100)
        }
    }

    /// 底部View
    fileprivate func setupBottomView() {
        containerView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(50)
        }
        bottomView.zanBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                  self?.startPraiseAnimation()
                  self?.bottomView.zanBtn.addFaveAnimation()
            })
            .disposed(by: self.disposeBag)
        
        bottomView.shareBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                UIView.animate(withDuration: 0.25, animations: {
                    let translate = CGAffineTransform.init(translationX: 0, y: -CustomKey.CustomSize.shareViewHight)
                    self?.shareView.transform = translate
                })
            })
            .disposed(by: self.disposeBag)
        
        bottomView.shopingBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                self?.showGiftView()
            })
            .disposed(by: self.disposeBag)
    }
    
    /// 设置各种Action
    fileprivate func setupAction() {
        /// 收藏按钮的点击
        collectionBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                let  param: CollectionRequstParam = CollectionRequstParam()
                guard let userId = self?.roomVM.room?.userId, let liveId = self?.roomVM.room?.liveId else { return }
                 param.userId = userId
                 param.liveId = liveId
                guard let weakSelf = self, let room = weakSelf.roomVM.room else {  return }
                if room.isFollow {
                    weakSelf.roomVM.cancleCollectionLiver(with: param).then(execute: { (isCancle) -> Void in
                            weakSelf.roomVM.room?.isFollow = !isCancle
                            weakSelf.collectionBtn.isSelected = !isCancle
                    })
                        .catch { (error) in
                        if let error = error as? AppError {
                            weakSelf.view.makeToast(error.message)
                        }
                    }
                } else {
                    weakSelf.roomVM.collectionLiver(with: param)
                        .then(execute: { (isFollow) -> Void in
                            weakSelf.roomVM.room?.isFollow = isFollow
                            weakSelf.collectionBtn.isSelected = isFollow
                            let message = IMMessage()
                            message.nickName = CoreDataManager.sharedInstance.getUserInfo()?.nickName ?? ""
                            message.level = CoreDataManager.sharedInstance.getUserInfo()?.level ?? 0
                            message.userAction = .attentAnchor
                            message.headPic = CoreDataManager.sharedInstance.getUserInfo()?.avatar ?? ""
                            message.msg = "关注主播"
                            weakSelf.roomVM.messageHandler.sendMessage(with: message)
                            weakSelf.setupRecieveMessage(message)
                        })
                        .catch { (error) in
                            if let error = error as? AppError {
                                weakSelf.view.makeToast(error.message)
                            }
                    }
                }
             
            })
            .disposed(by: self.disposeBag)
        /// 弹起聊天框
        bottomView.chattap.rx
            .event
            .subscribe(onNext: {[weak self] (tap) in
                self?.chatView.messageTf.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    /// 设置聊天输入框
    fileprivate func setupChatView() {
        let chatViewHeight: CGFloat = CustomSize.chatViewHeight
        chatView.frame = CGRect(x: 0, y: UIScreen.height + chatViewHeight, width: UIScreen.width, height: chatViewHeight)
        containerView.addSubview(chatView)
        chatView.backgroundColor = .white
        /// 发送按钮的点击
        chatView.sendBtn.rx.tap
             .subscribe(onNext: {[weak self] (note) in
                self?.sendTextInputMessage()
             })
            .disposed(by: disposeBag)
        
        /// 键盘发送按钮的点击
        chatView.returnKeyPressAction = { [weak self] in
            self?.sendTextInputMessage()
        }
        
        // MARK: 收到IM的消息回调
        roomVM.messageHandler.recievedMessageCallback = { [weak self] message in
            self?.setupRecieveMessage(message)
        }
    }

    /// 添加键盘通知
    fileprivate func addKeyboadNotification() {
        NotificationCenter.default.addObserver(self, selector:  #selector(self.keyboardShow (note:)), name: Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(self.keyboardHide (note:)), name: Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
    }
    
    /// 发送文字信息，包括普通文字信息和弹幕消息
    fileprivate func sendTextInputMessage() {
        weak var weaksSelf = self
        guard let weakSelf = weaksSelf else { return }
        if let message = chatView.messageTf.text, !message.isEmpty {
            /// 创建消息
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
                        /// 设置文字消息类型
                        myMessage.userAction = .danmaku
                        /// 发送文字消息
                        weakSelf.roomVM.messageHandler.sendMessage(with: myMessage)
                        /// 显示文字消息
                        weakSelf.setupRecieveMessage(myMessage)
                    })
                    .catch(execute: { (error) in
                        /// 哆豆不足，提示去充值
                        if let error = error as? AppError, error.erroCode == .pointUnavailable {
                            weakSelf.toRechargeVC()
                        }
                    })
            } else {
                /// 设置文字消息类型
                myMessage.userAction = .text
                /// 发送文字消息
                roomVM.messageHandler.sendTextMessage(message)
                /// 显示文字消息
                setupRecieveMessage(myMessage)
            }
            chatView.messageTf.text = ""
        }
    }
    
    /// 设置消息记录UI
    fileprivate func setupMessageView() {
        let bottomH: CGFloat = CustomSize.bottomViewH
        let inset: CGFloat = CustomSize.messageTableInset
        let messageH: CGFloat = CustomSize.messageTableH
        messageTableView.frame = CGRect(x: 0, y: UIScreen.height - bottomH - inset - messageH, width: UIScreen.width, height: messageH)
        containerView.addSubview(messageTableView)
        dataSource.configureCell = { (dataSource, tableView, indexPath, element) in
            let cell: MessageTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configAttributeMessage(element)
            return cell
        }
    }
    
    /// 设置分享UI
    fileprivate func setupShareView() {
        shareView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: CustomKey.CustomSize.shareViewHight)
        containerView.addSubview(shareView)
        let cover = UIButton(frame: containerView.bounds)
        bottomView.shareBtn.rx.tap
            .subscribe(onNext: { [weak self](value) in
                self?.containerView.insertSubview(cover, aboveSubview: self!.messageTableView)
            })
            .disposed(by: disposeBag)
        
        cover.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                UIView.animate(withDuration: 0.25, animations: {
                    self?.shareView.transform = CGAffineTransform.identity
                }, completion: { _ in
                    cover.removeFromSuperview()
                })
            })
            .disposed(by: disposeBag)
        guard let liveId = self.roomVM.room?.liveId else { return }
        let shareURL = CustomKey.URLKey.baseURL + "/live" + "/" + "\(liveId)" + "/html"
        let shareName = "Test"
        let shareContext = "Test"
        shareView.weiBtn.rx.tap
            .subscribe(onNext: {  [weak self] (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.typeSinaWeibo, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self!, success: {_ in })
            })
            .disposed(by: disposeBag)
        
        shareView.qqZoneBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeQZone, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self!, success: {_ in })
            })
            .disposed(by: disposeBag)
        
        shareView.weiChatBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeWechatSession, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self!, success: {_ in })
            })
            .disposed(by: disposeBag)
        
        shareView.qqBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeQQFriend, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self!, success: {_ in })
            })
            .disposed(by: disposeBag)
        
        shareView.friendCircleBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeWechatTimeline, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self!, success: {_ in })
            })
            .disposed(by: disposeBag)
    }
}

// MARK: ROOM DATA
extension RoomViewController {
    /// 请求房间数据
    fileprivate func loadRoomData(roomID: String?) {
        guard let roomID = roomID else { return }
        roomVM.requestEnterLiveRoom(with: roomID)
            .then(execute: {[unowned self] (_) -> Void in
                 self.setupUserUIData()
                  self.startPlay()
            })
            .catch { (error) in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
        }
    }
    
    /// 设置用户数据
    private func setupUserUIData() {
        guard  let room = roomVM.room else {
            return
        }
        if  let avatarURL = URL(string: CustomKey.URLKey.baseImageUrl + (room.avatar ?? "")) {
            avatarImgeView.kf.setImage(with: avatarURL)
        }
        guard  let isfollow = self.roomVM.room?.isFollow else {  return }
        collectionBtn.isSelected = isfollow
        nameLabel.text = room.userName ?? ""
        viplevLabel.backgroundColor = room.level <= 5 ? UIColor(hex: 0xff70ad) : UIColor(hex: 0xab68ff)
        viplevLabel.text = "V" + "\(room.level)"
        IDlabel.text = " " + "\(room.userId)"
    }
    
    /// 开始拉流
    fileprivate func startPlay() {
        let config = TXLivePlayConfig()
        config.bAutoAdjustCacheTime = false
        config.minAutoAdjustCacheTime = 1
        config.maxAutoAdjustCacheTime = 5
        config.cacheTime = 5
        txLivePlayer.enableHWAcceleration = true
        txLivePlayer.config = config
        guard let room = self.roomVM.room else { return }
        if room.type == .living {
            txLivePlayer.startPlay(room.playUrlFlv, type: TX_Enum_PlayType.PLAY_TYPE_LIVE_FLV)
        } else {
            HUD.showAlert(from: self, title: "", mesaage: "该直播已结束", doneActionTitle: "退出", handle: { 
                self.dismiss(animated: true, completion: nil)
            })
        }

    }
    
    /// 离开房间
    fileprivate func leaveRoom() {
        txLivePlayer.stopPlay()
        if let roomID = roomVM.room?.liveId {
            roomVM.requestLeaveLiveRoom(with: "\(roomID)").catch(execute: { _ in})
        }
    }
    
    /// 加入群聊
    fileprivate func joinGroup() {
        weak var weakSelf = self
        if  let room = roomVM.room, let weakSelf = weakSelf {
            roomVM.messageHandler.joinLiveRoom(with: "\(room.groupId ?? "")")
                .then(on: DispatchQueue.main, execute: { (_) -> Void in
                     weakSelf.roomVM.messageHandler.joinGrooup()
                    let myMessage = IMMessage()
                    myMessage.headPic = CoreDataManager.sharedInstance.getUserInfo()?.avatar ?? ""
                    myMessage.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? 0
                    myMessage.nickName = CoreDataManager.sharedInstance.getUserInfo()?.nickName ?? ""
                    myMessage.msg = "进入直播间"
                    /// 设置消息类型为加入房间
                    myMessage.userAction = .enterLive
                    myMessage.level = CoreDataManager.sharedInstance.getUserInfo()?.level ?? 0
                    weakSelf.setupRecieveMessage(myMessage)
                })
                .catch(execute: { (error) in
                    if let error = error as? AppError {
                        self.view.makeToast(error.message)
                        HUD.showAlert(from: self, title: "", enterTitle: "退出", mesaage: "该直播已结束", success: { 
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            
        }
    }

    /// 处理收到的消息
    fileprivate func setupRecieveMessage(_ message: IMMessage) {
        roomVM.transFormIIMessgae(message)
        roomVM.caculateTextMessageHeight(message)
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
        let items = Observable.just([
            SectionModel(model: "First section", items: self.roomVM.attributeMessages)
            ])
        items
            .bind(to: self.messageTableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        self.messageTableView.scrollToRow(at: IndexPath(row: self.roomVM.attributeMessages.count - 1, section: 0), at: .bottom, animated: true)
    }
    
}

// MARK: ANIMATION
extension RoomViewController {
    /// 点赞动画
    fileprivate func startPraiseAnimation() {
        let imageView = UIImageView()
        let frame = view.frame
        imageView.frame = CGRect(x: frame.width - 40, y: frame.height - 65, width: 30, height: 30)
        imageView.alpha = 0
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1.0
            imageView.frame =  CGRect(x: frame.width - 40, y: frame.height - 90, width: 30, height: 30)
            let transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            imageView.transform = transform
        }
        self.containerView.addSubview(imageView)
        let finishX = frame.width - CGFloat(round(Double(arc4random() % 200)))
        let finishY = CGFloat(200)
        let scale = CGFloat(round(Double(arc4random() % 2)) + 0.7)
        let speed = 1 / round(Double(arc4random() % 900)) + 0.6
        var duration = 4 * speed
        if duration == Double.infinity {
            duration = 2.3432423
        }
        let imageName: Int = Int(round(Double(arc4random() % 10)))
        UIView.animate(withDuration: duration, animations: {
            imageView.image = UIImage(named: "good\(imageName)_30x30_")
            imageView.frame = CGRect(x: finishX, y: finishY, width: 30 * scale, height: 30 * scale)
        }) { _ in
            imageView.removeFromSuperview()
        }
    }
    
    /// 粒之动画
    fileprivate func setupEmitter() {
        emitterLayer.emitterPosition = CGPoint(x: self.containerView.bounds.width - 50, y: self.containerView.bounds.height - 50)
        emitterLayer.emitterSize = CGSize(width: 20, height: 20)
        containerView.layer.addSublayer(emitterLayer)
        emitterLayer.isHidden = false
    }
    
    /// 移除粒子动画
    fileprivate func removeEmitter() {
        emitterLayer.removeFromSuperlayer()
    }
}

/// 设置聊天记录的每行的高度
extension RoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < roomVM.cellHeights.count {
            return roomVM.cellHeights[indexPath.row]
        }
        return 30.0
    }
}

// MARK: DANAKU
extension RoomViewController: FXDanmakuDelegate {
    /// 添加弹幕视图
    fileprivate func setupDanaku() {
        danmakuView.frame = CGRect(x: -UIScreen.width, y: 100, width: UIScreen.width * 2, height: 200)
        containerView.clipsToBounds = true
        containerView.addSubview(danmakuView)
        let config = FXDanmakuConfiguration.default()
        config?.rowHeight = 40
        config?.estimatedRowSpace = 10
        config?.itemInsertOrder = .random
        danmakuView.configuration = config
        danmakuView.delegate = self
        danmakuView.register(DanmakuItem.self, forItemReuseIdentifier: "DanmakuItem")
    }
    
    /// 点击了某个弹幕
    func danmaku(_ danmaku: FXDanmaku, didClick item: FXDanmakuItem, with data: FXDanmakuItemData) {
        
    }
    
    /// 显示弹幕
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

// MARK: GIFT
extension RoomViewController {
    /// 设置礼物列表
    fileprivate func setupGiftView() {
        giftView.frame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: CustomSize.gitftH)
        giftView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        containerView.addSubview(giftView)
        let cover = UIButton(frame: self.view.bounds)
        cover.rx.tap
            .subscribe(onNext: {[weak self] (value) in
                UIView.animate(withDuration: 0.25, animations: {
                    self?.giftView.transform = CGAffineTransform.identity
                }, completion: { _ in
                    cover.removeFromSuperview()
                })
            })
            .disposed(by: self.disposeBag)
        
        bottomView.shopingBtn.rx.tap
            .subscribe(onNext: { [weak self] (value) in
               self?.containerView.insertSubview(cover, belowSubview: self!.giftView)
            })
            .disposed(by: self.disposeBag)
        /// 发送礼物
        giftView.sendGiftAction = { [unowned self] selectedGift in
            if let room = self.roomVM.room {
                let param = GiftRequstParam()
                param.liveId = room.liveId ?? 0
                param.gitftId = selectedGift.gifitId
                param.toId = room.userId
                // MARK: 发送礼物消息
                let myMessage = IMMessage()
                myMessage.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? 0
                myMessage.headPic = CoreDataManager.sharedInstance.getUserInfo()?.avatar
                myMessage.nickName = CoreDataManager.sharedInstance.getUserInfo()?.nickName
                myMessage.msg = selectedGift.toJSONString()
                myMessage.userAction =  selectedGift.gitftType.userAction
                /// 异步请求扣款礼物
                self.roomVM.requestGiveGift(with: param)
                    .then(on: .main, execute: { response -> Void in
                        if response.result ==  .success {
                            self.roomVM.messageHandler.sendMessage(with: myMessage)
                            /// 显示礼物发送动画
                            self.setupGiftAnimation(message: myMessage)
                        }
                    })
                    .catch(execute: { error in
                        if let error = error as? AppError, error.erroCode == .pointUnavailable {
                           self.toRechargeVC()
                        }
                    })
            }
        }
    }
    
    /// 弹出礼物列表
    fileprivate func showGiftView() {
        UIView.animate(withDuration: 0.25) {
             self.giftView.transform = CGAffineTransform(translationX: 0, y: -CustomSize.gitftH)
        }
    }
    
    ///  获取礼物数据
    fileprivate func setupGitftData() {
        roomVM.requestGiftlist()
            .then { [unowned self] giftGroup -> Void in
                guard let list = giftGroup.list else { return }
                 self.giftView.models = list
        }
            .catch { error in
            
        }

    }
    
    /// 设置普通礼物视图
    fileprivate func setupGitAnimateView() {
        gitftAnimateView.backgroundColor = UIColor.clear
        containerView.insertSubview(gitftAnimateView, at: 0)
    }
    
    /// 将礼物消息处理为动画（包括连击动画，和大礼物帧动画）
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
    
    /// 添加大礼物的父视图
    fileprivate func setupBigGiftView() {
        bigGiftView.frame = containerView.bounds
        containerView.insertSubview(bigGiftView, at: 0)
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

/// MARK:TIMER
/// 定时获取房间的一些信息
extension RoomViewController {
    fileprivate func addRealTimer() {
        realTimer?.invalidate()
        realTimer = nil
        realTimer = Timer(timeInterval: 5, target: self, selector: #selector(self.getRealTimerInfo), userInfo: nil, repeats: true)
        RunLoop.main.add(realTimer ?? Timer(), forMode: RunLoopMode.commonModes)

    }
    
    fileprivate  func removeTimer() {
        realTimer?.invalidate()
        realTimer = nil
    }
    
    @objc fileprivate func getRealTimerInfo() {
        if let liveId = roomVM.room?.liveId {
            roomVM.requestRealTime(with: "\(liveId)")
                .then(execute: { [unowned self] (info) -> Void in
                    self.beansCountlabel.text = "\(info.income)"
                    if let users = info.users {
                        self.viewerView.config(Observable.just(users))
                    }
                    self.seecountLabel.text = info.seeingCount
                })
                .catch(execute: { _ in })
        }
    }
}
