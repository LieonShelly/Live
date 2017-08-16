//
//  MyBroadcastVC.swift
//  Live
//
//  Created by lieon on 2017/7/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PromiseKit

class MyBroadcastVC: BaseViewController {
    var userId: Int = 0
    fileprivate lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    fileprivate lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "gou")
        return icon
    }()
    fileprivate lazy var tipsLable: UILabel = {
        let tipsLable = UILabel()
        tipsLable.text = "你还没有直播哦，快来加入我们吧"
        tipsLable.font = UIFont.systemFont(ofSize: 13)
        tipsLable.textAlignment = .center
        tipsLable.textColor = UIColor(hex: 0x999999)
        return tipsLable
    }()
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
        taleView.backgroundColor = UIColor(hex: 0xf2f2f2)
        taleView.register(MyBroacastCell.self, forCellReuseIdentifier: "MyBroacastCell")
        return taleView
    }()
    fileprivate lazy var startBtn: UIButton = {
        let startBtn = UIButton()
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        startBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        startBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        startBtn.setTitle("开始直播", for: .normal)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .disabled)
        startBtn.layer.cornerRadius = 22
        startBtn.layer.masksToBounds = true
        return startBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}

extension MyBroadcastVC {
    fileprivate func loadData() {
        let param = LiveListRequstParam()
        param.page = 0
        param.limit = 20
        LiveListRequstParam.userId = self.userId
        self.setupData(param: param, isClear: true)
    }
    
    fileprivate func setupUI() {
        title = "我的直播"
        view.backgroundColor = .white
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(startBtn)
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.snp.makeConstraints { maker in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(-100)
        }
        tableView.mj_header = FFGifHeader(refreshingBlock: { [unowned self] in
            let param = LiveListRequstParam()
            param.page = 0
            param.limit = 20
            LiveListRequstParam.userId = self.userId
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
            LiveListRequstParam.userId = self.userId
            self.setupData(param: param, isClear: false)
        })
        
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(37)
            maker.right.equalTo(-37)
            maker.bottom.equalTo(-35)
            maker.height.equalTo(40)
        }
        
        startBtn.rx.tap
            .subscribe(onNext: { [weak  self] in
                self?.present(StartBroadcastVC(), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        setupEmptyView()
        setupShareView()
        setupShareAction()
         tableView.mj_footer.isAutomaticallyHidden = false
        
    }
    
    fileprivate func setupEmptyView() {
        emptyView.addSubview(icon)
        emptyView.addSubview(tipsLable)
        view.insertSubview(emptyView, aboveSubview: startBtn)
        emptyView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.top.equalTo(0)
        }
        icon.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(view)
            maker.top.equalTo(35.5)
        }
        tipsLable.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(icon)
            maker.top.equalTo(icon.snp.bottom).offset(32.5)
            
        }
        let emptyStartBtn = UIButton()
        emptyStartBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        emptyStartBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        emptyStartBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        emptyStartBtn.setTitle("开始直播", for: .normal)
        emptyStartBtn.setTitleColor(UIColor.white, for: .normal)
        emptyStartBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainColor), for: .disabled)
        emptyStartBtn.layer.cornerRadius = 22
        emptyStartBtn.layer.masksToBounds = true
        emptyView.addSubview(emptyStartBtn)
        emptyStartBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(37)
            maker.right.equalTo(-37)
            maker.top.equalTo(tipsLable.snp.bottom).offset(22)
            maker.height.equalTo(40)
        }
        emptyStartBtn.rx.tap
            .subscribe(onNext: { [weak  self] in
                self?.present(StartBroadcastVC(), animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        emptyView.isHidden = true
    }
    
    fileprivate func setupData(param: LiveListRequstParam, isClear: Bool) {
        HUD.show(true, show: "", enableUserActions: false, with: self)
        myBroadcastListVM.requestMybroadcastList(with: param, isClear: isClear)
        .then { (isSuccess) -> Void in
            self.tableView.reloadData()
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
    
    fileprivate func setupShareView() {
        shareView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: CustomKey.CustomSize.shareViewHight)
        view.insertSubview(shareView, aboveSubview: startBtn)
     
    }
    
    fileprivate func showAlter(with liveId: Int, at indexPath: IndexPath) {
        let alertVC = UIAlertController(title: "是否删除该直播数据", message: nil, preferredStyle: .alert)
        let cancle = UIAlertAction(title: "取消", style: .cancel) { (_) in }
        cancle.setValue(UIColor.black, forKey: "titleTextColor")
        let enter = UIAlertAction(title: "删除", style: .destructive) { (_) in
            self.myBroadcastListVM.delteBrocast(with: liveId)
                .then(execute: { _ -> Promise<Bool> in
                    let param = LiveListRequstParam()
                    param.page = 0
                    param.limit = 20
                    LiveListRequstParam.userId = self.userId
                    return self.myBroadcastListVM.requestMybroadcastList(with: param, isClear: true)
                })
                .always {
                    self.tableView.reloadData()
                }
                .catch(execute: { error in
                    if let error = error as? AppError {
                        self.view.makeToast(error.message)
                    }
                })
        }
        enter.setValue(UIColor(hex: CustomKey.Color.mainColor), forKey: "titleTextColor")
        alertVC.addAction(cancle)
        alertVC.addAction(enter)
        present(alertVC, animated: true, completion: nil)
    }
    
    fileprivate func setupShareAction() {
        let shareURL = CustomKey.URLKey.baseURL + "/live" + "/" + "\(userId)" + "/html"
        let shareName = "Test"
        let shareContext = "Test"
        shareView.weiBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.typeSinaWeibo, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)
        
        shareView.qqZoneBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeQZone, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)
        
        shareView.weiChatBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeWechatSession, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)
        
        shareView.qqBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeQQFriend, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)
        
        shareView.friendCircleBtn.rx.tap
            .subscribe(onNext: { (value) in
                guard let imaage = UIImage(named: "iPhone 6") else { return }
                Utils.sharePlateType(SSDKPlatformType.subTypeWechatTimeline, imageArray: [imaage], contentText: shareContext, shareURL: shareURL, shareTitle: shareName, andViewController: self, success: {_ in })
            })
            .disposed(by: self.disposeBag)

    }
}

extension MyBroadcastVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let group = myBroadcastListVM.listGroup.group else {
              return 0
        }
        tableView.mj_footer.isHidden = group.count < 20
        if group.isEmpty {
            emptyView.isHidden = false
        }
          return group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyBroacastCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let group = myBroadcastListVM.listGroup.group {
            let element = group[indexPath.row]
             cell.config(group[indexPath.row])
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
            cell.deleteAction = { [unowned self] in
                guard let liveId = element.liveId else {
                    return self.view.makeToast("直播Id为空")
                }
                self.showAlter(with: liveId, at: IndexPath(row: indexPath.row, section: 0))

            }
        }
        return cell
    }
}

extension MyBroadcastVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = myBroadcastListVM.listGroup.group?[indexPath.row] {
            let vcc = PlaybackViewController()
            vcc.video = model
            present(vcc, animated: true, completion: nil)
        }

    }
}
