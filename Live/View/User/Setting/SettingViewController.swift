//
//  SettingViewController.swift
//  Live
//
//  Created by fanfans on 2017/7/5.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
     fileprivate lazy  var infoVM = UserInfoManagerViewModel()
    // MARK: lazy
    fileprivate let tipsItems = ["清除缓存", "意见反馈"]
    fileprivate lazy var settingVM: SettingViewModel = SettingViewModel()
    
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView(frame: CGRect(), style: .grouped)
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        taleView.register(SettingModifyAccountCell.self, forCellReuseIdentifier: "SettingModifyAccountCell")
        return taleView
    }()
    fileprivate lazy var logoutBtn: UIButton = {
        let logoutBtn: UIButton = UIButton()
        logoutBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainColor)
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.setTitleColor(UIColor.white, for:.normal)
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutBtn.layer.cornerRadius = 40 * 0.5
        logoutBtn.layer.masksToBounds = true
        logoutBtn.addTarget(self, action: #selector(self.logoutTapAction), for: .touchUpInside)
        return logoutBtn
    }()
    fileprivate lazy var copyrightLable: UILabel = {
        let copyrightLable: UILabel = UILabel()
        copyrightLable.text = "Copyright © 2017"
        copyrightLable.textAlignment = .center
        copyrightLable.textColor = UIColor(hex: 0x222222)
        copyrightLable.font = UIFont.systemFont(ofSize: 10)
        return copyrightLable
    }()
    fileprivate lazy var companyLable: UILabel = {
        let companyLable: UILabel = UILabel()
        companyLable.text = "成都欢乐汇电子商务有限公司"
        companyLable.textAlignment = .center
        companyLable.textColor = UIColor(hex: 0x222222)
        companyLable.font = UIFont.systemFont(ofSize: 10)
        return companyLable
    }()
    fileprivate lazy var versionLable: UILabel = {
        let companyLable: UILabel = UILabel()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        companyLable.text = appVersion ?? ""
        companyLable.textAlignment = .center
        companyLable.textColor = UIColor(hex: 0x222222)
        companyLable.font = UIFont.systemFont(ofSize: 10)
        return companyLable
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0xfafafa)
        self.title = "设置"
        
        view.addSubview(tableView)
        view.addSubview(logoutBtn)
        view.addSubview(copyrightLable)
        view.addSubview(companyLable)
        view.addSubview(versionLable)
        
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(190)
        }
        logoutBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(tableView.snp.bottom) .offset(55)
            maker.left.equalTo(35)
            maker.right.equalTo(-35)
            maker.height.equalTo(40)
        }
        copyrightLable.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(-60)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
        companyLable.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(-40)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
        
        versionLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(companyLable.snp.bottom).offset(10)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserInfo()
    }
    
    fileprivate func loadUserInfo() {
        infoVM.requstUserInfo()
            .then {[unowned self] (_) -> Void in
                self.tableView.reloadData()
            }
            .catch {[unowned self] error  in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
        }
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SettingModifyAccountCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            if let imgURL = URL(string: CustomKey.URLKey.baseImageUrl + (infoVM.userInfo?.avatar ?? "")) {
                cell.avatar.kf.setImage(with: imgURL, placeholder: UIImage(named: "placeholderImage_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell.phoneLable.text = infoVM.userInfo?.phone ?? ""
            return cell
        }
        let cell: SettingCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.tipLable.text = tipsItems[indexPath.row]
        if indexPath.section == 1 &&  indexPath.row == 0 {
            cell.rightLable.isHidden = false
            let uqure = DispatchQueue.main
            uqure.async {
               cell.rightLable.text = Utils.getCacheSize()
            }
        } else {
            cell.rightLable.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 75 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = FeedbackController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            DispatchQueue.global(qos: .userInitiated).async {
                Utils.clearFile()
                let uqure = DispatchQueue.main
                uqure.sync {
                    self.view.makeToast("清除缓存成功")
                    self.tableView.reloadRows(at: [NSIndexPath(row: 0, section: 1) as IndexPath], with: .automatic)
                }
            }
            return
        }
        if indexPath.section == 0 {
            let vc = AccountBindedViewController()
            guard let phoneNum = infoVM.userInfo?.phone else {
                return
            }
            vc.phoneNum = phoneNum
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ?  10 : 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    @objc fileprivate  func logoutTapAction() {
        HUD.show(true, show: "", enableUserActions: false, with: self)
        settingVM.logout()
            .then { [unowned self] isSuccess -> Void in
                if isSuccess {
                    let rootVC = NavigationController(rootViewController: LoginViewController())
                    UIView.transition(with: self.view, duration: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self.view.removeFromSuperview()
                        UIApplication.shared.keyWindow?.addSubview(rootVC.view)
                    }, completion: { (_) in
                        UIApplication.shared.keyWindow?.rootViewController = rootVC
                    })
                }
            }
            .always {
                HUD.show(false, show: "", enableUserActions: false, with: self)
            }.catch { [unowned self ] error in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
            }
        }
    }
}
