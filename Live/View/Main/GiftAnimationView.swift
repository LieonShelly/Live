//
//  GiftAnimationView.swift
//  Live
//
//  Created by lieon on 2017/7/25.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import ObjectMapper

enum GiftComboState: Int {
    case unknown = 0
    case idle = 1
    case animating = 2
    case waiting = 3
    case ending = 4
}

class GiftConatainerView: UIView {
    fileprivate var galleryRoadNum = 2
    fileprivate lazy var comboViews: [GiftComboView] = [GiftComboView]()
    fileprivate lazy var cacheGiftModels: [IMMessage] = [IMMessage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    fileprivate func setupUI() {
        let viewW: CGFloat = self.bounds.width
        let viewH: CGFloat = 40
        let viewX = 0
        for i in 0 ..< galleryRoadNum {
            let viewY: CGFloat = (viewH + 10) * CGFloat(i)
            let comboView = GiftComboView()
            comboView.frame = CGRect(x: CGFloat(viewX), y: viewY, width: viewW, height: viewH)
            comboView.alpha = 0.0
            comboView.backgroundColor = UIColor.clear
            addSubview(comboView)
            comboViews.append(comboView)
            weak var weaksSelf = self
            guard let weakSelf = weaksSelf else {
                return
            }
            comboView.animateCallback = { comboView in
                if weakSelf.cacheGiftModels.isEmpty {
                    return
                }
                var cacheNumber: Int = 0
                guard let firstModel = weakSelf.cacheGiftModels.first else { return }
                guard let firstmsgStr = firstModel.msg, let firstGift = Mapper<Gitft>().map(JSONString: firstmsgStr) else { return }
                weakSelf.cacheGiftModels.remove(at: 0)
                for (index, model) in weakSelf.cacheGiftModels.enumerated() {
                    guard  let currentMmsgStr = model.msg, let currentGift = Mapper<Gitft>().map(JSONString: currentMmsgStr) else {
                        continue
                    }
                    
                    if (currentGift.gifitId == firstGift.gifitId) && (index < weakSelf.cacheGiftModels.count) {
                        cacheNumber += 1
                        weakSelf.cacheGiftModels.remove(at: index)
                    }
                }
                comboView.cacheNum = cacheNumber
                comboView.config(firstModel)
            }
        }
    }
    
    func addGift(_ model: IMMessage) {
        if let comboView = checkOutSameGift(model) {
            comboView.addOnceAnimationToCache()
            return
        }
        
        if let comboView = checkoutIdleComboView() {
            comboView.config(model)
            return
        }
        cacheGiftModels.append(model)
    }
    
    private func checkOutSameGift(_ model: IMMessage) -> GiftComboView? {
        for comboView in comboViews {
            guard let currentModel = comboView.animateModel, let currentMmsgStr = currentModel.msg, let currentGift = Mapper<Gitft>().map(JSONString: currentMmsgStr) else {
                return nil
            }
            guard let msgStr = model.msg, let sendGift = Mapper<Gitft>().map(JSONString: msgStr) else {
                return nil
            }
            if currentGift.gifitId == sendGift.gifitId, currentGift.gifitId != 0, sendGift.gifitId != 0, model.userId == currentModel.userId, model.userId != 0 {
                return comboView
            }
        }
        return nil
        
    }
    
    private func checkoutIdleComboView() -> GiftComboView? {
        for comboView in comboViews {
            if comboView.state == .idle {
                return comboView
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CountLabel: UILabel {
    override func draw(_ rect: CGRect) {
//        guard  let ctx = UIGraphicsGetCurrentContext() else { return }
//        ctx.setTextDrawingMode(.stroke)
//        ctx.setLineWidth(5)
//        ctx.setLineCap(.round)
//        ctx.setLineJoin(.round)
////        textColor = UIColor(red: 0, green: 216 / 250.0, blue: 201 / 255.0, alpha: 1)
//        super.draw(rect)
//        ctx.setTextDrawingMode(.fill)
//        ctx.setLineWidth(2.0)
        textColor = UIColor(hex: 0xe85efc)
        super.draw(rect)
    }
    
    func startAniamtion(callback: @escaping (() -> Void) ) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIViewKeyframeAnimationOptions.init(rawValue: 0), animations: { 
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: { 
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4, animations: {
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.5, animations: {
                self.transform = CGAffineTransform.identity
            })
        }) { (_) in
            callback()
        }
    }
}

class GiftComboView: UIView {
    var state: GiftComboState = .idle
    var cacheNum: Int = 0
    var animateCallback: ((GiftComboView) -> Void)?
    var animateModel: IMMessage?
    
    fileprivate var currentNum: Int = 0
    fileprivate lazy var iconView: UIImageView = UIImageView()
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .left
        label.textColor = UIColor.white
        return label
    }()
    fileprivate lazy var giftNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor(hex: CustomKey.Color.mainColor)
        return label
    }()
    
    fileprivate lazy var giftCountLabel: CountLabel = {
        let label = CountLabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 27)
        label.textAlignment = .left
        label.textColor = UIColor(hex: CustomKey.Color.mainColor)
        return label
    }()
    fileprivate lazy var giftIconView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bg = UIView()
        bg.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        addSubview(bg)
        bg.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(-30)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
        }
        bg.addSubview(iconView)
        iconView.snp.makeConstraints { (maker) in
            maker.left.equalTo(2.5)
            maker.width.equalTo(34)
            maker.height.equalTo(34)
            maker.centerY.equalTo(bg.snp.centerY)
        }
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 17
        iconView.layer.masksToBounds = true
        
        bg.layer.cornerRadius = 20
        bg.layer.masksToBounds = true
        
        bg.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(iconView.snp.right).offset(9)
            maker.top.equalTo(iconView.snp.top).offset(3)
        }
        
        bg.addSubview(giftNameLabel)
        giftNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.top.equalTo(nameLabel.snp.bottom).offset(3)
        }
        addSubview(giftIconView)
        giftIconView.clipsToBounds = true
        giftIconView.snp.makeConstraints { (maker) in
            maker.left.equalTo(bg.snp.right).offset(-10)
            maker.centerY.equalTo(bg)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
        addSubview(giftCountLabel)
        giftCountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(bg.snp.right).offset(40)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GiftComboView {
    func config(_ model: IMMessage) {
        guard let msgStr = model.msg, let gift = Mapper<Gitft>().map(JSONString: msgStr) else {
            return
        }
        animateModel = model
        if let urlicon = URL(string: CustomKey.URLKey.baseImageUrl + (model.headPic ?? "")), let gitftURL = URL(string: CustomKey.URLKey.baseImageUrl + (gift.picture ?? "")) {
            iconView.kf.setImage(with: urlicon)
            nameLabel.text = model.nickName ?? ""
            giftNameLabel.text = "送出礼物【\(gift.name ?? "")】"
            giftIconView.kf.setImage(with: gitftURL)
            performShowAnimation()
        }
    }
    
    func performShowAnimation() {
        state = .animating
        UIView.animate(withDuration: 0.25, animations: { 
                self.frame.origin.x = 0
                self.alpha = 1.0
        }) { (_) in
            self.giftCountLabel.alpha = 1.0
            self.performGiftCountLabelAnimation()
        }
    }
    
    func addOnceAnimationToCache() {
        if state == .animating {
            cacheNum += 1
        } else if state == .waiting {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            performGiftCountLabelAnimation()
        } else if state == .idle {
            print("IDLe")
            performShowAnimation()
        } else if state == .ending {
            print("ending")
        } else {
            print("None")
        }
    }
  @objc  private func perFormDismissAnimationi() {
        state = .ending
        UIView.animate(withDuration: 0.25, animations: { 
            self.frame.origin.x = UIScreen.width
            self.alpha = 0.0
        }) { (_) in
            self.currentNum = 0
            self.giftCountLabel.alpha = 0.0
            self.frame.origin.x = -UIScreen.width
            self.state = .idle
            self.animateCallback?(self)
        }
    }
    
    private func performGiftCountLabelAnimation() {
        currentNum += 1
        giftCountLabel.text = "x" + "\(currentNum)"
        giftCountLabel.startAniamtion { 
            if self.cacheNum > 0 {
                self.cacheNum -= 1
                self.performGiftCountLabelAnimation()
            } else {
                self.perform(#selector(self.perFormDismissAnimationi), with: nil, afterDelay: 3.0)
                self.state = .waiting
            }
        }
    }
}
