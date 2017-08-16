//
//  WithdrawDepositToAliPayController.swift
//  Live
//
//  Created by fanfans on 2017/7/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
// swiftlint:disable force_unwrapping

import UIKit
import IQKeyboardManagerSwift
import PromiseKit

class WithdrawDepositToAliPayController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate var param: ApplyPickUpParam = ApplyPickUpParam()
    fileprivate var erarningsVM: EarningsViewModel = EarningsViewModel()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView(frame: CGRect(), style: .plain)
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(WithdrawDepositAmountInputCell.self, forCellReuseIdentifier: "WithdrawDepositAmountInputCell")
        taleView.register(WithdrawDepositInputInfoCell.self, forCellReuseIdentifier: "WithdrawDepositInputInfoCell")
        taleView.register(WithdrawDepositAuthCodeCell.self, forCellReuseIdentifier: "WithdrawDepositAuthCodeCell")
        return taleView
    }()
    fileprivate lazy var sureBtn: UIButton = {
        let sureBtn: UIButton = UIButton(frame: CGRect(x: (UIScreen.width - 300) * 0.5, y: 30, width: 300, height: 40))
        sureBtn.layer.cornerRadius = 40 * 0.5
        sureBtn.layer.masksToBounds = true
        sureBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        sureBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        sureBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        sureBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sureBtn.setTitle("确认退款", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.addTarget(self, action: #selector(self.sureTapAction), for: .touchUpInside)
        sureBtn.isEnabled = false
        return sureBtn
    }()
    fileprivate lazy var footView: UIView = {
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 100))
        footView.backgroundColor = UIColor(hex: 0xfafafa)
        footView.addSubview(self.sureBtn)
        return footView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enableAutoToolbar = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0xfafafa)
        self.title = "提现到支付宝"
        
        view.addSubview(tableView)
        tableView.tableFooterView = footView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        erarningsVM.requestPicupInitialInfo()
        .then { (response) -> Void in
            if let info = response.object {
                self.erarningsVM.pickUpInitial = info
                self.tableView.reloadData()
            }
        }
        .catch { error in
            
        }
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
            .subscribe(onNext: { (note) in
                if  let begin = note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect, let end =  note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                    if begin.size.height > 0 && begin.origin.y - end.origin.y > 0 {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.tableView.contentOffset = CGPoint(x: 0, y: 45)
                        })
                    }
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
            .subscribe(onNext: { (note) in
                if  let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                    print(duration)
                    UIView.animate(withDuration: duration, animations: {
                        self.tableView.contentOffset = CGPoint(x: 0, y: 0)
                    })
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: WithdrawDepositAmountInputCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.amountTF.keyboardType = .numberPad
            cell.amountTF.placeholder = "最少" + "\(String(describing: erarningsVM.pickUpInitial?.pickupFloor ?? "100"))"
            cell.amountTF.rx.text.orEmpty
                .map {$0}
                .subscribe(onNext: { (text) in
                    self.param.pickupMoney = text
                })
                .disposed(by: disposeBag)
            return cell
        }
        if indexPath.section == 1 {
            let cell: WithdrawDepositInputInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.tipsLable.text = indexPath.row == 0 ? "支付宝账号" : "姓名"
            cell.inputTF.placeholder = indexPath.row == 0 ? "请输入支付宝账号" : "请输入真实姓名"
            if indexPath.row == 0 {
                cell.inputTF.rx.text.orEmpty
                    .map {$0}
                    .subscribe(onNext: { (text) in
                        self.param.payeeAccount = text
                    })
                .disposed(by: disposeBag)
            }
            
            if indexPath.row == 1 {
                cell.inputTF.rx.text.orEmpty
                    .map {$0}
                    .subscribe(onNext: { (text) in
                        self.param.realName = text
                    })
                    .disposed(by: disposeBag)
            }
            return cell
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell: WithdrawDepositInputInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.selectionStyle = .none
                cell.tipsLable.text = "手机号"
                cell.inputTF.placeholder = "请输入手机号码"
                cell.isUserInteractionEnabled = false
                cell.inputTF.text = CoreDataManager.sharedInstance.getUserInfo()?.phone ?? "0"
                if let phone = cell.inputTF.text {
                     self.param.mobile = phone
                }
                return cell
            } else {
                let cell: WithdrawDepositAuthCodeCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                   cell.inputTF.rx.text.orEmpty
                        .map {$0}
                        .subscribe(onNext: { (text) in
                            self.param.code = text
                        })
                        .disposed(by: disposeBag)

                cell.inputTF.rx.text.orEmpty
                    .map { text -> Bool in
                        return (!text.isEmpty && !(self.param.mobile ?? "").isEmpty && !( self.param.payeeAccount ?? "").isEmpty && !(self.param.realName ?? "").isEmpty && !(self.param.pickupMoney ?? "").isEmpty)
                        }
                    .shareReplay(1)
                    .bind(to: sureBtn.rx.isEnabled)
                    .disposed(by: disposeBag)
                cell.selectionStyle = .none
                cell.getverifiedCodeAction = { [unowned self] in
                    let userVM = UserSessionViewModel()
                    userVM.sendCaptcha(phoneNum: CoreDataManager.sharedInstance.getUserInfo()?.phone ?? "0", type: .livePickupCash)
                    .then(execute: { _ -> Void in
                         cell.authCodeBtn.start(withTime: 120, title: "获取验证码", countDownTitle: "S后重发", mainColor: self.view.backgroundColor!, count: self.view.backgroundColor!)
                    })
                    .catch(execute: { (error) in
                        if let error = error as? AppError {
                            self.view.makeToast(error.message)
                        }
                    })
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 60 : 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 2 ?  0.1 : 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            return UIView()
        }
        let sectionView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 35))
        sectionView.backgroundColor = UIColor(hex: 0xfafafa)
        let tipsLable: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.width - 12, height: 35))
        tipsLable.text = section == 0 ? "今日可提现\((erarningsVM.pickUpInitial?.money ?? "0"))元" : "支付宝账号和姓名不匹配会提现失败"
        tipsLable.font = UIFont.systemFont(ofSize: 12)
        tipsLable.textColor = UIColor(hex:0x222222)
        tipsLable.textAlignment = .right
        sectionView.addSubview(tipsLable)
        return sectionView
    }
    
    // MARK: btnAction
    @objc fileprivate  func sureTapAction() {
        let userVM = UserSessionViewModel()
        let smsParam = SmsCaptchaParam()
        smsParam.code = param.code
        smsParam.phone = param.mobile
        smsParam.type = .livePickupCash
        userVM.checkCaptcha(param: smsParam)
        .then { (isSuccess) -> Promise<NullDataResponse> in
           return  self.erarningsVM.requestApplyPickUp(with: self.param)
        }.then {[weak self] (response) -> Void in
            if response.result == .success {
                self?.navigationController?.pushViewController(WithdrawDepositSucceedController(), animated: true)
            }
        }
        .catch { (error) in
            if let error = error as? AppError {
                self.view.makeToast(error.message)
            }
        }
    }
}
