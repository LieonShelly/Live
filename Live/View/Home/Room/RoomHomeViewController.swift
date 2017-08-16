//
//  RoomHomeViewController.swift
//  Live
//
//  Created by lieon on 2017/7/8.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RoomHomeViewController: BaseViewController {
    var rooms: [LiveListModel]?
    var selectedRoom: LiveListModel?
    var coverImage: UIImage?
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        taleView.separatorStyle = .none
        taleView.isPagingEnabled = true
        taleView.alwaysBounceVertical = true
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
    
    deinit {
        print("**********")
    }
}

extension RoomHomeViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        guard let rooms = rooms else {
            return
        }
        for room in rooms {
            let rooomVC = RoomViewController()
            rooomVC.roomVM.room = room
            addChildViewController(rooomVC)
        }
        guard let chilidVCs = childViewControllers as? [RoomViewController] else {
            return
        }
        let items = Observable<[RoomViewController]>.just(chilidVCs)
        items.bind(to: tableView.rx.items(cellIdentifier: "RoomTableViewCell", cellType: RoomTableViewCell.self)) { [unowned self] (row, childVC, cell) in
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            childVC.view.frame = cell.bounds
            cell.contentView.addSubview(childVC.view)
            childVC.closeBtn.rx.tap
                .subscribe(onNext: { (value) in
                    self.dismiss(animated: true, completion: nil)
                })
                .disposed(by: self.disposeBag)
            
        }
            .disposed(by: disposeBag)
    
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        if let selectedRoom = selectedRoom {
            for (index, model) in rooms.enumerated() {
                if model.liveId == selectedRoom.liveId {
                    tableView.isScrollEnabled = false
                    tableView.setContentOffset(CGPoint(x: 0, y: UIScreen.height * CGFloat(index)), animated: true)
                    break
                }
            }
            
        }
    }
    
}

extension RoomHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height
    }
}
