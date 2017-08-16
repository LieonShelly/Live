//
//  RealInfoCommitController.swift
//  Live
//
//  Created by fanfans on 2017/7/5.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//  swiftlint:disable force_unwrapping

import UIKit
import RxSwift
import RxCocoa

class RealInfoCommitController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    // MARK: lazy
    fileprivate lazy var helpBtn: UIButton = {
        let helpBtn = UIButton()
        helpBtn.frame = CGRect(x:UIScreen.width - 44, y: 20, width: 44, height: 44)
        helpBtn.setTitle("帮助", for: .normal)
        helpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        helpBtn.setTitleColor(UIColor.white, for: .normal)
        helpBtn.addTarget(self, action: #selector(self.helpTapAction), for: .touchUpInside)
        return helpBtn
    }()
     fileprivate  lazy  var param = IDVlidateRequestParam()
    fileprivate lazy var tipsItems = ["真实姓名", "身份证号"]
    fileprivate lazy var placehoderItems = ["请输入您的真实姓名", "请输入您的身份证号"]
    fileprivate lazy var infoItems = ["", ""]
    fileprivate lazy var approveVM: UserInfoManagerViewModel = UserInfoManagerViewModel()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView(frame: CGRect(), style: .grouped)
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor.white
        taleView.register(RealInfoCommitCell.self, forCellReuseIdentifier: "RealInfoCommitCell")
        return taleView
    }()
    
    fileprivate lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 40))
        headerView.backgroundColor = UIColor(hex: 0xfbe7ca)
        let tipsLable: UILabel = UILabel(frame: CGRect(x: 30, y: 0, width: UIScreen.width - 30, height: 40))
        tipsLable.text = "以下信息均为必填项，为了确保您的权益，请如实填写"
        tipsLable.textColor = UIColor(hex: 0x999999)
        tipsLable.font = UIFont.systemFont(ofSize: 13)
        tipsLable.textAlignment = .left
        headerView.addSubview(tipsLable)
        return headerView
    }()
    fileprivate lazy var commitBtn: UIButton = {
        let commitBtn: UIButton = UIButton()
        commitBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        commitBtn.setTitle("提交", for: .normal)
        commitBtn.setTitleColor(UIColor.white, for:.normal)
        commitBtn.setTitleColor(UIColor.gray, for:.highlighted)
         commitBtn.setTitleColor(UIColor.red, for:.disabled)
        commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        commitBtn.layer.cornerRadius = 40 * 0.5
        commitBtn.layer.masksToBounds = true
        return commitBtn
    }()
    
    fileprivate lazy var serverLable: UILabel = {
        let serverLable: UILabel = UILabel()
        serverLable.text = "认证出现问题了？客服热线400-189-0090"
        serverLable.textColor = UIColor(hex: 0x999999)
        serverLable.font = UIFont.systemFont(ofSize: 12)
        serverLable.textAlignment = .center
        serverLable.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.callServer))
        serverLable.addGestureRecognizer(tap)
        return serverLable
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0xfafafa)
        self.title = "实名认证"
        let rightBtnItem = UIBarButtonItem(customView: helpBtn)
        navigationItem.rightBarButtonItem = rightBtnItem
        
        view.addSubview(tableView)
        view.addSubview(headerView)
        view.addSubview(commitBtn)
        view.addSubview(serverLable)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 40)
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(140)
        }
        commitBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(tableView.snp.bottom) .offset(55)
            maker.left.equalTo(35)
            maker.right.equalTo(-35)
            maker.height.equalTo(40)
        }
        serverLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(commitBtn.snp.bottom) .offset(10)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(25)
        }
        
        commitBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                HUD.show(true, show: "", enableUserActions: false, with: self)
                self?.approveVM.requstIDValid(with: self?.param ?? IDVlidateRequestParam())
                    .then(execute: { value -> Void in
                        if value.result == .success {
                            self?.view.makeToast("提交成功")
                            self?.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                    .always {
                        HUD.show(false, show: "", enableUserActions: false, with: self)
                    }
                    .catch(execute: { (error) in
                        if let error = error as? AppError {
                            self?.view.makeToast(error.message)
                        }
                    })
                
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RealInfoCommitCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.tipLable.text = tipsItems[indexPath.row]
        cell.inputTextFiled.placeholder = placehoderItems[indexPath.row]
        cell.inputTextFiled.text = infoItems[indexPath.row]
        cell.inputTextFiled.delegate = self
        cell.inputTextFiled.tag = indexPath.row
        cell.inputTextFiled.returnKeyType = .done
        cell.selectionStyle = .none
        
        cell.inputTextFiled.rx.text
            .orEmpty
        .map { $0 }
        .shareReplay(1)
        .subscribe(onNext: { (text) in
            if indexPath.row == 0 {
                self.param.trueName = text
            }
            if indexPath.row == 1 {
                self.param.idCardNumber = text
            }
         })
        .disposed(by: disposeBag)
        
        if indexPath.row == 1 {
              cell.inputTextFiled.rx.text.orEmpty
                .map { (text) -> String in
                    return text.characters.count <= 18 ? text: text.substring(to: "012345678901234567".endIndex)
                }
                .shareReplay(1)
                .bind(to: cell.inputTextFiled.rx.text)
                .disposed(by: disposeBag)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK: call server
    @objc fileprivate func callServer() {
        let str: String = "telprompt://400-189-0090"
        if UIApplication.shared.canOpenURL(URL(string: str)!) {
            UIApplication.shared.openURL(URL(string: str)!)
        }
    }
    
    // MARK: helpTapAction
    @objc fileprivate  func helpTapAction() {
     let webVC = WebPageController(urlStr: "https://cdn.hlhdj.cn/static/live/approve/help.html", navTitle: "")
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}
