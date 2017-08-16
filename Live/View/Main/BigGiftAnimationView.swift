//
//  BigGiftAnimationView.swift
//  Live
//
//  Created by lieon on 2017/8/1.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

class BigGiftAnimationView: UIView {
    fileprivate lazy var cacheGiftModels: [IMMessage] = [IMMessage]()
    fileprivate var displayingGift: IMMessage?
    fileprivate var displayinID: String?
    fileprivate var nextGiftItem: IMMessage? {
        if let item = self.cacheGiftModels.first {
            cacheGiftModels.remove(at: 0)
            return item
        }
        return nil
    }
    
    func addGift(_ model: IMMessage) {
        if let _ = displayingGift {
            cacheGiftModels.append(model)
        } else {
            playAnimation(with: model)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BigGiftAnimationView: FXAnimationDelegate {
    func fxAnimationDidStart(_ anim: FXAnimation) {
        print("**************fxAnimationDidStart*************")
    }
    
    func fxAnimationDidStop(_ anim: FXAnimation, finished: Bool) {
        if let animationID =  displayinID, animationID == anim.identifier {
            print("**************fxAnimationDidSto:\(animationID)*************")
            guard let aniamation = anim as? FXKeyframeAnimation else { return }
            aniamation.frames?.removeAll()
            aniamation.frames = nil
            layer.removeAnimation(forKey: animationID)
             displayingGift = nil
        }
        if let nextItem = self.nextGiftItem {
            playAnimation(with: nextItem)
        }
        if cacheGiftModels.isEmpty {
            layer.removeAllAnimations()
        }
    }
}
extension BigGiftAnimationView {
    fileprivate func playAnimation(with gift: IMMessage) {
        displayingGift = gift
        guard let msgStr = gift.msg, let gift = Mapper<Gitft>().map(JSONString: msgStr), let name = gift.shortName else {  return  }
        
        displayinID = name
        let animation = FXKeyframeAnimation(identifier: name)
       
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let op1 = BlockOperation {[weak self] in
            animation.delegate = self
            animation.repeats = 1
        }
        op1.addExecutionBlock {
            let images = self.loadAnimateImage(with: name)
            animation.duration = TimeInterval(images.count / 25)
            animation.frames = images
        }
        let op2 = BlockOperation {[weak self] in
           self?.layer.fx_play(animation, asyncDecodeImage: false)
        }
        queue.addOperation(op1)
        queue.addOperation(op2)
    }
    
    fileprivate func loadAnimateImage(with name: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        guard let path = Bundle.main.path(forResource: "BigGift" + "/" + name, ofType: nil), let files = try? FileManager.default.contentsOfDirectory(atPath: path) else { return  [] }
        for i in 0 ... files.count {
            let imagepath = String(format: path + "/" + "\(name)_%05d.png", i)
            if let image = UIImage(contentsOfFile: imagepath) {
                imageArray.append(image)
            }
        }
        return imageArray
    }
}
