//
//  UserInfoGenderPickerView.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class UserInfoGenderPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    fileprivate let items: [String] = ["女", "男"]
    var callBackBlock: ((Int) -> Void)?
    
    fileprivate lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton()
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor(hex: 0x222222), for: .normal)
        cancelBtn.tag = 0
        cancelBtn.addTarget(self, action: #selector(self.btnTapAction(btn:)), for: .touchUpInside)
        return cancelBtn
    }()
    
    fileprivate lazy var sureBtn: UIButton = {
        let sureBtn = UIButton()
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor(hex: 0x222222), for: .normal)
        sureBtn.tag = 1
        sureBtn.addTarget(self, action: #selector(self.btnTapAction(btn:)), for: .touchUpInside)
        return sureBtn
    }()
    
    fileprivate var slectRow: Int = 0
    
    @objc fileprivate func btnTapAction(btn: UIButton) {
        callBackBlock?(slectRow)
    }
    
    fileprivate lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(cancelBtn)
        self.addSubview(sureBtn)
        self.addSubview(picker)
        
        cancelBtn.snp.makeConstraints { maker in
            maker.left.equalTo(0)
            maker.top.equalTo(0)
            maker.width.equalTo(44)
            maker.height.equalTo(44)
        }
        sureBtn.snp.makeConstraints { maker in
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.width.equalTo(44)
            maker.height.equalTo(44)
        }
        picker.snp.makeConstraints { maker in
            maker.bottom.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(cancelBtn.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        slectRow = row
    }
    
}
