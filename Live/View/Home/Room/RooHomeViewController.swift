//
//  RooHomeViewController.swift
//  Live
//
//  Created by lieon on 2017/7/4.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RooHomeViewController: BaseViewController {
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        taleView.separatorStyle = .none
        taleView.isPagingEnabled = true
        taleView.backgroundColor = UIColor(hex: 0xf2f2f2)
        taleView.register(RoomTableViewCell.self, forCellReuseIdentifier: "RoomTableViewCell")
        return taleView
    }()
    
    fileprivate lazy var containerView: UIView = UIView(frame: self.view.bounds)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension RooHomeViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        let items = Observable<[String]>.just(["1", "2", "3", "4", "5", "6"])
        items.bind(to: tableView.rx.items(cellIdentifier: "RoomTableViewCell", cellType: RoomTableViewCell.self)) { [unowned self] (row, element, cell) in
            cell.backgroundColor = UIColor.blue
            cell.roomVC.closeBtn.rx.tap
                .subscribe(onNext: { (value) in
                    self.dismiss(animated: true, completion: nil)
                })
                .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { (value) in
                
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension RooHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height
    }
}
