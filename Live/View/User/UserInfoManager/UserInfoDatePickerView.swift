//
//  UserInfoDatePickerView.swift
//  Live
//
//  Created by fanfans on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class UserInfoDatePickerView: UIView {
    
    var callBackBlock: ((Int, String) -> Void)?
    var seletcedDateStr: String = ""
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
    
    @objc fileprivate func btnTapAction(btn: UIButton) {
        callBackBlock?(btn.tag, self.seletcedDateStr)
    }
    
    fileprivate lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let todayDate = NSDate()
        datePicker.locale = NSLocale(localeIdentifier: "zh") as Locale
        let maxDate: NSDate = NSDate()
        let minStr: String = "1930-01-01"
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let minDate: Date = dateFormatter.date(from: minStr) {
            datePicker.minimumDate = minDate as Date
        }
        datePicker.maximumDate = todayDate as Date
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action:#selector(self.dateChanged(datePicker:)), for: .valueChanged)
        return datePicker
    }()
    
    @objc fileprivate func dateChanged(datePicker: UIDatePicker) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: datePicker.date))
        self.seletcedDateStr = formatter.string(from: datePicker.date)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(cancelBtn)
        self.addSubview(sureBtn)
        self.addSubview(datePicker)
        
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
        datePicker.snp.makeConstraints { maker in
            maker.bottom.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(cancelBtn.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
