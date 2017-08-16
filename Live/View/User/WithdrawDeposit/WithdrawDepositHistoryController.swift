//
//  WithdrawDepositHistoryController.swift
//  Live
//
//  Created by fanfans on 2017/7/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit

class WithdrawDepositHistoryController: BaseViewController {
    fileprivate var moneyVM: EarningsViewModel = EarningsViewModel()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView(frame: CGRect(), style: .plain)
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(WithdrawDepositHistoryCell.self, forCellReuseIdentifier: "WithdrawDepositHistoryCell")
        return taleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0xfafafa)
        self.title = "提现记录"
        view.addSubview(tableView)
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
      
        tableView.mj_header = FFGifHeader(refreshingBlock: { [unowned self] in
            let param = MoneyInoutRecordParam()
            param.page = 0
            param.limit = 20
            param.type = .withdraw
            self.moneyVM.requestMoneyRecord(with: param)
            .then(execute: { (response) -> Void in
                self.moneyVM.moneyReocod = response.object?.list
                self.tableView.reloadData()
            })
            .always {
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
            }
            .catch(execute: { (error) in
                
            })
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[unowned self] in
            if self.moneyVM.lastRequstCount < 20 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            let param = MoneyInoutRecordParam()
            param.page = self.moneyVM.currentPage + 1
            param.limit = 20
            param.type = .withdraw
            self.moneyVM.requestMoneyRecord(with: param)
                .then(execute: { (response) -> Void in
                    guard let refreshGroup = response.object?.list else { return }
                    if let _ = self.moneyVM.moneyReocod {
                         self.moneyVM.moneyReocod?.append(contentsOf: refreshGroup)
                         self.moneyVM.lastRequstCount = refreshGroup.count
                    } else {
                        self.moneyVM.moneyReocod = refreshGroup
                    }
                    self.tableView.reloadData()
                })
                .always {
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                }
                .catch(execute: { (error) in
                    if  self.moneyVM.currentPage > 0 {
                        self.moneyVM.currentPage -= 1
                    }
                })
        })
      tableView.mj_header.beginRefreshing()
    }
}

extension WithdrawDepositHistoryController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyVM.moneyReocod?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WithdrawDepositHistoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        if indexPath.row < (moneyVM.moneyReocod?.count ?? 0) {
            cell.config(moneyVM.moneyReocod?[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
