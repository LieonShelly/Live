//
//  PlaybackBottomView.swift
//  Live
//
//  Created by lieon on 2017/7/8.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlaybackBottomView: UIView {
      var playAction: ((UIButton) -> Void)?
      var onSeeckAction: ((UISlider) -> Void)?
      var onSeekBeginAction: ((UISlider) -> Void)?
      var onDragAction: ((UISlider) -> Void)?
    
    fileprivate let disposeBag = DisposeBag()
    lazy var playBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.setImage(UIImage(named: "pause"), for: .highlighted)
        btn.setImage(UIImage(named: "pause"), for: .selected)
        return btn
    }()
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "0:00/0:00"
        return label
    }()
    
    lazy var slider: UISlider = {
        let view = UISlider()
        view.setThumbImage(UIImage(named: "preogress"), for: .normal)
        view.setThumbImage(UIImage(named: "preogress"), for: .highlighted)
        view.minimumTrackTintColor = UIColor.white.withAlphaComponent(0.5)
        view.maximumTrackTintColor = UIColor.white
        return view
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "play_share"), for: .normal)
        btn.setImage(UIImage(named: "play_share"), for: .highlighted)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playBtn)
        addSubview(timeLabel)
        addSubview(shareBtn)
        addSubview(slider)
        playBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(self.snp.centerY)
        }
        
        shareBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.centerY.equalTo(playBtn.snp.centerY)
        }
        
        slider.snp.makeConstraints { (maker) in
            maker.left.equalTo(playBtn.snp.right).offset(12)
            maker.centerY.equalTo(playBtn.snp.centerY)
            maker.right.equalTo(shareBtn.snp.left).offset(-12)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(slider.snp.right)
            maker.top.equalTo(slider.snp.bottom).offset(-2)
        }
        
        slider.addTarget(self, action: #selector(self.onSeek(slider:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(self.onSeekBegin(slider:)), for: .touchDown)
        slider.addTarget(self, action: #selector(self.onDrag(slider:)), for: .touchDragInside)
        playBtn.addTarget(self, action: #selector(self.play(btn:)), for: .touchUpInside)
    }
    
    func setup(progress: Float, duration: Float) {
        slider.maximumValue = duration
        slider.setValue(progress, animated: false)
        timeLabel.text = String(format: "%02d:%02d", Int(progress / 60.0), Int(progress.truncatingRemainder(dividingBy: 60.0))) + "/" + String(format: "%02d:%02d", Int(duration / 60.0), Int(duration.truncatingRemainder(dividingBy: 60.0)))
    }
    
    func setup(displayTime: Float) {
        timeLabel.text = String(format: "%02d:%02d", Int(displayTime / 60.0), Int(displayTime.truncatingRemainder(dividingBy: 60.0))) + "/" + String(format: "%02d:%02d", Int(slider.maximumValue  / 60.0), Int(slider.maximumValue .truncatingRemainder(dividingBy: 60.0)))
    }
    
   @objc fileprivate func onSeek(slider: UISlider) {
            onSeeckAction?(slider)
    }
    
   @objc fileprivate func onSeekBegin(slider: UISlider) {
            onSeekBeginAction?(slider)
    }
    
   @objc fileprivate func onDrag(slider: UISlider) {
         onDragAction?(slider)
    }
    
    @objc fileprivate func play(btn: UIButton) {
        playAction?(btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
