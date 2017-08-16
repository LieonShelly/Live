//
//  AttentionAndFansListController.swift
//  Live
//
//  Created by fanfans on 2017/7/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AttentionAndFansListController: BaseViewController {
    var userID: String?
    fileprivate lazy var attenVM: AttentionAndFansListViewModel = AttentionAndFansListViewModel()
    fileprivate var type: UserListType = .fans
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(AttentionAndFansListCell.self, forCellReuseIdentifier: "AttentionAndFansListCell")
        return taleView
    }()
    fileprivate lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, UserModel>>()
    
    convenience init(type: UserListType) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupEmptyView()
        loadData()
        setupTableView()
    }
}

extension AttentionAndFansListController {
    fileprivate func setupEmptyView() {
        let tipsLable = UILabel()
        tipsLable.text = "哆哆互动点赞评论，人气会旺哦"
        tipsLable.font = UIFont.systemFont(ofSize: 13)
        tipsLable.textAlignment = .center
        tipsLable.textColor = UIColor(hex: 0x999999)
        let icon = UIImageView()
        icon.image = UIImage(named: "gou")
        view.insertSubview(emptyView, aboveSubview: tableView)
        emptyView.addSubview(icon)
        emptyView.addSubview(tipsLable)
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
        emptyView.isHidden = true
    }
    
    fileprivate func configUI() {
        title = self.type.title
        view.addSubview(tableView)
        tableView.allowsSelection = true
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
         tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    fileprivate func setupTableView() {
        dataSource.configureCell = { (_, tableView, indexPath, element) in
            let cell: AttentionAndFansListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let element = self.attenVM.listGroup.listGroup?[indexPath.row] {
                cell.config(element)
                cell.attentAction = { [unowned self] in
                    let attentVM = RoomViewModel()
                    let param = CollectionRequstParam()
                    param.userId = element.userId
                    if element.isFollowed {
                        /// 取消关注
                        attentVM.cancleCollectionLiver(with: param)
                            .then(execute: { isSuccess -> Void in
                                if !isSuccess {
                                    return
                                }
                                self.loadData()
                            }).catch(execute: { (error) in
                                if let error = error as? AppError {
                                    self.view.makeToast(error.message)
                                }
                            })
                    } else {
                        /// 关注
                        attentVM.collectionLiver(with: param)
                            .then(execute: { isSuccess -> Void in
                                if !isSuccess {
                                    return
                                }
                                self.loadData()
                            }).catch(execute: { (error) in
                                if let error = error as? AppError {
                                    self.view.makeToast(error.message)
                                }
                            })
                    }

                }
            }
             return cell
        }
        
        tableView.rx
            .modelSelected(UserModel.self)
            .subscribe(onNext: { [weak self] (model) in
                let vc = UserInfoDetailsController()
                vc.anchorID = model.userId
                self?.navigationController?.pushViewController(vc, animated: true)
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
    }
    
    fileprivate func loadData() {
        let prams: UserListRequstParam = UserListRequstParam()
        prams.type = type
        guard let id = userID, let intID = Int(id) else { return }
        prams.userId = intID
        attenVM.requstList(with: prams)
            .then {[unowned self] isSuccess -> Void in
                if isSuccess {
                    let items =  Observable.just([
                        SectionModel(model: "First section", items: self.attenVM.listGroup.listGroup ?? [UserModel]())
                        ])
                    Observable<[UserModel]>.just(self.attenVM.listGroup.listGroup ?? [UserModel]())
                        .map {$0.isEmpty}
                        .bind(to: self.tableView.rx.isHidden)
                        .disposed(by: self.disposeBag)
                    Observable<[UserModel]>.just(self.attenVM.listGroup.listGroup ?? [UserModel]())
                            .map {!$0.isEmpty}
                            .bind(to: self.emptyView.rx.isHidden)
                            .disposed(by: self.disposeBag)
                    
                    items.bind(to: self.tableView.rx.items(dataSource: self.dataSource))
                        .disposed(by: self.disposeBag)
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

extension AttentionAndFansListController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 32))
        sectionView.backgroundColor = UIColor(hex: 0xfafafa)
        let tipsLable: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.width - 10, height: 32))
        tipsLable.text = "您可能感兴趣的用户"
        tipsLable.font = UIFont.systemFont(ofSize: 12)
        tipsLable.textColor = UIColor(hex:0x999999)
        sectionView.addSubview(tipsLable)
        return sectionView
    }
    
}

private func setupItems() -> Observable<[String]> {
    let items = Observable<[String]>.just(["1", "1", "1", "1", "1", "1"])
    return items
}
