//
//  UserViewController.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserViewController: BaseViewController, UITableViewDelegate {
    fileprivate lazy  var infoVM = UserInfoManagerViewModel()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(RightArrowCell.self, forCellReuseIdentifier: "RightArrowCell")
          taleView.register(RightSubTileCell.self, forCellReuseIdentifier: "RightSubTileCell")
        return taleView
    }()
    
    fileprivate lazy var headerView: UserHeaderView = {
        let headerView = UserHeaderView()
        return headerView
    }()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           loadUserInfo()
    }
}

extension UserViewController {
    fileprivate func loadUserInfo() {
        infoVM.requstUserInfo()
            .then {[unowned self] (_) -> Void in
              self.headerView.config(user: self.infoVM.userInfo)
                self.tableView.reloadData()
            }
            .catch {[unowned self] error  in
            if let error = error as? AppError {
                self.view.makeToast(error.message)
            }
        }
    }
    
    fileprivate func setupUI() {
        title = "我的"
        view.addSubview(tableView)
        view.addSubview(headerView)
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 150)
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = true

        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
    }
    
    fileprivate func setupAction() {
    let items = setupItems()
        items.bind(to: tableView.rx.items) {(tableView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
            if row == 2 {
                let cell: RightSubTileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.config(title: element.title ?? "", subtitle: String((CoreDataManager.sharedInstance.getUserInfo()?.point ?? 0)) + "哆豆")
                return cell
            } else if row == 3, let userInfo = self.infoVM.userInfo, userInfo.isApprove {
                let cell: RightSubTileCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.config(title: element.title ?? "", subtitle: userInfo.trueName ?? "")
                return cell
            } else {
                 let cell: RightArrowCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                    cell.config(text: element.title ?? "")
                return cell
            }
        }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(UserHome.self)
            .subscribe(onNext: { value in
                value.handle?()
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return indexPath
            }
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        headerView.iconTap.rx
            .event
            .subscribe(onNext: { [unowned  self] _ in
                self.pushInfoVC()
            })
            .disposed(by: disposeBag)
        
        headerView.nameLabelTap.rx
            .event
            .subscribe(onNext: { [unowned  self] _ in
                self.pushInfoVC()
            })
            .disposed(by: disposeBag)
        
        headerView.fansLabelTap.rx
            .event
            .subscribe(onNext: { [unowned  self] _ in
                let vc: AttentionAndFansListController = AttentionAndFansListController(type: .fans)
                vc.userID = "\(self.infoVM.userInfo?.userId ?? 0)"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        headerView.folowsLabelTap.rx
            .event
            .subscribe(onNext: { [unowned  self] _ in
                let vc: AttentionAndFansListController = AttentionAndFansListController(type: .attention)
                 vc.userID = "\(self.infoVM.userInfo?.userId ?? 0)"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func pushInfoVC() {
        let userInfoVC = UserInfoManagerController()
        userInfoVC.param.avatar = self.infoVM.userInfo?.avatar
        userInfoVC.param.nickName = self.infoVM.userInfo?.nickName
        userInfoVC.param.sex = (self.infoVM.userInfo?.gender) ?? .unknown
        userInfoVC.param.birthday = self.infoVM.userInfo?.birthday
        userInfoVC.backTopAction = {
            userInfoVC.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    private func setupItems() -> Observable<[UserHome]> {
        let broadcast = UserHome(title: "我的直播") { [unowned self] in
            let vc = MyBroadcastVC()
            guard let uesrId = self.infoVM.userInfo?.userId else { return }
            vc.userId = uesrId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let earnings = UserHome(title: "我的收益") {
            // WithdrawDepositSucceedController
              self.navigationController?.pushViewController(EarningsController(), animated: true)
        }
        let balance = UserHome(title: "余额") {
            self.navigationController?.pushViewController(RechargeController(), animated: true)
        }
//        let level = UserHome(title: "等级特权") {
//            
//        }
        let verfied = UserHome(title: "实名认证") {
            let vc = RealNameAuthController()
           if let userInfo = self.infoVM.userInfo, !userInfo.isApprove {
            self.navigationController?.pushViewController(vc, animated: true)
           } else {
                self.view.makeToast("您已实名认证")
            }
        }
        let accountSafe = UserHome(title: "账户安全") {
            let token = UserSessionInfo.getSession().token ?? ""
            let webVC = WebPageController(urlStr: "\(CustomKey.URLKey.baseURL)/live/safe/index?token=" + token, navTitle: "")
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        let setting = UserHome(title: "设置") {
            let vc = SettingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let items = Observable<[UserHome]>.just([broadcast, earnings, balance, verfied, accountSafe, setting])
        return items
    }
}

extension UserViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
