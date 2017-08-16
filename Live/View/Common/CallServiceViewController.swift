//
//  CallServiceViewController.swift
//  Live
//
//  Created by lieon on 2017/6/26.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable empty_parameters

import UIKit

class CallServiceViewController: UIViewController {
    var enterAction: ((Void) -> Void)?
    var cancelAction: ((Void) -> Void)?
    lazy var enterBtn: UIButton = {
        let enterBtn = UIButton()
        enterBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        enterBtn.titleLabel?.textAlignment = .center
        enterBtn.setTitleColor(UIColor.white, for: .normal)
        enterBtn.setTitleColor(UIColor.gray, for: .highlighted)
        enterBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(15))
        enterBtn.addTarget(self, action: #selector(self.enterTapAction), for: .touchUpInside)
        
        return enterBtn
    }()
     lazy  var cancelBtn: UIButton = {
        let cancelBtn = UIButton()
        cancelBtn.backgroundColor = UIColor.white
        cancelBtn.titleLabel?.textAlignment = .center
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.setTitleColor(UIColor.darkGray, for: .highlighted)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(15))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(self.cancleTapAction), for: .touchUpInside)
        return cancelBtn
    }()
    fileprivate lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(hex: 0xe5e5e5)
        return line
    }()
    
    fileprivate lazy var subTielabel: UILabel = {
        let subTielabel = UILabel()
        subTielabel.backgroundColor = UIColor.white
        subTielabel.font = UIFont.systemFont(ofSize: CGFloat(15))
        subTielabel.numberOfLines = 0
        subTielabel.textAlignment = .center
        subTielabel.textColor = UIColor.black
        return subTielabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(enterBtn)
        view.addSubview(subTielabel)
        view.addSubview(cancelBtn)
        view.addSubview(line)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        enterBtn.frame = CGRect(x: CGFloat(0), y: CGFloat(view.bounds.size.height - 44), width: CGFloat(view.bounds.size.width * 0.5), height: CGFloat(44))
        cancelBtn.frame = CGRect(x: CGFloat(view.bounds.size.width - view.bounds.size.width * 0.5), y: CGFloat(view.bounds.size.height - 44), width: CGFloat(view.bounds.size.width * 0.5), height: CGFloat(44))
        line.frame = CGRect(x: CGFloat(0), y: CGFloat(view.bounds.size.height - 44 - 0.5), width: CGFloat(view.bounds.size.width), height: CGFloat(0.5))
        subTielabel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.bounds.size.width), height: CGFloat(view.bounds.size.height - 44 - 0.5))
    }

    func configMsg(_ msg: String, withEnterTitle enterTitle: String) {
        enterBtn.setTitle(enterTitle, for: .normal)
        subTielabel.text = msg
    }
    
    func configMsg(_ msg: String, withEnterTitle enterTitle: String, cancelTitle: String) {
        enterBtn.setTitle(enterTitle, for: .normal)
        cancelBtn.setTitle(cancelTitle, for: .normal)
        subTielabel.text = msg
    }

  @objc fileprivate  func enterTapAction() {
        dismiss(animated: true, completion: { _ in })
        if let action = enterAction {
            action()
        }
    }
    
 @objc fileprivate  func cancleTapAction() {
        dismiss(animated: true, completion: { _ in })
        if  let action = cancelAction {
            action()
        }
    }

}
