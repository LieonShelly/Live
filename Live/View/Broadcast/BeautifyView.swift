//
//  BeautifyView.swift
//  Live
//
//  Created by lieon on 2017/8/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class BeautifyView: UIView {
    var whiteSlider: UISlider!
    var faceSlider: UISlider!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let beautifyWhiteLabel = createLabel()
        beautifyWhiteLabel.text = "美白"
        let beautifyfaceLabel = createLabel()
        beautifyfaceLabel.text = "美颜"
        whiteSlider = createSlider()
        faceSlider = createSlider()
        addSubview(beautifyWhiteLabel)
        addSubview(beautifyfaceLabel)
        addSubview(faceSlider)
        addSubview(whiteSlider)
        
        beautifyfaceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(12)
        }
        faceSlider.snp.makeConstraints { (maker) in
            maker.left.equalTo(beautifyfaceLabel.snp.right).offset(12)
            maker.right.equalTo(-12)
            maker.centerY.equalTo(beautifyfaceLabel.snp.centerY)
        }
        
        beautifyWhiteLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(beautifyfaceLabel.snp.bottom).offset(12)
        }
        whiteSlider.snp.makeConstraints { (maker) in
            maker.left.equalTo(faceSlider.snp.left)
            maker.right.equalTo(faceSlider.snp.right)
            maker.centerY.equalTo(beautifyWhiteLabel.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BeautifyView {
   @objc fileprivate func sliderValueChange(slider: UISlider) {
        
    }
    
    fileprivate func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }
    
    fileprivate func createSlider() -> UISlider {
        let silder = UISlider()
        silder.setThumbImage(UIImage(named: "preogress"), for: .normal)
        silder.setThumbImage(UIImage(named: "preogress"), for: .highlighted)
        silder.minimumTrackTintColor = UIColor(hex: CustomKey.Color.mainColor)
        silder.maximumTrackTintColor = UIColor.lightGray
        return silder
    }
}
