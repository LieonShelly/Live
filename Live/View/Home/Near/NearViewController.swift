//
//  NearViewController.swift
//  Live
//
//  Created by lieon on 2017/6/20.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NearViewController: HomeBaseCollectionVC {
    fileprivate lazy var leastVM: LiveListViewModel = LiveListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupRefresh()
    }
}

extension NearViewController {
    fileprivate func setupRefresh() {
        collectionView.rx
            .modelSelected(LiveListModel.self)
            .subscribe(onNext: { [weak self](selecteModel) in
                guard let group = self?.leastVM.listGroup.group else { return }
                if selecteModel.type == .record {
                    let playbackVC = PlaybackViewController()
                    playbackVC.video = selecteModel
                    self?.present(playbackVC, animated: true, completion: nil)
                } else { /// 是直播，则要筛选出所有数据
                    let livigRooms = group.filter { $0.type == .living}
                    let roomVC = RoomHomeViewController()
                    roomVC.rooms = livigRooms
                    roomVC.selectedRoom = selecteModel
                    self?.present(roomVC, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
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
        param.longitude = LocationViewModel.share.longitude
        param.latitude = LocationViewModel.share.latitude
        param.page = page
        param.limit = 20
        weak var weakSelf = self
        HUD.show(true, show: "", enableUserActions: false, with: self)
        leastVM.requestNearByList(with: param, isMoreRefresh: self.leastVM.currentPage != 0)
            .then(on: DispatchQueue.main, execute: {isSuccess -> Void in

            })
            .always { [unowned self] in
                weakSelf?.collectionView.mj_header.endRefreshing()
                weakSelf?.collectionView.mj_footer.endRefreshing()
                HUD.show(false, show: "", enableUserActions: false, with: self)
                /// 解决屏幕刷新时，闪烁问题
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                    self.setupDataSource(Observable<[LiveListModel]>.just(self.leastVM.listGroup.group ?? [LiveListModel]()))
                })
            }.catch { [unowned self ] error in
                if let error = error as? AppError {
                    self.view.makeToast(error.message)
                }
        }
    }
    fileprivate func setupDataSource(_ items: Observable<[LiveListModel]>) {
        items
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell: CommonLiveCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configCellWirthLiveListModel(item:element, rowType: .byNearby)
                return cell
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(LiveListModel.self)
            .subscribe(onNext: { (model) in
                
            })
            .disposed(by: disposeBag)
    }
}
