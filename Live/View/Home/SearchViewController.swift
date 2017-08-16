//
//  SearchViewController.swift
//  Live
//
//  Created by fanfans on 2017/7/12.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class SearchViewController: BaseViewController {
    fileprivate var searchVM: SearchViewModel = SearchViewModel()
    fileprivate var inputTF: UITextField = UITextField()
    fileprivate lazy var searchBtn: UIButton = {
        let searchBtn = UIButton()
        searchBtn.frame = CGRect(x: 0, y: 20, width: 44, height: 44)
        searchBtn.setImage(UIImage(named: "home_nav_search_white"), for: .normal)
        searchBtn.addTarget(self, action: #selector(self.searchTapAction), for: .touchUpInside)
        return searchBtn
    }()
    fileprivate lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x:UIScreen.width - 44, y: 20, width: 44, height: 44)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.addTarget(self, action: #selector(self.cancelTapAction), for: .touchUpInside)
        return cancelBtn
    }()
    fileprivate lazy var inputNavView: UIView = {[unowned self] in
        let inputNavView = UIView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width - 88, height: 44))
        let inputbgView: UIView = UIView(frame: CGRect(x: 0, y: 7, width: UIScreen.main.bounds.width - 150, height: 30))
        inputbgView.backgroundColor = UIColor(hex: 0x333333)
        inputbgView.layer.cornerRadius = 30 * 0.5
        inputbgView.layer.masksToBounds = true
        inputNavView.addSubview(inputbgView)
        self.inputTF = UITextField(frame: CGRect(x: 23, y: 0, width: 140, height: 30))
        self.inputTF.font = UIFont.systemFont(ofSize: 14)
        self.inputTF.placeholder = "输入昵称/ID"
        self.inputTF.returnKeyType = .search
        self.inputTF.delegate = self
        self.inputTF.textColor = .white
        self.inputTF.setValue(UIColor(hex: 0x999999), forKeyPath: "_placeholderLabel.textColor")
        inputbgView.addSubview(self.inputTF)
        return inputNavView
        }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(AttentionAndFansListCell.self, forCellReuseIdentifier: "AttentionAndFansListCell")
        taleView.register(SearchHistoryCell.self, forCellReuseIdentifier: "SearchHistoryCell")
        taleView.register(ClearAllHistoryCell.self, forCellReuseIdentifier: "ClearAllHistoryCell")
        return taleView
    }()
    fileprivate lazy var userListTableView: UITableView = {
        let userListTableView = UITableView()
        userListTableView.separatorStyle = .none
        userListTableView.backgroundColor = UIColor(hex: 0xfafafa)
        userListTableView.register(AttentionAndFansListCell.self, forCellReuseIdentifier: "AttentionAndFansListCell")
        return userListTableView
    }()
    fileprivate lazy var coverBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        btn.isHidden = true
        return btn
    }()
    fileprivate var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadRecomandList()
        getSearchHistoryArr()
        isFirstLoad = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad {
            isFirstLoad = false
            inputTF.becomeFirstResponder()
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTF.resignFirstResponder()
        coverBtn.isHidden = true
        search(text: textField.text)
        return true
    }
    
}

extension SearchViewController {
    fileprivate  func configUI() {
       
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(AttentionAndFansListCell.self, forCellReuseIdentifier: "AttentionAndFansListCell")
        view.backgroundColor = UIColor.white
        navigationItem.titleView = inputNavView
        self.inputTF.addTarget(self, action: #selector(self.textfieldEditing(textfield:)), for: .editingChanged)
        
        let leftBtnItem = UIBarButtonItem(customView: searchBtn)
        navigationItem.leftBarButtonItem = leftBtnItem
        
        let rightBtnItem = UIBarButtonItem(customView: cancelBtn)
        navigationItem.rightBarButtonItem = rightBtnItem
        tableView.delegate = self
        view.addSubview(tableView)
        
        userListTableView.dataSource = self
        userListTableView.delegate = self
        view.addSubview(userListTableView)
        view.addSubview(coverBtn)
        tableView.allowsSelection = true
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        userListTableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        userListTableView.isHidden = true
        
        coverBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        coverBtn.rx.tap
            .subscribe(onNext: { [weak self] in
              self?.inputTF.resignFirstResponder()
              self?.coverBtn.isHidden = true
            })
            .disposed(by: disposeBag)
        
        inputTF.rx.text
            .orEmpty
            .map { $0.characters.isEmpty }
            .bind(to: coverBtn.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    @objc fileprivate func textfieldEditing(textfield: UITextField) {
        if let text = textfield.text {
            if text.characters.isEmpty {
                self.userListTableView.isHidden = true
                self.tableView.isHidden = false
            }
        }
    }
    
    @objc fileprivate  func searchTapAction() {
        coverBtn.isHidden = true
        search(text: inputTF.text)
    }
    
    @objc fileprivate  func cancelTapAction() {
        inputTF.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func loadRecomandList() {
        HUD.show(true, show: "", enableUserActions: true, with: self)
        searchVM.requestRecommendList()
            .then { [unowned self] (usermodels) -> Void in
              self.searchVM.recommendUses = usermodels
              self.tableView.reloadData()
            }
            .always {
                HUD.show(false, show: "", enableUserActions: true, with: self)
            }
            .catch { _ in
                
        }
    }
    
    fileprivate func getSearchHistoryArr() {
        searchVM.getSearchHistory()
            .then { (historys) -> Void in
                self.searchVM.history = historys
                print(self.searchVM.history)
                self.tableView.reloadData()
            }.catch { (_) in
                
        }
    }
    
    fileprivate func search(text: String?) {
        let param = LiveListRequstParam()
        param.keywords = text
        HUD.show(true, show: "", enableUserActions: true, with: self)
        searchVM.requestSearchuUser(param: param)
            .then { [unowned self] (usermodels) -> Void in
                if !usermodels.isEmpty {
                   
                }
                self.searchVM.searchedUses = usermodels
                if let name = param.keywords {
                    self.searchVM.saveSearchHistory(name)
                }
                self.userListTableView.reloadData()
                self.userListTableView.isHidden = false
                self.tableView.isHidden = true
            }
            .always {
                HUD.show(false, show: "", enableUserActions: true, with: self)
            }
            .catch { [unowned self] (error) in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.userListTableView {
            let vc = UserInfoDetailsController()
            guard let model = searchVM.searchedUses?[indexPath.row] else {return}
            vc.anchorID = model.userId
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        if searchVM.history.isEmpty || indexPath.section == 1 {
            let vc = UserInfoDetailsController()
            guard let model = searchVM.recommendUses?[indexPath.row] else {return}
            vc.anchorID = model.userId
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if indexPath.row == searchVM.history.count {//清除历史搜索记录
                searchVM.clearHistory()
                self.getSearchHistoryArr()
            } else {
                self.inputTF.text = searchVM.history[indexPath.row]
                self.search(text: searchVM.history[indexPath.row])
            }
        }
    }
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
        if searchVM.history.isEmpty || section == 1 {
            tipsLable.text = "您可能感兴趣的用户"
        } else {
            tipsLable.text = "近期搜索"
        }
        if tableView == self.userListTableView {
            tipsLable.text = "共搜索到\(self.searchVM.searchedUsersCount)个人"
        }
        tipsLable.font = UIFont.systemFont(ofSize: 12)
        tipsLable.textColor = UIColor(hex:0x999999)
        sectionView.addSubview(tipsLable)
        return sectionView
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.userListTableView {
            return 1
        }
        return searchVM.history.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.userListTableView {
            return searchVM.searchedUses?.count ?? 0
        }
        if section == 0 {
            if searchVM.history.isEmpty {
                return searchVM.recommendUses?.count ?? 0
            }
            return searchVM.history.count + 1
        } else {
            return searchVM.recommendUses?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.userListTableView {
            let cell: AttentionAndFansListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            guard let element = searchVM.searchedUses?[indexPath.row] else {return UITableViewCell()}
            cell.config(element)
            cell.attentAction = {
                weak var weaSelf = self
                    guard let weakSelf = weaSelf else { return }
                    let attentVM = RoomViewModel()
                    let param = CollectionRequstParam()
                    param.userId = element.userId
                    if element.isFollowed {
                        /// 取消关注
                        attentVM.cancleCollectionLiver(with: param)
                            .then(execute: { _ -> Void in
                                self.view.makeToast("取消关注成功")
                                if let inputText = weakSelf.inputTF.text, inputText.isEmpty {
                                    weakSelf.loadRecomandList()
                                } else {
                                    weakSelf.search(text: weakSelf.inputTF.text)
                                }
                            }).catch(execute: { (error) in
                                if let error = error as? AppError {
                                    weakSelf.view.makeToast(error.message)
                                }
                            })
                    } else {
                        /// 关注
                        attentVM.collectionLiver(with: param)
                            .then(execute: { _ -> Void in
                                 self.view.makeToast("关注成功")
                                if let inputText = weakSelf.inputTF.text, inputText.isEmpty {
                                    weakSelf.loadRecomandList()
                                } else {
                                    weakSelf.search(text: weakSelf.inputTF.text)
                                }
                            }).catch(execute: { (error) in
                                if let error = error as? AppError {
                                    weakSelf.view.makeToast(error.message)
                                }
                            })
                    }
                }
            return cell
        }
        if searchVM.history.isEmpty || indexPath.section == 1 {
            let cell: AttentionAndFansListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            guard let element = searchVM.recommendUses?[indexPath.row] else {return UITableViewCell()}
            cell.config(element)
            cell.attentAction = {
                weak var weaSelf = self
                guard let weakSelf = weaSelf else { return }
                    let attentVM = RoomViewModel()
                    let param = CollectionRequstParam()
                    param.userId = element.userId
                    if element.isFollowed {
                        /// 取消关注
                        attentVM.cancleCollectionLiver(with: param)
                            .then(execute: { _ -> Void in
                                self.view.makeToast("取消关注成功")
                                if let inputText = weakSelf.inputTF.text, inputText.isEmpty {
                                    weakSelf.loadRecomandList()
                                } else {
                                    weakSelf.search(text: weakSelf.inputTF.text)
                                }
                            }).catch(execute: { (error) in
                                if let error = error as? AppError {
                                    weakSelf.view.makeToast(error.message)
                                }
                            })
                    } else {
                        /// 关注
                        attentVM.collectionLiver(with: param)
                            .then(execute: { _ -> Void in
                                 self.view.makeToast("关注成功")
                                if let inputText = weakSelf.inputTF.text, inputText.isEmpty {
                                    weakSelf.loadRecomandList()
                                } else {
                                    weakSelf.search(text: weakSelf.inputTF.text)
                                }
                            }).catch(execute: { (error) in
                                if let error = error as? AppError {
                                    weakSelf.view.makeToast(error.message)
                                }
                            })
                    }
                }
            return cell
        }
        if indexPath.section == 0 {
            if indexPath.row == searchVM.history.count {
                let cell: ClearAllHistoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.selectionStyle = .none
                return cell
            } else {
                let cell: SearchHistoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.nameLable.text = searchVM.history[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.inputTF.resignFirstResponder()
    }
}
