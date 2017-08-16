//
//  LatestViewController.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LatestViewController: HomeBaseCollectionVC {
    fileprivate lazy var leastVM: LiveListViewModel = LiveListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setupRefresh()
        collectionView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension LatestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leastVM.listGroup.group?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CommonLiveCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configCellWirthLiveListModel(item: leastVM.listGroup.group?[indexPath.item] ?? LiveListModel(), rowType: .byNew)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let group = leastVM.listGroup.group else { return }
        let selectedRoom =  group[indexPath.item]
        if selectedRoom.type == .record {
            let playbackVC = PlaybackViewController()
            playbackVC.video = selectedRoom
            present(playbackVC, animated: true, completion: nil)
        } else { /// 是直播，则要筛选出所有数据
            let livigRooms = group.filter { $0.type == .living}
            let roomVC = RoomHomeViewController()
            roomVC.rooms = livigRooms
            roomVC.selectedRoom = group[indexPath.item]
            present(roomVC, animated: true, completion: nil)
        }
    }
}

extension LatestViewController {
    fileprivate func setupRefresh() {
        collectionView.mj_header = FFGifHeader(refreshingBlock: { [unowned self] in
            self.loadData()
        })
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[unowned self] in
            if let group = self.leastVM.moreListGroup.group {
                if group.count < 20 {
                    self.collectionView.mj_footer.endRefreshingWithNoMoreData()
                    return
                }
            }
            self.leastVM.currentPage += 1
            self.loadData(with: self.leastVM.currentPage)
        })
        collectionView.mj_header.beginRefreshing()
    }
    
    fileprivate func  loadData(with page: Int = 0) {
        param.orderBy = .byNew
        param.page = page
        weak var weakSelf = self
        HUD.show(true, show: "", enableUserActions: false, with: self)
        leastVM.requstList(with: param, isMoreRefresh: self.leastVM.currentPage != 0)
            .then(on: DispatchQueue.main, execute: {isSuccess -> Void in
            })
            .always { [unowned self] in
                weakSelf?.collectionView.mj_header.endRefreshing()
                weakSelf?.collectionView.mj_footer.endRefreshing()
                HUD.show(false, show: "", enableUserActions: false, with: self)
                /// 解决屏幕刷新时，闪烁问题
                UIView.performWithoutAnimation {
                    self.collectionView.reloadData()
                }
           }.catch { [unowned self ] error in
             if let error = error as? AppError {
                 self.view.makeToast(error.message)
            }
        }
    }
}
