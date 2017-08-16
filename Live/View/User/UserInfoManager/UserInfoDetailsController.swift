//
//  UserInfoDetailsController.swift
//  Live
//
//  Created by fanfans on 2017/7/11.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserInfoDetailsController: BaseViewController {
    var anchorID: Int = 0
    fileprivate lazy var userInfoDetailVM: AnchorViewModel = AnchorViewModel()
    fileprivate lazy var myBroadcastListVM = LiveListViewModel()
    fileprivate lazy var shareView: ShareView = {
        let share = ShareView()
        share.backgroundColor = .white
        share.configApperance(textClor: UIColor.black)
        return share
    }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(MyBroacastCell.self, forCellReuseIdentifier: "MyBroacastCell")
        return taleView
    }()
    
    fileprivate lazy var headerView: UserHeaderView = {
        let headerView = UserHeaderView()
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserData()
        let param = LiveListRequstParam()
        param.page = 0
        param.limit = 20
        LiveListRequstParam.userId = anchorID
        setupData(param: param, isClear: true)
    }
}

extension UserInfoDetailsController {
    fileprivate func setupUI() {
        title = "详情"
        view.addSubview(tableView)
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 150)
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = true
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        tableView.mj_header = FFGifHeader(refreshingBlock: { [unowned self] in
            let param = LiveListRequstParam()
            param.page = 0
            param.limit = 20
            LiveListRequstParam.userId = self.anchorID
            self.setupData(param: param, isClear: true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[unowned self] in
            if self.myBroadcastListVM.lastRequstCount < 20 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let param = LiveListRequstParam()
            param.page = self.myBroadcastListVM.currentPage + 1
            param.limit = 20
            LiveListRequstParam.userId = self.anchorID
            self.setupData(param: param, isClear: false)
        })
        
        headerView.fansLabelTap.rx
            .event
            .subscribe(onNext: { [unowned  self] _ in
                let vc: AttentionAndFansListController = AttentionAndFansListController(type: .fans)
                vc.userID = "\( self.anchorID)"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        headerView.folowsLabelTap.rx
            .event
            .subscribe(onNext: { [unowned  self] _ in
                let vc: AttentionAndFansListController = AttentionAndFansListController(type: .attention)
                vc.userID = "\( self.anchorID)"
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        setupShareView()

    }
    
    fileprivate func loadUserData() {
        userInfoDetailVM.requestAnchorDetail(with: anchorID)
        .then { [weak self] (isSuccess) -> Void in
            guard let weakSelf = self else { return }
            if isSuccess {
                weakSelf.headerView.config(anchor: weakSelf.userInfoDetailVM.anchorInfo)
            }
        }
            .always {
                
        }
        .catch { error in
            
        }
    }
    
    fileprivate func setupData(param: LiveListRequstParam, isClear: Bool) {
        HUD.show(true, show: "", enableUserActions: false, with: self)
        myBroadcastListVM.requestMybroadcastList(with: param, isClear: isClear)
            .then { (isSuccess) -> Void in
                self.setupDataSource(Observable<[LiveListModel]>.just(self.myBroadcastListVM.listGroup.group ?? [LiveListModel]()))
            }
            .always {
                HUD.show(false, show: "", enableUserActions: false, with: self)
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
            .catch { error in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
        }
    }
    
    fileprivate func setupDataSource(_ items: Observable<[LiveListModel]>) {
        items.bind(to: tableView.rx.items(cellIdentifier: "MyBroacastCell", cellType: MyBroacastCell.self)) { (row, element, cell) in
            cell.config(element, isDetailVC: true)
            cell.shareAction = { [unowned self] in
                let cover = UIButton(frame: self.view.bounds)
                cover.backgroundColor = .clear
                self.view.insertSubview(cover, belowSubview: self.shareView)
                UIView.animate(withDuration: 0.25, animations: {
                    let translate = CGAffineTransform.init(translationX: 0, y: -CustomKey.CustomSize.shareViewHight - 70)
                    self.shareView.transform = translate
                })
                cover.rx.tap
                    .subscribe(onNext: { (value) in
                        UIView.animate(withDuration: 0.25, animations: {
                            self.shareView.transform = CGAffineTransform.identity
                        }, completion: { _ in
                            cover.removeFromSuperview()
                        })
                    })
                    .disposed(by: self.disposeBag)
            }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(LiveListModel.self)
            .subscribe(onNext: { [weak self](model) in
                let vcc = PlaybackViewController()
                vcc.video = model
                self?.present(vcc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    fileprivate func setupShareView() {
        shareView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: CustomKey.CustomSize.shareViewHight)
        view.insertSubview(shareView, aboveSubview: tableView)
        
    }

}

extension UserInfoDetailsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
}
